//
//  WWPhoto.m
//  WayWay
//
//  Created by Ryan DeVore on 6/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation WWPhoto

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.identifier = [dictionary wwNonNullValueForKey:@"omb_photo_id"];
        
        self.category = [dictionary wwNonNullValueForKey:@"category"];
        self.latitude = [dictionary wwNonNullValueForKey:@"latitude"];
        self.longitude = [dictionary wwNonNullValueForKey:@"longitude"];
        
        self.timestamp = [WWDateFormatter dateFromRfc3339String:[dictionary wwNonNullValueForKey:@"timeStamp"]];
        
        self.instagramUserId = [dictionary wwNonNullValueForKey:@"ig_userid"];
        self.instagramUserName = [dictionary wwNonNullValueForKey:@"ig_username"];
        self.instagramUserPhotoUrl = [dictionary wwNonNullValueForKey:@"ig_userphoto"];
        
        self.smallImageUrl = [dictionary wwNonNullValueForKey:@"url_small"];
        self.mediumImageUrl = [dictionary wwNonNullValueForKey:@"url_medium"];
        self.largeImageUrl = [dictionary wwNonNullValueForKey:@"url"];
        
        self.hashTags = [dictionary wwNonNullValueForKey:@"omb_hashtags"];
        
        self.commentCount = [dictionary wwNonNullValueForKey:@"nb_comments"];
        self.likeCount = [dictionary wwNonNullValueForKey:@"nb_likes"];
        self.popularity = [dictionary wwNonNullValueForKey:@"popularity"];
        
        
        //Do we need this ??
        self.placeName = [dictionary wwNonNullValueForKey:@"place_name"];
        self.placeId = [dictionary wwNonNullValueForKey:@"omb_place_id"];
        self.placeClassicRank = [dictionary wwNonNullValueForKey:@"classic_rank"];
        self.placeTrendingRank = [dictionary wwNonNullValueForKey:@"trending_rank"];
        self.rankType = [dictionary wwNonNullValueForKey:@"place_rank_type" defaultValue:@(WWRankTypeTrending)];
        
    }
    
    return self;
}

+ (instancetype) fromDictionary:(NSDictionary*)dictionary
{
    if (dictionary)
    {
        WWPhoto* obj = [[[self class] alloc] initFromDictionary:dictionary];
        if (!obj.identifier)
        {
            obj = nil;
        }
        else if ([WWSettings isBadPhoto:obj.identifier])
        {
            //WWDebugLog(@"Ignoring bad photo record:\n%@\n", dictionary);
            obj = nil;
        }
        
        return obj;
    }
    else
    {
        return nil;
    }
}

- (NSString*) thumbUrl
{
    if (self.smallImageUrl && self.smallImageUrl.length > 0)
        return self.smallImageUrl;
    
    if (self.mediumImageUrl && self.mediumImageUrl.length > 0)
        return self.mediumImageUrl;
    
    return self.largeImageUrl;
}

- (NSString*) fullUrl
{
    return self.largeImageUrl;
}


- (NSString*) formattedHashTags:(NSString*)selectedHashTag
{
    NSMutableString* sb = [NSMutableString string];
    
    // For DEBUG
    //selectedHashTag = @"bar";
    //self.hashTags = @[ @"foo", @"bar", @"baz" ];
    
    [sb appendString:@"<html><body>"];
    
    for (NSString* s in self.hashTags)
    {
        NSString* font = @"Regular";
        NSString* color = @"black";
        if (selectedHashTag && [selectedHashTag isEqualToString:s])
        {
            color = @"#F96020";
        }
        
        NSString* fragment = [NSString stringWithFormat:@"<a href=\"wayway://internal?gotohashtag=%@\" style=\"text-decoration:none;\"><span style=\"font-family:Bariol-%@;color:%@;font-size:16px;\">#%@ </span></a>", s, font, color, s];
        [sb appendString:fragment];
    }
    
    [sb appendString:@"</p></body></html>"];
    
    return [sb copy];
}

