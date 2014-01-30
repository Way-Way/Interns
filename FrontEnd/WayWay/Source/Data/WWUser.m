//
//  WWUser.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWUser ()

@end

@implementation WWUser


- (id) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self && dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.identifier = [dictionary wwNonNullValueForKey:@"id"];
        //self.firstName = [dictionary wwNonNullValueForKey:@"first_name"];
        //self.lastName = [dictionary wwNonNullValueForKey:@"last_name"];
        self.fullName = [dictionary wwNonNullValueForKey:@"full_name"];
        self.avatarUrl = [dictionary wwNonNullValueForKey:@"avatar_url"];
        self.email = [dictionary wwNonNullValueForKey:@"email"];
        self.facebookAccessToken = [dictionary wwNonNullValueForKey:@"facebook_auth_token"];
        self.facebookTokenExpiration = [WWDateFormatter dateFromRfc3339String:[dictionary wwNonNullValueForKey:@"facebook_token_expire_at"]];
        self.twitterAuthKey = [dictionary wwNonNullValueForKey:@"twitter_auth_access_key"];
        self.twitterAuthSecret = [dictionary wwNonNullValueForKey:@"twitter_auth_secret_key"];
        self.hasPassword = [dictionary wwNonNullValueForKey:@"has_password"];
        self.favoriteCount = [dictionary wwNonNullValueForKey:@"total_favorites"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setValue:self.identifier forKey:@"id"];
    //[d setValue:self.firstName forKey:@"first_name"];
    //[d setValue:self.lastName forKey:@"last_name"];
    [d setValue:self.email forKey:@"email"];
    [d setValue:self.facebookAccessToken forKey:@"facebook_auth_token"];
    [d setValue:[WWDateFormatter dateToRfc3339String:self.facebookTokenExpiration] forKey:@"facebook_token_expire_at"];
    [d setValue:self.twitterAuthKey forKey:@"twitter_auth_access_key"];
    [d setValue:self.twitterAuthSecret forKey:@"twitter_auth_secret_key"];
    [d setValue:self.hasPassword forKey:@"has_password"];
    [d setValue:self.favoriteCount forKey:@"total_favorites"];
    return [d copy];
}

#ifdef DEBUG
- (NSString*) description
{
    return [NSString stringWithFormat:@"%@", [self toDictionary]];
}
#endif

- (BOOL) hasTwitterCredentials
{
    return (self.twitterAuthKey != nil && self.twitterAuthKey.length > 0 && self.twitterAuthSecret != nil && self.twitterAuthSecret.length > 0);
}

- (BOOL) hasFacebookCredentials
{
    return (self.facebookAccessToken != nil && self.facebookAccessToken.length > 0);
}

/*
- (NSString*) fullName
{
    NSMutableString* sb = [NSMutableString string];
    if (self.firstName)
    {
        [sb appendFormat:@"%@ ", self.firstName];
    }
    
    if (self.lastName)
    {
        [sb appendFormat:@"%@", self.lastName];
    }
    
    
    return [sb stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}*/

- (NSString*) fullNameOrEmail
{
    NSString* fullName = [self fullName];
    if (fullName && fullName.length > 0)
    {
        return fullName;
    }
    else if (self.email)
    {
        return self.email;
    }
    else
    {
        return @"";
    }
}

#pragma mark - Static Helpers

+ (WWUser*) userFromDictionary:(NSDictionary*)dictionary
{
    return [[WWUser alloc] initFromDictionary:dictionary];
}

+ (NSArray*) initFromJsonArray:(id)jsonArray
{
    NSMutableArray* results = nil;
    
    if (jsonArray != nil)
    {
        results = [NSMutableArray array];
        
        for (id node in jsonArray)
        {
            id obj = [[WWUser alloc] initFromDictionary:node];
            if (obj != nil)
            {
                [results addObject:obj];
            }
        }
    }
    
    return results;
}


@end
