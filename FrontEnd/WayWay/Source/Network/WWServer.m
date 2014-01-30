//
//  WWServer.m
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

NSString * const WWServerErrorDomain = @"WWServerErrorDomain";

static WWServer* theWWServer = nil;

@interface WWServer ()

@end

@implementation WWServer

#pragma mark - Initialization

- (id) initWithRoolUrl:(NSString*)rootUrl
{
    self = [super init];
    
    if (self)
    {
        self.rootServerUrl = rootUrl;
    }
    
    return self;
}

+ (WWServer*) sharedInstance
{
    if (theWWServer == nil)
    {
        theWWServer = [[WWServer alloc] initWithRoolUrl:WW_BASE_URL];
    }
    
    return theWWServer;
}

#pragma mark - User Account Management

- (void) handleLoginResponse:(UUHttpClientResponse*)response
                      notify:(BOOL)notify
           completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    //WWDebugLog(@"response: %@", response.parsedResponse);
    
    WWUser* user = nil;
    
    if (response.httpError == nil && response.parsedResponse != nil)
    {
        user = [WWUser userFromDictionary:response.parsedResponse];
        [WWSettings setCurrentUser:user];
        
        if (notify)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_CURRENT_USER_UPDATED_NOTIFICATION object:user];
        }
        
        [WWAppDelegate registerForPushNotifications];
    }
    
    if (completionHandler)
    {
        completionHandler(response.httpError, user);
    }
}

- (UUHttpClient*) facebookLogin:(NSString*)accessToken
          accessTokenExpiration:(NSDate*)accessTokenExpiration
              completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    [Flurry logEvent:WW_FLURRY_EVENT_LOGIN_FACEBOOK];
    
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:accessToken forKey:@"facebook_auth_token"];
    [d setValue:[WWDateFormatter dateToRfc3339String:accessTokenExpiration] forKey:@"facebook_token_expire_at"];
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"users/facebook_create"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        [self handleLoginResponse:response notify:YES completionHandler:completionHandler];
    }];
}

- (NSString*) makePasswordHash:(NSString*)email password:(NSString*)password
{
    NSString* input = [NSString stringWithFormat:@"%@%@", [email lowercaseString], password];
    
    unsigned char output[32];
    CC_SHA256([input UTF8String], [input lengthOfBytesUsingEncoding:NSUTF8StringEncoding], output);
    
    NSData* data = [NSData dataWithBytes:output length:32];
    data = [data subdataWithRange:NSMakeRange(10, 16)];
    return [data wwToHexString];
}

- (UUHttpClient*) emailLogin:(NSString*)email
                    password:(NSString*)password
           completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    [Flurry logEvent:WW_FLURRY_EVENT_LOGIN_EMAIL];
    
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:email forKey:@"email"];
    [d setValue:[self makePasswordHash:email password:password] forKey:@"password"];
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"sessions"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        [self handleLoginResponse:response notify:YES completionHandler:completionHandler];
    }];
}

- (UUHttpClient*) registerUser:(NSString*)email
                      password:(NSString*)password
                      fullName:(NSString*)fullName
             completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    [Flurry logEvent:WW_FLURRY_EVENT_REGISTER_EMAIL];
    
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:email forKey:@"email"];
    [d setValue:fullName forKey:@"full_name"];
    [d setValue:[self makePasswordHash:email password:password] forKey:@"password"];
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"users"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        [self handleLoginResponse:response notify:YES completionHandler:completionHandler];
    }];
}

- (UUHttpClient*) uploadPushToken:(WWUser*)user token:(NSString*)token completion:(void (^)(NSError* error))completion
{
    NSString* url = [self.rootServerUrl stringByAppendingString:@"register_push_token"];
    
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:user.identifier forKey:@"userId"];
    [d setValue:token forKey:@"pushToken"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        if (completion)
        {
            completion(response.httpError);
        }
    }];
}

#pragma mark - Account Linking

- (UUHttpClient*) user:(WWUser*)user
   linkFacebookAccount:(NSString*)accessToken
 accessTokenExpiration:(NSDate*)accessTokenExpiration
     completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:accessToken forKey:@"facebook_auth_token"];
    [d setValue:[WWDateFormatter dateToRfc3339String:accessTokenExpiration] forKey:@"facebook_token_expire_at"];
    return [self user:user updateFields:d completion:completionHandler];
}

