//
//  WWPlace.m
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPlace ()

@property (nonatomic, strong) UUHttpClient* photoUpdateClient;

@property (nonatomic, strong) NSMutableDictionary* photoDictionary;
@property (nonatomic, strong) NSMutableDictionary* pageResultsDictionary;

@end

@implementation WWPlace

- (id) initFromDictionary:(NSDictionary*)dictionary
{
    //WWDebugLog(@"dictionary: %@", dictionary);
    
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.identifier = [dictionary wwNonNullValueForKey:@"id"];
        self.name = [dictionary wwNonNullValueForKey:@"name"];
        
        self.latitude = [dictionary wwNonNullValueForKey:@"latitude"];
        self.longitude = [dictionary wwNonNullValueForKey:@"longitude"];
        self.address = [dictionary wwNonNullValueForKey:@"address" defaultValue:@""];
        self.area = [dictionary wwNonNullValueForKey:@"area" defaultValue:@""];
        self.city = [dictionary wwNonNullValueForKey:@"city"];
        
        self.distance = [dictionary wwNonNullValueForKey:@"distance"];
        if (self.distance == nil)
        {
            CLLocation* placeLoc = [self location];
            CLLocation* selfLoc = [[UULocationManager sharedInstance] currentLocation];
            if (placeLoc && selfLoc)
            {
                self.distance = @([selfLoc distanceFromLocation:placeLoc] * 0.00062137);
            }
            else
            {
                self.distance = @(0);
            }
        }
        
        
        self.classicRank = [dictionary wwNonNullValueForKey:@"classic_rank" defaultValue:@(0)];
        NSNumber* trendingRank = [dictionary wwNonNullValueForKey:@"trending_rank" defaultValue:@(0)];
        self.isTrending = trendingRank.integerValue > 0 ? @(YES) : @(NO);
        self.hashtagMentions = [dictionary wwNonNullValueForKey:@"nb_occurences"];
        
        //self.trendingRank = [dictionary wwNonNullValueForKey:@"trending_rank" defaultValue:@(0)];
        //self.rankType = [dictionary wwNonNullValueForKey:@"rank_type" defaultValue:@(WWRankTypeTrending)];
        //self.score = [dictionary wwNonNullValueForKey:@"score"];

        //self.needsToLoadDetails = false;
        //self.isExpanded = false;
        
        self.isFavorite = [dictionary wwNonNullValueForKey:@"is_favorite"];
        self.phoneNumber = [dictionary wwNonNullValueForKey:@"phone"];
        self.reservationUrl = [dictionary wwNonNullValueForKey:@"reservation_url"];
        self.hasMenu = [dictionary wwNonNullValueForKey:@"has_menu"];
        self.shortName = [dictionary wwNonNullValueForKey:@"short_name"];
        self.bannerUrl = [dictionary wwNonNullValueForKey:@"background_url"];
        
    
        id categoryListNode = [dictionary wwNonNullValueForKey:@"omb_categories"];
        if (categoryListNode && [categoryListNode isKindOfClass:[NSArray class]])
        {
            NSArray* values = [categoryListNode valueForKeyPath:@"value"];
            self.combinedCategories = [values componentsJoinedByString:@", "];
        }
        NSString* categoryIconName = [dictionary wwNonNullValueForKey:@"category_icon" defaultValue:@""];
        self.categoryIcon = [self getCategoryIcon:categoryIconName];
        
        
        self.price = [dictionary wwNonNullValueForKey:@"price"];
        if (self.price == nil || self.price.length <= 0)
        {
            self.price = @"$";
        }
        else if ([@"4" isEqualToString:self.price])
        {
            self.price = @"$$$$";
        }
        else if ([@"3" isEqualToString:self.price])
        {
            self.price = @"$$$";
        }
        else if ([@"2" isEqualToString:self.price])
        {
            self.price = @"$$";
        }
        else if ([@"1" isEqualToString:self.price])
        {
            self.price = @"$";
        }
        else if ([@"null" isEqualToString:self.price])
        {
            self.price = @"$";
        }
        
        
        self.hoursOfOperation = [self parseHoursOfOperation:dictionary];

        
        //self.hashTags = [self parseHashTags:dictionary];
        //self.photos = [self parsePhotos:dictionary];
        
        self.photoDictionary = [NSMutableDictionary dictionary];
        self.pageResultsDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSArray*) parseHoursOfOperation:(NSDictionary*)dictionary
{
    NSMutableArray* arr = [NSMutableArray array];
    
    id hoursNode = [dictionary wwNonNullValueForKey:@"hours"];
    if (hoursNode)
    {
        NSArray* timeFrameNodes = [hoursNode wwNonNullValueForKey:@"timeframes"];
        if (timeFrameNodes)
        {
            for (id tfNode in timeFrameNodes)
            {
                NSString* days = [tfNode wwNonNullValueForKey:@"days"];
                if (days)
                {
                    id openNodes = [tfNode wwNonNullValueForKey:@"open"];
                    if (openNodes)
                    {
                        NSMutableString* openTimes = [NSMutableString string];
                        
                        for (id openNode in openNodes)
                        {
                            NSString* renderedTime = [openNode wwNonNullValueForKey:@"renderedTime"];
                            if (renderedTime)
                            {
                                if (openTimes.length > 0)
                                {
                                    [openTimes appendString:@"\n"];
                                }
                                
                                [openTimes appendString:renderedTime];
                            }
                        }
                        
                        if (openTimes.length > 0)
                        {
                            NSDictionary* d = @{@"day": days, @"hours":openTimes};
                            [arr addObject:d];
                            /*
                            if (sb.length > 0)
                            {
                                [sb appendString:@", "];
                            }
                            
                            [sb appendFormat:@"%@: %@", days, openTimes];
                            */
                        }
                    }
                }
            }
        }
    }
    
    return arr;
}

