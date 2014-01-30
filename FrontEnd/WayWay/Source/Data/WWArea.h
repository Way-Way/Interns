//
//  WWArea.h
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWArea : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* area;

@property (nonatomic, strong) NSNumber* minLatitude;
@property (nonatomic, strong) NSNumber* maxLatitude;
@property (nonatomic, strong) NSNumber* minLongitude;
@property (nonatomic, strong) NSNumber* maxLongitude;

+ (instancetype) fromDictionary:(NSDictionary*)dictionary;

- (NSDictionary*) toDictionary;

@end