- (UUHttpClient*) clearFacebookAuthForUser:(WWUser*)user completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:@"" forKey:@"facebook_auth_token"];
    [d setValue:@"" forKey:@"facebook_token_expire_at"];
    return [self user:user updateFields:d completion:completionHandler];
}

- (UUHttpClient*) clearTwitterAuthForUser:(WWUser*)user completionHandler:(void (^)(NSError* error, WWUser* updatedUser))completionHandler
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:@"" forKey:@"twitter_auth_access_key"];
    [d setValue:@"" forKey:@"twitter_auth_secret_key"];
    return [self user:user updateFields:d completion:completionHandler];
}

- (UUHttpClient*) user:(WWUser*)user updateFields:(NSDictionary*)fields completion:(void (^)(NSError* error, WWUser* user))completion
{
    NSString* resourcePath = [NSString stringWithFormat:@"users/%@", user.identifier];
    NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];
    
    //WWDebugLog(@"Updating User\nURL: %@\nArgs: %@", url, fields);
    
    return [self put:url queryArguments:nil putBody:[self toJsonData:fields] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse *response)
    {
        [self handleLoginResponse:response notify:NO completionHandler:completion];
    }];
}


#pragma mark - Search
//Places
- (UUHttpClient*) beginSearchPlaces:(WWSearchArgs*)searchArgs completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    return [self beginSearch:searchArgs endPoint:@"places" responseClass:@"WWPlace" completionHandler:completionHandler];
}

- (UUHttpClient*) fetchNextPlacesPage:(NSString*)fullUrl completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    return [self fetchNextPage:fullUrl responseClass:@"WWPlace" completionHandler:completionHandler];
}

//Pictures
- (UUHttpClient*) beginFetchPlacePictures:(WWPlace*)place filter:(WWPhotoFilter)filter completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSMutableArray* parts = [NSMutableArray array];
    [parts addObject:@"places"];
    [parts addObject:place.identifier.stringValue];
    
    NSString* responseClass;
    NSDictionary* args = [NSMutableDictionary dictionary];

    responseClass = @"WWPhoto";
        
    [parts addObject:@"photos"];
    [parts addObject:@"page"];
    [parts addObject:@"1"];
        
    [args setValue:[WWPhoto photoFilterName:filter] forKey:@"category"];
    
    NSString* resourcePath = [self buildRequestPath:parts];
    
    return [self getPagedList:resourcePath queryStringArgs:args responseClass:responseClass completionHandler:completionHandler];
}

- (UUHttpClient*) fetchNextPicturesPage:(NSString*)fullUrl filter:(WWPhotoFilter)filter completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSString* responseClass = @"WWPhoto";
    return [self fetchNextPage:fullUrl responseClass:responseClass completionHandler:completionHandler];
}


//Hashtags
- (UUHttpClient*) beginFetchPlaceHashtags:(WWPlace*)place
                                  hashtag:(NSString*)hashtag
                        completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSString* responseClass;
    responseClass = @"WWHashtag";
    
    NSMutableArray* parts = [NSMutableArray array];
    [parts addObject:@"places"];
    [parts addObject:place.identifier.stringValue];
    [parts addObject:@"hashtags"];
    [parts addObject:@"page"];
    [parts addObject:@"0"];
    NSString* resourcePath = [self buildRequestPath:parts];
    
    NSDictionary* args = [NSMutableDictionary dictionary];
    if(hashtag)
    {
        args = @{@"hashtag" : hashtag};
    }
    
    
    return [self getPagedList:resourcePath queryStringArgs:args responseClass:responseClass completionHandler:completionHandler];
}

- (UUHttpClient*) fetchNextHashtagPage:(NSString*)fullUrl
                     completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSString* responseClass = @"WWHashtag";
    
    return [self fetchNextPage:fullUrl responseClass:responseClass completionHandler:completionHandler];
}

- (UUHttpClient*) beginFetchPlacePictures:(WWPlace*)place hashTag:(NSString*)hashTag completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSArray* parts =
  @[
        @"places",
        place.identifier.stringValue,
        @"photos",
        @"page",
        @"1"
    ];
    
    NSDictionary* args = @{@"hashtag" : hashTag};
    
    NSString* resourcePath = [self buildRequestPath:parts];
    
    return [self getPagedList:resourcePath queryStringArgs:args responseClass:@"WWPhoto" completionHandler:completionHandler];
}

- (UUHttpClient*) fetchNextPicturesHashTagPage:(NSString*)fullUrl completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    return [self fetchNextPage:fullUrl responseClass:@"WWPhoto" completionHandler:completionHandler];
}