+ (instancetype) fromDictionary:(NSDictionary*)dictionary
{
    if (dictionary)
    {
        WWPlace* p = [[[self class] alloc] initFromDictionary:dictionary];
        [self updateCachedPlace:p];
        return p;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getCategoryIcon:(NSString*)category
{
    NSString* check = [category lowercaseString];
    
    if ([WW_CATEGORY_RESTAURANTS isEqualToString:check])
    {
        return @"restaurant_white";
    }
    else if ([WW_CATEGORY_BARS_NIGHTLIFE isEqualToString:check])
    {
        return @"bar_white";
    }
    else if ([WW_CATEGORY_COFFEE_TEA isEqualToString:check])
    {
        return @"coffee_white";
    }
    else if ([WW_CATEGORY_SNACKS isEqualToString:check])
    {
        return @"snack_white";
    }
    else
    {
        return nil;
    }
}

- (CLLocation*) location
{
    if (self.latitude && self.longitude)
    {
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        if (CLLocationCoordinate2DIsValid(loc.coordinate))
        {
            return loc;
        }
    }
    
    return nil;
}

- (NSString*) formattedDistance
{
    return [NSString stringWithFormat:@"%.01f mi", self.distance.doubleValue];
}

- (NSString*) detailInfoLineOne
{
    NSMutableString* sb = [NSMutableString string];
    
    if (self.address)
    {
        [sb appendString:self.address];
    }
    
    if (self.area && self.area.length > 0)
    {
        if (sb.length > 0)
        {
            [sb appendString:@", "];
        }
        
        [sb appendString:self.area];
    }
    
    return sb;
}

- (NSString*) detailInfoLineTwo
{
    NSMutableString* sb = [NSMutableString string];

    if (self.combinedCategories)
    {
        [sb appendString:self.combinedCategories];
    }
    
    NSString* formattedDistance = [self formattedDistance];
    if (formattedDistance)
    {
        [sb appendFormat:@"  %@", formattedDistance];
    }
    
    if (self.price)
    {
        [sb appendFormat:@"  %@", self.price];
    }
    
    return [sb uuTrimWhitespace];
}

- (NSString*) formattedAddressAndCity
{
    return [self detailInfoLineOne];
}

- (NSString*) formattedPhoneNumber
{
    //(555) 555-5555
    
    if (self.phoneNumber && self.phoneNumber.length == 10)
    {
        return [NSString stringWithFormat:@"(%@) %@-%@",
                [self.phoneNumber substringWithRange:NSMakeRange(0, 3)],
                [self.phoneNumber substringWithRange:NSMakeRange(3, 3)],
                [self.phoneNumber substringWithRange:NSMakeRange(6, 4)]];
    }
    else
    {
        return self.phoneNumber;
    }
}

#ifdef DEBUG

- (NSString*) description
{
    return [NSString stringWithFormat:@"id: %@, name: %@, address: %@, city: %@, area: %@, price: %@, lat: %@, lng: %@, distance: %@",
            self.identifier,
            self.name,
            self.address,
            self.city,
            self.area,
            self.price,
            self.latitude,
            self.longitude,
            self.distance];
}

#endif

#pragma mark - Photo Downloading

- (BOOL) isFetchingPhotos
{
    return (self.photoUpdateClient != nil);
}

- (NSString*) filterKey:(WWPhotoFilter)filter hashTag:(NSString*)hashTag
{
    if (hashTag && hashTag.length > 0)
    {
        return [NSString stringWithFormat:@"_filter_%d_hash_tag_%@_", filter, hashTag];
    }
    else
    {
        return [NSString stringWithFormat:@"_filter_%d_", filter];
    }
    
}

- (NSString*) hashTagKey:(NSString*)hashTag
{
    return [NSString stringWithFormat:@"_hash_tag_%@_", hashTag];
}

- (void) beginPhotoFetchByFilter:(WWPhotoFilter)filter
                      completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Cancelling existing request");
        [self.photoUpdateClient cancel];
        self.photoUpdateClient = nil;
    }
    
    // If anything exists, just use it rather than re-fetch from the beginning
    NSString* key = [self filterKey:filter hashTag:nil];
    WWPagedSearchResults* cachedSearchResults = [self.pageResultsDictionary valueForKey:key];
    NSArray* cachedPhotos = [self.photoDictionary valueForKey:key];
    if (cachedPhotos && cachedSearchResults && cachedPhotos.count > 0)
    {
        WWDebugLog(@"Page of photos already exists, no need to re-fetch");
        completion(cachedPhotos, cachedSearchResults);
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] beginFetchPlacePictures:self filter:filter completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        
        [self handleServerResponse:error results:results isFirst:YES mixedDataResults:NO key:key completion:completion];
    }];
}

