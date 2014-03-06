//
//  WWAutoCompleteResult.m
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

////////////////////////////////////////////////////////////////////////////////////
@implementation WWAutoCompleteResult

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        id idVal = [dictionary wwNonNullValueForKey:@"id"];
        if (idVal)
        {
            if ([idVal isKindOfClass:[NSString class]])
            {
                self.identifier = idVal;
            }
            else if ([idVal isKindOfClass:[NSNumber class]])
            {
                self.identifier = [NSString stringWithFormat:@"%@", idVal];
            }
        }
        
        self.name = [dictionary wwNonNullValueForKey:@"name"];
        self.type = [dictionary wwNonNullValueForKey:@"type"];
        self.timestamp = [dictionary wwNonNullValueForKey:@"timestamp"];
        
        
        //This won't go to the dictionary
        NSString* area;
        NSString* city;
        if([self.type isEqualToString:@"place_id"])
        {
            self.location = [[CLLocation alloc] initWithLatitude:[[dictionary wwNonNullValueForKey:@"latitude"] doubleValue]
                                                       longitude:[[dictionary wwNonNullValueForKey:@"longitude"] doubleValue]];
            
            area= [dictionary wwNonNullValueForKey:@"area"];
            city = [dictionary wwNonNullValueForKey:@"city"];
            if(area != nil && [area length] !=0)
            {
                self.extraSpecs = area;
                if(city!= nil && [city length] != 0)
                     self.extraSpecs =[[self.extraSpecs stringByAppendingString:@", "] stringByAppendingString:city];
            }
            else if(city != nil && [city length] != 0)
            {
               self.extraSpecs = city;
            }
        }
        else if([self.type isEqualToString:@"hashtag"] || self.type == nil)
        {
            NSString* nbOccurences = [dictionary wwNonNullValueForKey:@"nb_occurences"];
            if(nbOccurences)
            {
                self.extraSpecs = [NSString stringWithFormat:@"%@", nbOccurences ];
            }
            else
            {
                self.extraSpecs = nil;
            }
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
    [d setValue:self.identifier forKey:@"id"];
    [d setValue:self.type forKey:@"type"];
    [d setValue:self.name forKey:@"name"];
    [d setValue:self.timestamp forKey:@"timestamp"];
    
    if([self.type isEqualToString:@"place_id"])
    {
        [d setValue:[NSNumber numberWithDouble:self.location.coordinate.latitude] forKey:@"latitude"];
        [d setValue:[NSNumber numberWithDouble:self.location.coordinate.longitude] forKey:@"longitude"];
        [d setValue:self.extraSpecs forKey:@"area"];
    }
    else if([self.type isEqualToString:@"hashtag"])
    {
        [d setValue:self.extraSpecs forKey:@"nb_occurences"];
    }

    return [d copy];
}
@end