//SEARCH
- (UUHttpClient*) beginSearch:(WWSearchArgs*)searchArgs
                     endPoint:(NSString*)endPoint
                responseClass:(NSString*)responseClass
            completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSMutableDictionary* args = [NSMutableDictionary dictionary];
    
    WWUser* user = [WWSettings currentUser];
    if (user)
    {
        [args setValue:user.identifier forKey:@"user_id"];
    }
    
    //Combine for multiple categories
    BOOL isAutoCompleteCategory = [searchArgs.autoCompleteType isEqualToString:@"category"];
    if (searchArgs.autoCompleteType && searchArgs.autoCompleteArg && !isAutoCompleteCategory)
    {
        [args setValue:searchArgs.autoCompleteArg forKey:searchArgs.autoCompleteType];
    }
    
    if(!isAutoCompleteCategory)
    {
        [args setValue:[searchArgs selectedCategories] forKey:@"category"];
    }
    else if(searchArgs.autoCompleteArg)
    {
        NSString* categoryString = searchArgs.autoCompleteArg;
        if([searchArgs selectedCategories])
            categoryString = [NSString stringWithFormat:@"%@,%@", categoryString, [searchArgs selectedCategories]];
       
        [args setValue:categoryString forKey:@"category"];
    }
    
    [args setValue:searchArgs.trendingOnly forKey:@"trending"];
    [args setValue:[searchArgs selectedPrices] forKey:@"price"];
    
    [args setValue:searchArgs.minlatitude forKey:@"min_latitude"];
    [args setValue:searchArgs.maxlatitude forKey:@"max_latitude"];
    [args setValue:searchArgs.minlongitude forKey:@"min_longitude"];
    [args setValue:searchArgs.maxlongitude forKey:@"max_longitude"];
    
    NSArray* parts = @[endPoint, @"page", @"1"];
    NSString* resourcePath = [self buildRequestPath:parts];
    
    /*
    if ([@"places" isEqualToString:endPoint])
    {
        NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];
        NSDictionary* logParams = @{@"args":args,@"url":url};
        [Flurry logEvent:WW_FLURRY_EVENT_SEARCH_PLACES withParameters:logParams];
    }*/
    
    return [self getPagedList:resourcePath queryStringArgs:args responseClass:responseClass completionHandler:completionHandler];
}

- (UUHttpClient*) fetchNextPage:(NSString*)fullUrl
                  responseClass:(NSString*)responseClass
              completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    return [self get:fullUrl queryArguments:nil completionHandler:^(UUHttpClientResponse* response)
    {
        [self parsePagedSearchResponse:response responseClass:responseClass completionHandler:completionHandler];
    }];
}

#pragma mark - Favorites

- (UUHttpClient*) user:(WWUser*)user
        updateFavorite:(WWPlace*)place
            completion:(void (^)(NSError* error))completion
{
    NSMutableArray* parts = [NSMutableArray array];
    [parts addObject:@"users"];
    [parts addObject:user.identifier.stringValue];
    [parts addObject:@"user_favorites"];
    
    int curCount = 0;
    if (user.favoriteCount)
    {
        curCount = user.favoriteCount.integerValue;
    }
    
    if (!place.isFavorite.boolValue)
    {
        [parts addObject:@"delete_favorite"];
        --curCount;
        if (curCount < 0)
        {
            curCount = 0;
        }
    }
    else
    {
        ++curCount;
    }
    
    [WWPlace updateCachedPlace:place];
    
    user.favoriteCount = @(curCount);
    [WWSettings setCurrentUser:user];
    
    NSString* resourcePath = [self buildRequestPath:parts];
    NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];

    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:place.identifier forKey:@"place_id"];
    
    UUHttpClientRequest* request = [[UUHttpClientRequest alloc] initWithUrl:url];
    request.queryArguments = [self appendDeviceInfo:d];
    request.httpMethod = place.isFavorite.boolValue ? UUHttpMethodPost : UUHttpMethodDelete;
    
    return [UUHttpClient executeRequest:request completionHandler:^(UUHttpClientResponse *response)
    {
        //WWDebugLog(@"Response: %@", response.parsedResponse);
        
        if (completion)
        {
            completion(response.httpError);
        }
    }];
}

- (UUHttpClient*) listUserFavorites:(WWUser*)user
                  completionHandler:(void (^)(NSError* error, WWPagedSearchResults* results))completionHandler
{
    NSArray* parts =
    @[
      @"users",
      user.identifier.stringValue,
      @"user_favorites",
      ];
    
    NSString* resourcePath = [self buildRequestPath:parts];
    
    return [self getPagedList:resourcePath queryStringArgs:nil responseClass:@"WWPlace" completionHandler:completionHandler];
}