- (void) fetchNextPageOfPhotosByFilter:(WWPhotoFilter)filter
                            completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    NSString* key = [self filterKey:filter hashTag:nil];
    WWPagedSearchResults* lastSearchResults = [self.pageResultsDictionary valueForKey:key];
    
    if (!lastSearchResults)
    {
        WWDebugLog(@"Don't have cached photo results, nothing to do");
        return;
    }
    
    if (!lastSearchResults.nextPageUrl)
    {
        WWDebugLog(@"Don't have next photo page URL, nothing to do");
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] fetchNextPicturesPage:lastSearchResults.nextPageUrl filter:filter completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        [self handleServerResponse:error results:results isFirst:NO mixedDataResults:NO key:key completion:completion];
    }];
}

- (void) beginHashtagFetch:(NSString*)hashtag
                completion:(void (^)(NSArray* hashtagsAndPhotos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Cancelling existing request");
        [self.photoUpdateClient cancel];
        self.photoUpdateClient = nil;
    }
    
    // If anything exists, just use it rather than re-fetch from the beginning
    NSString* key = [self filterKey:WWPhotoFilterTags hashTag:hashtag];
    WWPagedSearchResults* cachedSearchResults = [self.pageResultsDictionary valueForKey:key];
    NSArray* cachedPhotos = [self.photoDictionary valueForKey:key];
    if (cachedPhotos && cachedSearchResults && cachedPhotos.count > 0)
    {
        WWDebugLog(@"Page of hash tag photos already exists, no need to re-fetch");
        completion(cachedPhotos, cachedSearchResults);
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] beginFetchPlaceHashtags:self
                                                                        hashtag:hashtag
                                                              completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        [self handleServerResponse:error results:results isFirst:YES mixedDataResults:YES key:key completion:completion];
    }];
}

- (void) fetchNextPageOfHashtags:(NSString*)hashtag
                      completion:(void (^)(NSArray* hashtagsAndPhotos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    NSString* key = [self filterKey:WWPhotoFilterTags hashTag:hashtag];
    WWPagedSearchResults* lastSearchResults = [self.pageResultsDictionary valueForKey:key];
    
    if (!lastSearchResults)
    {
        WWDebugLog(@"Don't have cached photo results, nothing to do");
        return;
    }
    
    if (!lastSearchResults.nextPageUrl)
    {
        WWDebugLog(@"Don't have next photo page URL, nothing to do");
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] fetchNextHashtagPage:lastSearchResults.nextPageUrl
                                                           completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        [self handleServerResponse:error results:results isFirst:NO mixedDataResults:YES key:key completion:completion];
    }];
}

