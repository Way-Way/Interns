//
//  WWFeaturedHashtag.m
//  WayWay
//
//  Created by Roman Berenstein on 31/01/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@implementation WWCity

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    
    if(self!=nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        
        self.city = [dictionary wwNonNullValueForKey:@"city"];
        self.minlatitude = [dictionary wwNonNullValueForKey:@"min_latitude"];
        self.maxlatitude = [dictionary wwNonNullValueForKey:@"max_latitude"];
        self.minlongitude = [dictionary wwNonNullValueForKey:@"min_longitude"];
        self.maxlongitude = [dictionary wwNonNullValueForKey:@"max_longitude"];
        
        NSArray* array = [dictionary wwNonNullValueForKey:@"hashtags"];
        
        NSMutableArray* featured = [NSMutableArray new];
        for(NSString* s in array)
        {
            [featured addObject:s];
        }
        self.featured = [featured copy];
    }
    
    
    return self;
}

+ (instancetype) fromDictionary:(NSDictionary*)dictionary
{
    if (dictionary)
    {
        return [[[self class] alloc] initFromDictionary:dictionary];
    }
    else
    {
        return [[[self class] alloc] init];
    }
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    
    [d setValue:self.city forKey:@"city"];
    [d setValue:self.minlatitude forKey:@"min_latitude"];
    [d setValue:self.maxlatitude forKey:@"max_latitude"];
    [d setValue:self.minlongitude forKey:@"min_longitude"];
    [d setValue:self.maxlongitude forKey:@"max_longitude"];
    
    [d setValue:self.featured forKey:@"hashtags"];
    
    return [d copy];
}

@end
