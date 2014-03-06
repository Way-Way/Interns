//
//  UIViewController+WWStyling.h
//  WayWay
//
//  Created by Ryan DeVore on 10/23/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@class WWPlace;

#define WW_UI_NAV_BAR_PLACE_SCORE_LABEL_TAG 1000000
#define WW_UI_NAV_BAR_PLACE_NAME_LABEL_TAG  1000001

@interface UIViewController (WWStyling)

//- (void) wwStyleNavBarForPlaceDetails:(WWPlace*)place;
//- (void) wwStyleNavBarForPlaceDetails:(UINavigationItem*)navItem place:(WWPlace*)place;

// Single Item helpers
- (UIBarButtonItem*) wwBackNavItem;
- (UIBarButtonItem*) wwCloseNavItem;
- (UIBarButtonItem*) wwCloseNavItem:(SEL)clicker;

- (UIView*) wwCenterNavItem:(NSString*)title;
- (UIBarButtonItem*) wwShareNavItem;
- (UIBarButtonItem*) wwMenuNavItem;
- (UIBarButtonItem*) wwListNavItem;
- (UISearchBar*) wwNavSearchBar;
- (void) wwUpdateNavTitle:(NSString*)text;


- (void) wwShowWithBackgroundBlurInView:(UIView*)view;
- (void) wwShowWithAlphaFadeInView:(UIView*)view;

@end