- (void) beginPhotoFetchByHashTag:(NSString*)hashTag
                       completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] beginFetchPlacePictures:self hashTag:hashTag completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        NSString* key = [self hashTagKey:hashTag];
        [self handleServerResponse:error results:results isFirst:YES mixedDataResults:NO key:key completion:completion];
    }];
}

- (void) fetchNextPageOfPhotosByHashTag:(NSString*)hashTag
                             completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion
{
    if (self.photoUpdateClient)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    NSString* key = [self hashTagKey:hashTag];
    WWPagedSearchResults* lastSearchResults = [self.pageResultsDictionary valueForKey:key];
    
    if (!lastSearchResults)
    {
        WWDebugLog(@"Don't have cached photo results, nothing to do");
        return;
    }
    
    if (!lastSearchResults.nextPageUrl)
    {
        WWDebugLog(@"Don't have next photo page URL, nothing to do");
        return;
    }
    
    self.photoUpdateClient = [[WWServer sharedInstance] fetchNextPicturesHashTagPage:lastSearchResults.nextPageUrl completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
        [self handleServerResponse:error results:results isFirst:NO mixedDataResults:NO key:key completion:completion];
    }];
}


//Handle server responses
- (void) handleServerResponse:(NSError*)error
                      results:(WWPagedSearchResults*)results
                      isFirst:(BOOL)isFirst
             mixedDataResults:(BOOL)mixedDataResults
                          key:(NSString*)key
                   completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion
{
    NSMutableArray* photos = nil;
    WWPagedSearchResults* pagedResults = nil;
    
    if (!error && results && results.data)
    {
        if (!isFirst)
        {
            photos = [self.photoDictionary valueForKey:key];
        }
        if (!photos)
        {
            photos = [NSMutableArray array];
        }
        
        if (mixedDataResults)
        {
            [photos addObjectsFromArray:[self buildPhotoTagData:results.data]];
        }
        else
        {
            [photos addObjectsFromArray:results.data];
        }
        
        results.data = nil; // Don't need duplicate copies of the WWPhoto objects
        
        [self.photoDictionary setValue:photos forKey:key];
        [self.pageResultsDictionary setValue:results forKey:key];
        
        pagedResults = results;
        
        [WWPlace updateCachedPlace:self];
    }
    
    self.photoUpdateClient = nil;
    
    if (completion)
    {
        completion(photos, pagedResults);
    }
}

- (NSMutableArray*) buildPhotoTagData:(NSArray*)hashtagList
{
    NSMutableArray* a = [NSMutableArray array];
    
    for (WWHashtag* hashTag in hashtagList)
    {
        [a addObject:hashTag];
        
        if(hashTag.photos.count >= 3)
        {
            for (int i = 0; i < 3; i++)
            {
                WWPhoto* p = [hashTag.photos objectAtIndex:i];
                [a addObject:p];
            }
        }
    }
    
    return a;
}

#pragma mark - Place Caching

static NSCache* thePlaceCache = nil;

+ (NSCache*) sharedPlaceCache
{
    if (!thePlaceCache)
    {
        thePlaceCache = [[NSCache alloc] init];
        [thePlaceCache setName:@"WWPlaceCache"];
    }
    
    return thePlaceCache;
}

+ (WWPlace*) cachedPlace:(NSNumber*)placeId
{
    return [[self sharedPlaceCache] objectForKey:placeId];
}

+ (void) updateCachedPlace:(WWPlace*)place
{
    [[self sharedPlaceCache] setObject:place forKey:place.identifier];
}

@end



@interface WWPlaceAnnotation()

@end

@implementation WWPlaceAnnotation

- (CLLocationCoordinate2D)coordinate;
{
	CLLocationDegrees latitude = self.place.latitude.floatValue;
	CLLocationDegrees longitude = self.place.longitude.floatValue;
	
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString*) title
{
    return  self.place.name;
}

+ (instancetype) annotationForPlace:(WWPlace*)place
{
	WWPlaceAnnotation* annotation = [[[self class] alloc] init];
    annotation.place = place;
	return annotation;
}

@end


