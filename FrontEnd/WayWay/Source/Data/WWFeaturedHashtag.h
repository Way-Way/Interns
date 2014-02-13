//
//  WWFeaturedHashtag.h
//  WayWay
//
//  Created by Roman Berenstein on 31/01/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@interface WWFeaturedHashtag : NSObject
@property (nonatomic,copy) NSArray*featured;

@property (nonatomic, strong) NSString* city;

@property (nonatomic, strong) NSNumber* minlatitude;
@property (nonatomic, strong) NSNumber* maxlatitude;
@property (nonatomic, strong) NSNumber* minlongitude;
@property (nonatomic, strong) NSNumber* maxlongitude;


- (instancetype) initFromDictionary:(NSDictionary*)dictionary;
+ (instancetype) fromDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;
@end
