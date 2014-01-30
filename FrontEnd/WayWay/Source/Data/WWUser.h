//
//  WWUser.h
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWUser : NSObject

@property (nonatomic, retain) NSNumber* identifier;
//@property (nonatomic, copy) NSString* firstName;
//@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* fullName;
@property (nonatomic, copy) NSString* avatarUrl;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* twitterAuthKey;
@property (nonatomic, copy) NSString* twitterAuthSecret;
@property (nonatomic, copy) NSString* facebookAccessToken;
@property (nonatomic, strong) NSDate* facebookTokenExpiration;
@property (nonatomic, retain) NSNumber* hasPassword;
@property (nonatomic, retain) NSNumber* favoriteCount;

- (id) initFromDictionary:(NSDictionary*)dictionary;

- (NSDictionary*) toDictionary;

- (BOOL) hasTwitterCredentials;
- (BOOL) hasFacebookCredentials;

//- (NSString*) fullName;
- (NSString*) fullNameOrEmail;

+ (WWUser*) userFromDictionary:(NSDictionary*)dictionary;
+ (NSArray*) initFromJsonArray:(id)jsonArray;

@end
