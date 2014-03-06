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

- (void) wwRepositionSizeHeight
{
    CGFloat oldheight = self.frame.size.height;
    CGFloat newheight = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}].height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + (oldheight - newheight), self.frame.size.width, newheight);
}

@end
