//
//  UIView+WWStyling.m
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@implementation UIView (WWStyling)

- (void) wwStyleLightBlueBorder
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [WW_LIGHT_BLUE_COLOR CGColor];
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void) wwStyleLightGrayButtonBorder
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [WW_LIGHT_GRAY_BUTTON_COLOR CGColor];
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void) wwStyleLightOrangeBorder
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [WW_ORANGE_FONT_COLOR CGColor];
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void) wwStyleWhiteButtonBorder
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void) wwStyleWithRoundedCorners
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void) wwStyleLightGreyTopAndBottomBorders
{
    CGFloat borderWidth = 0.5f;
    CGColorRef borderColor = [WW_GRAY_BORDER CGColor];
    
    CALayer* topBorder = [CALayer layer];
    topBorder.borderColor = borderColor;
    topBorder.borderWidth = borderWidth;
    topBorder.frame = CGRectMake(0, 0, self.bounds.size.width, borderWidth);
    [self.layer addSublayer:topBorder];
    
    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.borderColor = borderColor;
    bottomBorder.borderWidth = borderWidth;
    bottomBorder.frame = CGRectMake(0, self.bounds.size.height - borderWidth, self.bounds.size.width, borderWidth);
    [self.layer addSublayer:bottomBorder];
}

- (void) wwStyleWithTopAndBottomBorder:(UIColor*)color width:(CGFloat)borderWidth
{
    CGColorRef borderColor = [color CGColor];
    
    CALayer* topBorder = [CALayer layer];
    topBorder.borderColor = borderColor;
    topBorder.borderWidth = borderWidth;
    topBorder.frame = CGRectMake(0, 0, self.bounds.size.width, borderWidth);
    [self.layer addSublayer:topBorder];
    
    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.borderColor = borderColor;
    bottomBorder.borderWidth = borderWidth;
    bottomBorder.frame = CGRectMake(0, self.bounds.size.height - borderWidth, self.bounds.size.width, borderWidth);
    [self.layer addSublayer:bottomBorder];
}

- (void) wwStyleNavBottomSeparatorBorder
{
    CGFloat borderWidth = 0.5f;
    CGColorRef borderColor = [WW_NAV_GRAY_SEPARATOR_COLOR CGColor];
    
    CALayer* bottomBorder = [CALayer layer];
    bottomBorder.borderColor = borderColor;
    bottomBorder.borderWidth = borderWidth;
    bottomBorder.frame = CGRectMake(0, self.bounds.size.height - borderWidth, self.bounds.size.width, borderWidth);
    [self.layer addSublayer:bottomBorder];
}

+ (UIImage *) wwBlurredImageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIColor* tint_color = [UIColor colorWithWhite:1.0 alpha:0.9];
    img = [img applyBlurWithRadius:4 tintColor:tint_color saturationDeltaFactor:2.0 maskImage:nil];
    
    return img;
}

- (void) printSubviews:(int)indent recursive:(BOOL)recursive
{
    NSMutableString* sb = [NSMutableString string];
    for (int i = 0; i < indent; i++)
    {
        [sb appendString:@" "];
    }
    
    int i = 0;
    // In ios7 it seems there is another level of views
    for (UIView* v in self.subviews)
    {
        NSLog(@"%@%d - %@ - %f, %f, %f, %f", sb, i, [v class], v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        i++;
        
        if (recursive && v.subviews && v.subviews.count > 0)
        {
            [v printSubviews:(indent + 4) recursive:recursive];
        }
    }
}

@end
