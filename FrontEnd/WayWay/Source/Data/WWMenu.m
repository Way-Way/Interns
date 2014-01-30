//
//  WWMenu.m
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation NSObject (JsonParsing)

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [self init];
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

+ (NSArray*) fromArray:(NSArray*)array
{
    if (array && [array isKindOfClass:[NSArray class]])
    {
        NSMutableArray* results = [NSMutableArray array];
        
        for (NSDictionary* d in array)
        {
            id obj = [self fromDictionary:d];
            if (obj)
            {
                [results addObject:obj];
            }
        }
        
        return results;
    }
    else
    {
        return nil;
    }
}

@end

@implementation WWMenu

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.title = [dictionary wwNonNullValueForKey:@"title"];
        self.sections = [WWMenuSection fromArray:[dictionary wwNonNullValueForKey:@"sections"]];
        
        /*
        id entriesNode = [dictionary wwNonNullValueForKey:@"entries"];
        if (entriesNode && [entriesNode isKindOfClass:[NSArray class]])
        {
            NSMutableArray* sections = [NSMutableArray array];
            
            WWMenuSection* currentSection = nil;
            NSMutableArray* currentItems = nil;

            for (id node in entriesNode)
            {
                NSString* nodeType = [node wwNonNullValueForKey:@"type"];
                if ([@"section" isEqualToString:nodeType])
                {
                    if (currentSection)
                    {
                        if (currentItems)
                        {
                            currentSection.items = [NSArray arrayWithArray:currentItems];
                        }
                        
                        [sections addObject:currentSection];
                    }
                    
                    currentSection = [WWMenuSection fromDictionary:node];
                    currentItems = [NSMutableArray array];
                }
                else if ([@"item" isEqualToString:nodeType])
                {
                    WWMenuItem* item = [WWMenuItem fromDictionary:node];
                    [currentItems addObject:item];
                }
            }
            
            self.sections = [NSArray arrayWithArray:sections];
        }*/
        
    }
    
    return self;
}

@end

@implementation WWMenuSection

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.title = [dictionary wwNonNullValueForKey:@"title"];
        self.items = [WWMenuItem fromArray:[dictionary wwNonNullValueForKey:@"items"]];
    }
    
    return self;
}

@end

@implementation WWMenuItem

- (instancetype) initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        self.title = [dictionary wwNonNullValueForKey:@"title"];
        self.itemDescription = [dictionary wwNonNullValueForKey:@"desc"];
        self.price = [dictionary wwNonNullValueForKey:@"price"];
        
        /*
        id pricesNode = [dictionary wwNonNullValueForKey:@"prices"];
        if (pricesNode && [pricesNode isKindOfClass:[NSArray class]] && [pricesNode count] > 0)
        {
            id priceNode = [pricesNode objectAtIndex:0];
            self.price = [priceNode wwNonNullValueForKey:@"price"];
        }*/
    }
    
    return self;
}

@end