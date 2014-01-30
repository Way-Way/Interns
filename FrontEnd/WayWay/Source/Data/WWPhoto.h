//
//  WWPhoto.h
//  WayWay
//
//  Created by Ryan DeVore on 6/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPhoto : NSObject

@property (nonatomic, strong) NSNumber* identifier;

//DATA
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, copy) NSString* category;
@property (nonatomic, strong) NSNumber* popularity;
@property (nonatomic, strong) NSNumber* commentCount;
@property (nonatomic, strong) NSNumber* likeCount;
@property (nonatomic, strong) NSArray* hashTags;

@property (nonatomic, strong) NSString* instagramUserId;
@property (nonatomic, strong) NSString* instagramUserName;
@property (nonatomic, strong) NSString* instagramUserPhotoUrl;

//GEOLOC
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;

//URLS
@property (nonatomic, copy) NSString* smallImageUrl;
@property (nonatomic, copy) NSString* mediumImageUrl;
@property (nonatomic, copy) NSString* largeImageUrl;

//PLACE
@property (nonatomic, strong) NSNumber* placeId;
@property (nonatomic, copy) NSString* placeName;
@property (nonatomic, strong) NSNumber* placeTrendingRank;
@property (nonatomic, strong) NSNumber* placeClassicRank;
@property (nonatomic, strong) NSNumber* rankType;

+ (instancetype) fromDictionary:(NSDictionary*)dictionary;

+ (NSArray*) filterPhotos:(NSArray*)photos withFilter:(WWPhotoFilter)filter;

- (NSString*) thumbUrl;
- (NSString*) fullUrl;

- (NSString*) formattedHashTags:(NSString*)selectedHashTag;

+ (NSString*) photoFilterName:(WWPhotoFilter)filter;

@end

@interface NSArray (WWPhotoLookup)

- (NSUInteger) wwIndexOfPhoto:(WWPhoto*)photo;

@end