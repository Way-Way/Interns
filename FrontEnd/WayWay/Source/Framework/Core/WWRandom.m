//
//  WWRandom.m
//  WayWay
//
//  Created by Ryan DeVore on 11/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWRandom.h"

@implementation WWRandom

+ (UInt32) randomUInt32
{
	UInt32 randomResult = 0;
    
	for (int i =0; i < (12 + (arc4random() % 15)); i++)
		randomResult = arc4random();
	
	return randomResult;
}

+ (UInt32) randomUInt32BetweenLow:(UInt32)low High:(UInt32)high
{
	if (low > high)
	{
		UInt32 temp = low;
		low = high;
		high = temp;
	}
	
	UInt32 range = high - low + 1;
	return (low + ([[self class] randomUInt32] % range));
}

@end

@implementation NSArray (WWRandom)

- (NSUInteger) randomIndex
{
    return [WWRandom randomUInt32BetweenLow:0 High:self.count - 1];
}

- (id) randomElement
{
    if (self.count <= 0)
    {
        return nil;
    }
    
    return [self objectAtIndex:[self randomIndex]];
}

@end

