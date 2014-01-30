//
//  UISearchBar+WWFramework.m
//  WayWay
//
//  Created by Ryan DeVore on 12/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "UISearchBar+WWFramework.h"
#import "WWConstants.h"

@implementation UISearchBar (WWFramework)

- (void) wwSetClearButtonMode:(UITextFieldViewMode)mode
{
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            UITextField* tf = (UITextField*)v;
            tf.clearButtonMode = mode;
        }
        
        // In ios7 it seems there is another level of views
        for (UIView* vv in v.subviews)
        {
            if ([vv isKindOfClass:[UITextField class]])
            {
                UITextField* tf = (UITextField*)vv;
                tf.clearButtonMode = mode;
            }
        }
    }
}

- (UIImageView*) wwFindSearchIcon
{
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            UITextField* tf = (UITextField*)v;
            
            if ([tf.leftView isKindOfClass:[UIImageView class]])
            {
                return (UIImageView*)tf.leftView;
            }
        }
        
        // In ios7 it seems there is another level of views
        for (UIView* vv in v.subviews)
        {
            if ([vv isKindOfClass:[UITextField class]])
            {
                UITextField* tf = (UITextField*)vv;
                if ([tf.leftView isKindOfClass:[UIImageView class]])
                {
                    return (UIImageView*)tf.leftView;
                }
            }
        }
    }
    
    return nil;
}

- (void) wwSetSearchIconSize:(CGSize)size
{
    UIImageView* imgView = [self wwFindSearchIcon];
    if (imgView)
    {
        CGRect f = imgView.frame;
        f.size = size;
        imgView.frame = f;
    }
}

- (void) wwSetSearchIconSizeToDefault
{
    // These were found by nerfing thru the view hierarchy and logging them.  This
    // of course could change in future OS's, but for iOS 7 this is what it is
    [self wwSetSearchIconSize:CGSizeMake(WW_DEFAULT_SEARCH_ICON_DIM, WW_DEFAULT_SEARCH_ICON_DIM)];
}


@end