#pragma mark - Text Search

- (UUHttpClient*) queryTextSearch:(NSString*)query
                         hashTags:(BOOL)searchHashTags
                   withSearchArgs:(WWSearchArgs*)searchArgs
                       completion:(void (^)(NSError* error, NSArray* results))completion
{
    NSDictionary* args = [NSMutableDictionary dictionary];
    [args setValue:query forKey:@"query"];
    
    if (searchHashTags)
    {
        [args setValue:@"true" forKey:@"hashtags"];
    }
    if(searchArgs.minlatitude && searchArgs.maxlatitude && searchArgs.minlongitude && searchArgs.maxlongitude)
    {
        [args setValue:searchArgs.minlatitude forKey:@"min_latitude"];
        [args setValue:searchArgs.maxlatitude forKey:@"max_latitude"];
        [args setValue:searchArgs.minlongitude forKey:@"min_longitude"];
        [args setValue:searchArgs.maxlongitude forKey:@"max_longitude"];
    }
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"search/autocomplete"];
    
    WWDebugLog(@"Autocomplete query with args:\n%@\n", args);
    
    return [self get:url queryArguments:args completionHandler:^(UUHttpClientResponse *response)
    {
        WWDebugLog(@"\nAuto-complete response from server:\n%@\n", response.parsedResponse);
        
        NSMutableArray* parsedResults = nil;
        
        if (!response.httpError && response.parsedResponse)
        {
            if ([response.parsedResponse isKindOfClass:[NSArray class]])
            {
                parsedResults = [NSMutableArray array];
                
                for (id node in response.parsedResponse)
                {
                    WWAutoCompleteResult* obj = [WWAutoCompleteResult fromDictionary:node];
                    if (obj)
                    {
                        if (searchHashTags)
                        {
                            obj.type = @"hashtag";
                        }
                        
                        [parsedResults addObject:obj];
                    }
                }
            }
            
        }
        
        if (completion)
        {
            completion(response.httpError, parsedResults);
        }
    }];
}

- (UUHttpClient*) queryLocationSearch:(NSString*)query
                            mapRegion:(MKCoordinateRegion)mapRegion
                           completion:(void (^)(NSError* error, NSArray* results))completion
{
    NSDictionary* args = [NSMutableDictionary dictionary];
    [args setValue:query forKey:@"query"];
  
    NSString* url = [self.rootServerUrl stringByAppendingString:@"search/areas"];
    
    WWDebugLog(@"Location Autocomplete query with args:\n%@\n", args);
    
    return [self get:url queryArguments:args completionHandler:^(UUHttpClientResponse *response)
    {
        WWDebugLog(@"\nLocation Auto-complete response from server:\n%@\n", response.parsedResponse);
        
        NSArray* parsedResults = nil;
        
        if (!response.httpError && response.parsedResponse)
        {
            parsedResults = [WWArea fromArray:response.parsedResponse];
        }
        
        if (completion)
        {
            completion(response.httpError, parsedResults);
        }
    }];
}

#pragma mark - Menu Lookup

// Menu
- (UUHttpClient*) listMenus:(WWPlace*)place
                 completion:(void (^)(NSError* error, NSArray* results))completion
{
    //NSString* url = @"http://api.singleplatform.co/locations/haru-7/menu?client=cda1k3jtd73h52nxbenjw15fv&sig=lY6r4iVPYxdMipoyGp2yPQp8j_s";
    
    NSArray* parts =
    @[
      @"places",
      place.identifier.stringValue,
      @"menus"
      ];
    
    NSString* resourcePath = [self buildRequestPath:parts];
    NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];
    
    return [self get:url queryArguments:nil completionHandler:^(UUHttpClientResponse *response)
    {
        NSArray* parsedResults = nil;
        
        if (!response.httpError && response.parsedResponse)
        {
            parsedResults = [WWMenu fromArray:response.parsedResponse];
            
            /*
            id menusNode = [response.parsedResponse wwNonNullValueForKey:@"menus"];
            if (menusNode)
            {
                parsedResults = [WWMenu fromArray:menusNode];
            }*/
        }
        
        if (completion)
        {
            completion(response.httpError, parsedResults);
        }
    }];
}

