//
//  UIViewController+WWStyling.m
//  WayWay
//
//  Created by Ryan DeVore on 10/23/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_UI_NAV_BAR_PLACE_LEFT_NAV_ITEM @"WW_UI_NAV_BAR_PLACE_LEFT_NAV_ITEM"
#define WW_UI_NAV_BAR_CENTER_NAV_ITEM @"WW_UI_NAV_BAR_CENTER_NAV_ITEM"
#define WW_UI_NAV_BAR_PLACE_RIGHT_NAV_ITEM @"WW_UI_NAV_BAR_PLACE_RIGHT_NAV_ITEM"
#define WW_UI_NAV_BAR_BACK_NAV_ITEM @"WW_UI_NAV_BAR_BACK_NAV_ITEM"
#define WW_UI_NAV_BAR_CLOSE_NAV_ITEM @"WW_UI_NAV_BAR_CLOSE_NAV_ITEM"
#define WW_UI_NAV_BAR_SHARE_NAV_ITEM @"WW_UI_NAV_BAR_SHARE_NAV_ITEM"
#define WW_UI_NAV_BAR_MENU_NAV_ITEM @"WW_UI_NAV_BAR_MENU_NAV_ITEM"
#define WW_UI_NAV_BAR_SEARCH_BAR_ITEM @"WW_UI_NAV_BAR_SEARCH_BAR_ITEM"
#define WW_UI_NAV_BAR_LIST_NAV_ITEM @"WW_UI_NAV_BAR_LIST_NAV_ITEM"

@implementation UIViewController (WWStyling)

- (UIBarButtonItem*) wwPlaceLeftNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_PLACE_LEFT_NAV_ITEM];
    if (!button)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        label.tag = WW_UI_NAV_BAR_PLACE_SCORE_LABEL_TAG;
        label.backgroundColor = [UIColor clearColor];
        
        UIView* container = [[UIView alloc] initWithFrame:label.bounds];
        [container addSubview:label];
        
        UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wwOnPlaceDetailsTapped)];
        [container addGestureRecognizer:tapper];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:container];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_PLACE_LEFT_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwBackNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_BACK_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wwOnBackTapped) forControlEvents:UIControlEventTouchUpInside];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_BACK_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwCloseNavItem
{
    return [self wwCloseNavItem:@selector(wwOnCloseModalTapped)];
}

- (UIBarButtonItem*) wwCloseNavItem:(SEL)clicker
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_CLOSE_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        [btn addTarget:self action:clicker forControlEvents:UIControlEventTouchUpInside];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_CLOSE_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwListNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_LIST_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 50, 40)];
        
        [btn setTitle:NSLocalizedString(WW_LIST, nil) forState:UIControlStateNormal];
        btn.titleLabel.font = WW_FONT_H4;
        [btn setTitleColor:WW_ORANGE_FONT_COLOR forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"listnavbar"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;
        
        WWNavView* container = [[WWNavView alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
        container.wwAlignmentRectInsets = UIEdgeInsetsMake(0, 0, 0, 16);
        [container addSubview:btn];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:container];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_LIST_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwMenuNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_MENU_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wwOnLeftMenuTapped) forControlEvents:UIControlEventTouchUpInside];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_MENU_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwShareNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_SHARE_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wwOnPlaceShareTapped) forControlEvents:UIControlEventTouchUpInside];
        
        button = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_SHARE_NAV_ITEM];
    }
    
    return button;
}

- (UIBarButtonItem*) wwPlaceRightNavItem
{
    UIBarButtonItem* button = [self userInfoForKey:WW_UI_NAV_BAR_PLACE_RIGHT_NAV_ITEM];
    if (!button)
    {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wwOnPlaceInfoTapped) forControlEvents:UIControlEventTouchUpInside];
    
        UIView* container = [[UIView alloc] initWithFrame:btn.bounds];
        [container addSubview:btn];
        button = [[UIBarButtonItem alloc] initWithCustomView:container];
        
        [self attachUserInfo:button forKey:WW_UI_NAV_BAR_PLACE_RIGHT_NAV_ITEM];
    }
    
    return button;
}

- (UIView*) wwCenterNavItem:(NSString*)title
{
    UIView* view = [self userInfoForKey:WW_UI_NAV_BAR_CENTER_NAV_ITEM];
    if (!view)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        label.font = WW_FONT_H3;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = WW_UI_NAV_BAR_PLACE_NAME_LABEL_TAG;
        label.backgroundColor = [UIColor clearColor];
        
        UIView* container = [[UIView alloc] initWithFrame:label.bounds];
        [container addSubview:label];
        
        UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wwOnPlaceDetailsTapped)];
        [container addGestureRecognizer:tapper];
        
        view = container;
        
        [self attachUserInfo:view forKey:WW_UI_NAV_BAR_CENTER_NAV_ITEM];
    }
    
    UILabel* nameLabel = (UILabel*)[view viewWithTag:WW_UI_NAV_BAR_PLACE_NAME_LABEL_TAG];
    nameLabel.text = title;
    
    return view;
}

- (void) wwUpdateNavTitle:(NSString*)text
{
    UIView* view = [self userInfoForKey:WW_UI_NAV_BAR_CENTER_NAV_ITEM];
    if (view)
    {
        UILabel* label = (UILabel*)[view viewWithTag:WW_UI_NAV_BAR_PLACE_NAME_LABEL_TAG];
        label.text = text;
    }
}

