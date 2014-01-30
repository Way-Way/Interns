//
//  UISearchBar+WWFramework.h
//  WayWay
//
//  Created by Ryan DeVore on 12/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (WWFramework)

- (void) wwSetClearButtonMode:(UITextFieldViewMode)mode;
- (UIImageView*) wwFindSearchIcon;
- (void) wwSetSearchIconSize:(CGSize)size;
- (void) wwSetSearchIconSizeToDefault;

@end