#pragma mark - Categories
- (UUHttpClient*) getStaticCategories:(void(^)(NSError* error, NSArray* results))completion
{
    NSArray* parts = @[@"categories"];
    NSString* resourcePath = [self buildRequestPath:parts];
    
    NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];
    
    return [self get:url queryArguments:nil completionHandler:^(UUHttpClientResponse *response)
     {
         if (!response.httpError && response.parsedResponse)
         {
            NSError* error = response.httpError;
            NSArray* parsedResults = response.parsedResponse;
             
            completion(error, parsedResults);
         }
     }];
}

#pragma mark - Bad Photos

- (UUHttpClient*) reportBadPhoto:(NSNumber*)photoId completion:(void (^)(NSError* error))completion
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:photoId forKey:@"photo_id"];
    
    WWUser* user = [WWSettings currentUser];
    if (user)
    {
        [d setValue:user.identifier forKey:@"user_id"];
    }
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"bad_photos"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        //WWDebugLog(@"ParsedResponse:\n%@", response.parsedResponse);
        
        if (completion)
        {
            completion(response.httpError);
        }
    }];
}

#pragma mark - Forgot Password

- (UUHttpClient*) forgotPassword:(NSString*)email completion:(void (^)(NSError* error))completion
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:email forKey:@"email"];
    
    NSString* url = [self.rootServerUrl stringByAppendingString:@"forgot_password"];
    
    return [self post:url queryArguments:nil postBody:[self toJsonData:d] contentType:kUUContentTypeApplicationJson completionHandler:^(UUHttpClientResponse* response)
    {
        //WWDebugLog(@"ParsedResponse:\n%@", response.parsedResponse);
        
        if (completion)
        {
            completion(response.httpError);
        }
    }];
}

#pragma mark - Private

- (UUHttpClient*) getList:(NSString*)resourcePath
          queryStringArgs:(NSDictionary*)queryStringArgs
            responseClass:(NSString*)className
        completionHandler:(void (^)(NSError* error, NSArray* results))completionHandler
{
    return [self getPagedList:resourcePath
              queryStringArgs:queryStringArgs
                responseClass:className
            completionHandler:^(NSError *error, WWPagedSearchResults *pagedResults)
    {
        if (completionHandler)
        {
            completionHandler(error, pagedResults.data);
        }
    }];
}


- (UUHttpClient*) getPagedList:(NSString*)resourcePath
               queryStringArgs:(NSDictionary*)queryStringArgs
                 responseClass:(NSString*)className
             completionHandler:(void (^)(NSError* error, WWPagedSearchResults* pagedResults))completionHandler
{
    NSString* url = [self.rootServerUrl stringByAppendingString:resourcePath];
    
    WWDebugLog(@"getting resource at path: %@, args:\n%@", resourcePath, queryStringArgs);
    
    return [self get:url queryArguments:queryStringArgs completionHandler:^(UUHttpClientResponse* response)
    {
        [self parsePagedSearchResponse:response responseClass:className completionHandler:completionHandler];
    }];
}

- (void) parsePagedSearchResponse:(UUHttpClientResponse*)serverResponse
                    responseClass:(NSString*)className
                completionHandler:(void (^)(NSError* error, WWPagedSearchResults* pagedResults))completionHandler
{
    //WWDebugLog(@"\nHeaders:\n%@\nError:\n%@\nResponse:\n%@\n", responseHeaders, serverError, serverResponse);
    
    WWPagedSearchResults* pagedResults = [WWPagedSearchResults new];
    
    NSMutableArray* results = nil;
    Class clazz = NSClassFromString(className);
    if (![clazz instancesRespondToSelector:@selector(initFromDictionary:)])
    {
        WWDebugLog(@"Class %@ does not respond to initFromDictionary method! Response objects should implement initFromDictionary", className);
        completionHandler(nil,nil);
        return;
    }
    
    if (serverResponse.httpError == nil && serverResponse.parsedResponse != nil)
    {
        //WWDebugLog(@"Parsed Response:\n%@", serverResponse.parsedResponse);
        
        results = [NSMutableArray array];
        
        for (id node in serverResponse.parsedResponse)
        {
            id obj = [clazz fromDictionary:node];
            if (obj)
            {
                [results addObject:obj];
            }
        }
        
        /*
        if ([clazz instancesRespondToSelector:@selector(setRankType:)])
        {
            WWSearchArgs* args = [WWSettings cachedSearchArgs];
            [results setValue:@(args.rankType) forKeyPath:@"rankType"];
        }*/
    }
    
    NSDictionary* pagingHeaders = [self parsePaginationHeaders:[serverResponse.httpResponse allHeaderFields]];
    pagedResults.firstPageUrl = [pagingHeaders valueForKey:@"first"];
    pagedResults.lastPageUrl = [pagingHeaders valueForKey:@"last"];
    pagedResults.nextPageUrl = [pagingHeaders valueForKey:@"next"];
    pagedResults.prevPageUrl = [pagingHeaders valueForKey:@"prev"];
    pagedResults.data = results;
    
    //WWDebugLog(@"\nPaged Results:\n\nFirst: %@\n Last: %@\n Next: %@\n Prev: %@\n\n",
    //           pagedResults.firstPageUrl, pagedResults.lastPageUrl, pagedResults.nextPageUrl, pagedResults.prevPageUrl);
    
    if (completionHandler)
    {
        completionHandler(serverResponse.httpError, pagedResults);
    }
}

