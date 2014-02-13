//
//  WWPlace.h
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPlace : NSObject

@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* shortName;

@property (nonatomic, copy) NSString* bannerUrl;

@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic, strong) NSNumber* distance;

@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* area;
@property (nonatomic, copy) NSString* city;

@property (nonatomic, copy) NSString* combinedCategories;
@property (nonatomic, copy) NSString* categoryIcon;
//@property (nonatomic, copy) NSString* relevantHashtags;

@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSArray* hoursOfOperation;
@property (nonatomic, copy) NSString* phoneNumber;
@property (nonatomic, strong) NSNumber* hasMenu;
@property (nonatomic, copy) NSString* reservationUrl;


@property (nonatomic, strong) NSNumber* isFavorite;

@property (nonatomic, strong) NSNumber* hashtagMentions;
@property (nonatomic, strong) NSNumber* classicRank;
@property (nonatomic, strong) NSNumber* isTrending;

- (CLLocation*) location;

- (id) initFromDictionary:(NSDictionary*)dictionary;

+ (instancetype) fromDictionary:(NSDictionary*)dictionary;

- (NSString*) formattedDistance;
- (NSString*) formattedAddressAndCity;
- (NSString*) formattedPhoneNumber;

- (BOOL) isFetchingPhotos;

- (void) beginPhotoFetchByFilter:(WWPhotoFilter)filter
              completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion;

- (void) fetchNextPageOfPhotosByFilter:(WWPhotoFilter)filter
                    completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion;

- (void) beginHashtagFetch:(NSString*)hashtag
                completion:(void (^)(NSArray* hashtagsAndPhotos, WWPagedSearchResults* pagedResults))completion;
                            
- (void) fetchNextPageOfHashtags:(NSString*)hashtag
                      completion:(void (^)(NSArray* hashtagsAndPhotos, WWPagedSearchResults* pagedResults))completion;

- (void) beginPhotoFetchByHashTag:(NSString*)hashTag
              completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion;

- (void) fetchNextPageOfPhotosByHashTag:(NSString*)hashTag
                    completion:(void (^)(NSArray* photos, WWPagedSearchResults* pagedResults))completion;


+ (WWPlace*) cachedPlace:(NSNumber*)placeId;
+ (void) updateCachedPlace:(WWPlace*)place;

@end


@interface WWPlaceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) WWPlace* place;

+ (instancetype) annotationForPlace:(WWPlace*)place;

@end

