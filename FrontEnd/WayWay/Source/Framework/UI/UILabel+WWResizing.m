//
//  UILabel+WWResizing.m
//  WayWay
//
//  Created by Ryan DeVore on 10/23/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "UILabel+WWResizing.h"
#import "UUObject.h"

@implementation UILabel (WWResizing)

#define WW_UI_LABEL_ORIGINAL_FRAME_KEY @"WW_U_ILABEL_ORIGINAL_FRAME_KEY"

- (CGRect) wwOriginalFrame
{
    NSValue* val = [self userInfoForKey:WW_UI_LABEL_ORIGINAL_FRAME_KEY];
    if (!val)
    {
        val = [NSValue valueWithCGRect:self.frame];
        [self attachUserInfo:val forKey:WW_UI_LABEL_ORIGINAL_FRAME_KEY];
    }
    
    return [val CGRectValue];
}

- (void) wwResizeWidth
{
    CGRect originalFrame = [self wwOriginalFrame];
    
    self.frame = originalFrame;
    [self sizeToFit];
    
    CGRect f = originalFrame;
    f.size.width = self.frame.size.width;
    self.frame = f;
}

- (void) wwResizeWidthAndHeight
{
    CGRect originalFrame = [self wwOriginalFrame];
    
    self.frame = originalFrame;
    [self sizeToFit];
}

@end
