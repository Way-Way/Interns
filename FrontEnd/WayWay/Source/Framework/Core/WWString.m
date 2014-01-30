//
//  WWString.m
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWString.h"

@implementation NSData (WWStringTwiddling)

- (NSString*) wwToHexString
{
	NSMutableString* sb = [[NSMutableString alloc] init];
    
    const char* rawData = [self bytes];
    int count = self.length;
    for (int i = 0; i < count; i++)
    {
        [sb appendFormat:@"%02X", (UInt8)rawData[i]];
    }
    
	return sb;
}

@end

@implementation NSString (WWFramework)

- (NSString*) wwFormatAsMentionsSummary
{
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* mentions = [nf numberFromString:self];
    if (mentions)
    {
        NSInteger val = mentions.integerValue;
        float tmp = 0;
        
        NSString* units = @"";
        if (val > 1000000)
        {
            units = @"m";
            tmp = (float)val / 1000000.0f;
        }
        else if (val > 1000)
        {
            units = @"k";
            tmp = (float)val / 1000.0f;
        }
        else
        {
            units = @"";
            tmp = (float)val;
        }
        
        tmp = lroundf(tmp * 10.0f) / 10.0f;
        
        NSInteger iTmp = (NSInteger)tmp;
        //NSLog(@"val: %@, tmp: %f, iTmp: %d", mentions, tmp, iTmp);
        
        if (iTmp == tmp)
        {
            return [NSString stringWithFormat:@"%d%@", iTmp, units];
        }
        else
        {
            return [NSString stringWithFormat:@"%.1f%@", tmp, units];
        }
    }
    else
    {
        return self.copy;
    }
}

@end