- (NSString*) buildRequestPath:(NSArray*)parts
{
    NSMutableString* sb = [NSMutableString string];
    
    for (NSString* part in parts)
    {
        if (sb.length > 0)
        {
            [sb appendString:@"/"];
        }
        
        [sb appendString:[part stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [sb copy];
}

- (NSDictionary*) parsePaginationHeaders:(NSDictionary*)d
{
    NSMutableDictionary* parsed = [NSMutableDictionary dictionary];
    
    if (d)
    {
        id linkNode = [d valueForKey:@"Link"];
        if (linkNode && [linkNode isKindOfClass:[NSString class]])
        {
            NSArray* parts = [linkNode componentsSeparatedByString:@","];
            if (parts)
            {
                for (NSString* p in parts)
                {
                    NSArray* innerParts = [p componentsSeparatedByString:@";"];
                    if (innerParts && innerParts.count == 2)
                    {
                        NSString* url = [innerParts[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        url = [url substringWithRange:NSMakeRange(1, url.length - 2)]; // Trim enclosing < >
                        
                        NSString* type = nil;
                        NSString* typeDef = [innerParts[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSArray* typeParts = [typeDef componentsSeparatedByString:@"="];
                        if (typeParts && typeParts.count == 2)
                        {
                            type = [typeParts[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        }
                        
                        if (url && type)
                        {
                            [parsed setValue:url forKey:type];
                        }
                    }
                }
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:parsed];
}

- (NSData*) toJsonData:(NSDictionary*)dictionary
{
    if (dictionary)
    {
        NSError* err = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
        if (err != nil)
        {
            WWDebugLog(@"Failed to serialize to json, err: %@", err);
            return nil;
        }
        
        if (data == nil)
        {
            WWDebugLog(@"JSON serialization returned success but data is nil!");
        }
        
        return data;
    }
    else
    {
        WWDebugLog(@"Attempting to serialize nil dictionary to JSON!");
        return nil;
    }
}

- (NSDictionary*) appendDeviceInfo:(NSDictionary*)d
{
    NSMutableDictionary* md = [NSMutableDictionary dictionary];
    
    if (d)
    {
        [md addEntriesFromDictionary:d];
    }
    
    NSString* deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [md setValue:deviceId forKey:@"device_id"];
    return [NSDictionary dictionaryWithDictionary:md];
}

- (UUHttpClient*) get:(NSString*)url queryArguments:(NSDictionary*)queryArguments completionHandler:(void (^)(UUHttpClientResponse* response))completionHandler
{
    NSDictionary* d = [self appendDeviceInfo:queryArguments];
    return [UUHttpClient get:url queryArguments:d completionHandler:completionHandler];
}

- (UUHttpClient*) post:(NSString*)url queryArguments:(NSDictionary*)queryArguments postBody:(NSData*)postBody contentType:(NSString*)contentType completionHandler:(void (^)(UUHttpClientResponse* response))completionHandler
{
    NSDictionary* d = [self appendDeviceInfo:queryArguments];
    return [UUHttpClient post:url queryArguments:d postBody:postBody contentType:contentType completionHandler:completionHandler];
}

- (UUHttpClient*) put:(NSString*)url queryArguments:(NSDictionary*)queryArguments putBody:(NSData*)putBody contentType:(NSString*)contentType completionHandler:(void (^)(UUHttpClientResponse* response))completionHandler
{
    NSDictionary* d = [self appendDeviceInfo:queryArguments];
    return [UUHttpClient put:url queryArguments:d putBody:putBody contentType:contentType completionHandler:completionHandler];
}


@end