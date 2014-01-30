//
//  UILabel+WWStyling.m
//  WayWay
//
//  Created by Ryan DeVore on 10/23/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "UILabel+WWStyling.h"
#import "WWConstants.h"

@implementation UILabel (WWStyling)

- (void) wwStyleWithFontOfSize:(CGFloat)size
{
    self.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:size];
}

- (void) wwStyleWithBoldFontOfSize:(CGFloat)size
{
    self.font = [UIFont fontWithName:WW_DEFAULT_BOLD_FONT_NAME size:size];
}

@end
