//
//  WWArea.m
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWArea.h"

@implementation WWArea

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.city = [dictionary wwNonNullValueForKey:@"city"];
        self.area = [dictionary wwNonNullValueForKey:@"area"];
        
        NSString* name = self.city;
        if(![self.area isEqualToString:self.city])
            name = [[name stringByAppendingString:@", "] stringByAppendingString:self.area];
        self.name = name;
        
        self.minLatitude = [dictionary wwNonNullValueForKey:@"min_latitude"];
        self.maxLatitude = [dictionary wwNonNullValueForKey:@"max_latitude"];
        self.minLongitude = [dictionary wwNonNullValueForKey:@"min_longitude"];
        self.maxLongitude = [dictionary wwNonNullValueForKey:@"max_longitude"];
        
        //Hack when data is badly formattedbu
        if(self.minLatitude.doubleValue > self.maxLatitude.doubleValue)
        {
            self.minLatitude = [NSNumber numberWithFloat: 0];
            self.maxLatitude = [NSNumber numberWithFloat: 1];
        }
        if(self.minLongitude.doubleValue > self.maxLongitude.doubleValue)
        {
            self.minLongitude = [NSNumber numberWithFloat: 0];
            self.maxLongitude = [NSNumber numberWithFloat: 1];
        }
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
        return nil;
    }
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];

    [d setValue:self.name forKey:@"name"];
    [d setValue:self.city forKey:@"city"];
    [d setValue:self.area forKey:@"area"];
    
    [d setValue:self.minLatitude forKey:@"min_latitude"];
    [d setValue:self.maxLatitude forKey:@"max_latitude"];
    [d setValue:self.minLongitude forKey:@"min_longitude"];
    [d setValue:self.maxLongitude forKey:@"max_longitude"];
    
    return [d copy];
}

@end
