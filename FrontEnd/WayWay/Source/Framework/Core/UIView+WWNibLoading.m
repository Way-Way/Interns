//
//  UIView+WWNibLoading.m
//  WayWay
//
//  Created by Ryan DeVore on 7/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "UIView+WWNibLoading.h"

@implementation UIView (WWNibLoading)

+ (id) wwLoadFromNib:(NSString*)nibName
{
    NSArray* a = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    id view = [a objectAtIndex:0];
    
    // Hook for post NIB loading initialization
    if (view != nil && [view respondsToSelector:@selector(wwDidLoadFromNib)])
    {
        [view performSelector:@selector(wwDidLoadFromNib)];
    }
    
    return view;
}

+ (id) wwLoadFromNib
{
    return [self wwLoadFromNib:NSStringFromClass([self class])];
}

+ (CGSize) wwSizeFromNib
{
    return [self wwSizeFromNib:NSStringFromClass([self class])];
}

+ (CGSize) wwSizeFromNib:(NSString*)nibName
{
    id view = [self wwLoadFromNib:nibName];
    if ([view isKindOfClass:[UIView class]])
    {
        return [view bounds].size;
    }
    
    return CGSizeZero;
}

+ (CGFloat) wwHeightFromNib
{
    return [self wwHeightFromNib:NSStringFromClass([self class])];
}

+ (CGFloat) wwHeightFromNib:(NSString*)nibName
{
    return [self wwSizeFromNib:nibName].height;
}

+ (id) wwLoadAndReplaceView:(UIView*)subView
{
    UIView* parent = subView.superview;
    
    CGRect frame = subView.frame;
    [subView removeFromSuperview];
    
    UIView* v = [self wwLoadFromNib];
    v.frame = frame;
    [parent addSubview:v];
    return v;
}

@end
