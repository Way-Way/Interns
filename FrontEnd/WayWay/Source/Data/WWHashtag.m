//
//  WWHashtag.m
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@implementation WWHashtag : NSObject


- (id) initFromDictionary:(NSDictionary*)dictionary
{
    //WWDebugLog(@"dictionary: %@", dictionary);
    
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.name = [dictionary wwNonNullValueForKey:@"hash_tag"];
        self.count = [dictionary wwNonNullValueForKey:@"mention"];
        self.photos = [WWPhoto fromArray:[dictionary wwNonNullValueForKey:@"photos"]];
    }
    
    return self;
}

@end