- (UISearchBar*) wwNavSearchBar
{
    return [self wwNavSearchBar:NO];
}

- (UISearchBar*) wwNavSearchBar:(BOOL)hideClearButton
{
    UISearchBar* searchBar = [self userInfoForKey:WW_UI_NAV_BAR_SEARCH_BAR_ITEM];
    if (!searchBar)
    {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.backgroundImage = [UIImage new];
        searchBar.placeholder = NSLocalizedString(WW_SEARCH, nil);
        searchBar.showsCancelButton = NO;

        for (UIView* v in searchBar.subviews)
        {
            if ([v isKindOfClass:[UITextField class]])
            {
                UITextField* tf = (UITextField*)v;
                tf.clearButtonMode = hideClearButton ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
                tf.font = WW_FONT_H4;
                tf.enablesReturnKeyAutomatically = NO;
            }
            
            // In ios7 it seems there is another level of views
            for (UIView* vv in v.subviews)
            {
                if ([vv isKindOfClass:[UITextField class]])
                {
                    UITextField* tf = (UITextField*)vv;
                    tf.clearButtonMode = hideClearButton ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
                    tf.font = WW_FONT_H4;
                    tf.enablesReturnKeyAutomatically = NO;
                }
            }
        }
        
        [searchBar setImage:[UIImage imageNamed:@"clear_text"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [searchBar setImage:[UIImage imageNamed:@"clear_text_pressed"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
        [searchBar setPositionAdjustment:UIOffsetMake(-3, 1) forSearchBarIcon:UISearchBarIconClear];
        
        
        UIView* centerNavContainer = [[UIView alloc] initWithFrame:searchBar.bounds];
        [centerNavContainer addSubview:searchBar];
        
        [self attachUserInfo:searchBar forKey:WW_UI_NAV_BAR_SEARCH_BAR_ITEM];
    }
    
    return searchBar;
}

- (void) wwFormatScoreLabel:(UILabel*)label place:(WWPlace*)place
{    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H5, NSForegroundColorAttributeName : [UIColor blackColor] };
    
    NSString* sb = [NSString stringWithFormat:@"%.1f", place.classicRank.doubleValue];
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:sb attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    
    label.attributedText = as;
    //[label wwResizeWidth];
    //label.superview.frame = label.bounds;
}

/*
- (void) wwStyleNavBarForPlaceDetails:(WWPlace*)place
{
    [self wwStyleNavBarForPlaceDetails:self.navigationItem place:place];
}

- (void) wwStyleNavBarForPlaceDetails:(UINavigationItem*)navItem place:(WWPlace*)place
{
    UIBarButtonItem* left = [self wwPlaceLeftNavItem];
    UIView* center = [self wwCenterNavItem:place.name];
    UIBarButtonItem* right = [self wwPlaceRightNavItem];
    
    UILabel* scoreLabel = (UILabel*)[left.customView viewWithTag:WW_UI_NAV_BAR_PLACE_SCORE_LABEL_TAG];
    [self wwFormatScoreLabel:scoreLabel place:place];
    
    navItem.leftBarButtonItem = left;
    navItem.titleView = center;
    navItem.rightBarButtonItem = right;
}*/

- (void) wwOnBackTapped
{
    if([self isKindOfClass:[WWHomeViewController class]])
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_BACK_HASHTAG_NAVIGATION_ARROW];

    //Jon Evans
    //self.navigationController.delegate = [self transitionAnimator];
    [self.navigationController popViewControllerAnimated:YES];
}

// Jon Evans
/*- (WWPhotoDetailsAnimator*) transitionAnimator {
    WWPhotoDetailsAnimator *animator = nil;
    if ([self isKindOfClass:WWPhotoDetailsViewController.class]) {
        WWAppDelegate *ad = (WWAppDelegate*) [UIApplication sharedApplication].delegate;
        animator = [ad transitionAnimator];
        animator.reverse = YES;
    }
    return animator;
}*/


- (void) wwOnCloseModalTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) wwOnLeftMenuTapped
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_HAMBURGER];
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_OPEN_LEFT_DRAWER_NOTIFICATION object:nil];
}

- (void) wwOnPlaceShareTapped
{
    // default implementation does nothing
}

- (void) wwOnPlaceDetailsTapped
{
    // default implementation does nothing
}

- (void) wwOnPlaceInfoTapped
{
    // default implementation does nothing
}


- (void) wwShowWithBackgroundBlurInView:(UIView*)view
{
    static NSInteger tag = 12345678;
    
    UIImage* blurredImage = [UIView wwBlurredImageWithView:view];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = blurredImage;
    imgView.tag = tag;
    
    self.view.alpha = 0;
    UIView* v = [self.view viewWithTag:tag];
    if (v)
    {
        [v removeFromSuperview];
    }
    
    [self.view insertSubview:imgView atIndex:0];
    
    [view addSubview:self.view];
    self.view.frame = view.bounds;
    
    [UIView animateWithDuration:0.375f animations:^
     {
         self.view.alpha = 1;
         
     } completion:^(BOOL finished)
     {
         
     }];
}

- (void) wwShowWithAlphaFadeInView:(UIView*)view
{
    [self.view removeFromSuperview];
    self.view.alpha = 0;
    [view addSubview:self.view];
    self.view.frame = view.bounds;
    
    [UIView animateWithDuration:0.375f animations:^
     {
         self.view.alpha = 1;
         
     } completion:^(BOOL finished)
     {
         
     }];
}

@end