#ifdef DEBUG

- (NSString*) description
{
    return [NSString stringWithFormat:@"id: %@, category: %@, timestamp: %@, popularity: %@, placeId: %@, small_url: %@, medium_url: %@, large_url: %@",
            self.identifier,
            self.category,
            self.timestamp,
            self.popularity,
            self.placeId,
            self.smallImageUrl,
            self.mediumImageUrl,
            self.largeImageUrl];
}

#endif

/*
- (WWPhotoFilter) photoFilter
{
    if ([[self.category lowercaseString] isEqualToString:@"food"])
    {
        return WWPhotoFilterFood;
    }
    
    if ([[self.category lowercaseString] isEqualToString:@"people"])
    {
        return WWPhotoFilterPeople;
    }
    
    if ([[self.category lowercaseString] isEqualToString:@"venue"])
    {
        return WWPhotoFilterVenue;
    }
    
    return WWPhotoFilterAll;
}*/

+ (NSArray*) timestampSortDescriptor
{
    NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    return @[sd];
}

+ (NSArray*) popularitySortDescriptor
{
    NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
    return @[sd];
}

+ (NSArray*) allPhotos:(NSArray*)photos
{
    NSArray* filtered = photos;
    NSArray* sorted = [filtered sortedArrayUsingDescriptors:[self popularitySortDescriptor]];
    //WWDebugLog(@"allPhotos: %@", sorted);
    return sorted;
}

+ (NSArray*) foodPhotos:(NSArray*)photos
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"category = 'FOOD'"];
    NSArray* filtered = [photos filteredArrayUsingPredicate:p];
    NSArray* sorted = [filtered sortedArrayUsingDescriptors:[self timestampSortDescriptor]];
    //WWDebugLog(@"foodPhotos: %@", sorted);
    return sorted;
}

+ (NSArray*) peoplePhotos:(NSArray*)photos
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"category = 'PEOPLE'"];
    NSArray* filtered = [photos filteredArrayUsingPredicate:p];
    NSArray* sorted = [filtered sortedArrayUsingDescriptors:[self timestampSortDescriptor]];
    //WWDebugLog(@"peoplePhotos: %@", sorted);
    return sorted;
}

+ (NSArray*) venuePhotos:(NSArray*)photos
{
    NSPredicate* p = [NSPredicate predicateWithFormat:@"category = 'VENUE'"];
    NSArray* filtered = [photos filteredArrayUsingPredicate:p];
    NSArray* sorted = [filtered sortedArrayUsingDescriptors:[self timestampSortDescriptor]];
    //WWDebugLog(@"venuePhotos: %@", sorted);
    return sorted;
}

+ (NSArray*) filterPhotos:(NSArray*)photos withFilter:(WWPhotoFilter)filter
{
    switch (filter)
    {
        case WWPhotoFilterFood:
            return [self foodPhotos:photos];
            
        case WWPhotoFilterPeople:
            return [self peoplePhotos:photos];
            
        case WWPhotoFilterVenue:
            return [self venuePhotos:photos];
            
        default:
            return [self allPhotos:photos];
    }
}


+ (NSString*) photoFilterName:(WWPhotoFilter)filter
{
    switch (filter)
    {
        //case WWPhotoFilterAll:
        //    return @"all";
            
        case WWPhotoFilterFood:
            return @"food";
            
        case WWPhotoFilterPeople:
            return @"people";
            
        case WWPhotoFilterVenue:
            return @"venue";
            
        default:
            return @"";
    }
}

@end


@implementation NSArray (WWPhotoLookup)

- (NSUInteger) wwIndexOfPhoto:(WWPhoto*)photo
{
    return [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj isKindOfClass:[WWPhoto class]])
        {
            WWPhoto* check = (WWPhoto*)obj;
            if ([check.identifier isEqualToNumber:photo.identifier])
            {
                *stop = YES;
                return YES;
            }
        }
        
        return NO;
    }];
}

@end