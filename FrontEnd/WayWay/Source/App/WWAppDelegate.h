//
//  WWAppDelegate.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWAppDelegate : UIResponder <UIApplicationDelegate>
{
    WWPhotoDetailsAnimator *transitionAnimator;
}

@property (strong, nonatomic) UIWindow *window;

+ (void) registerForPushNotifications;
- (WWPhotoDetailsAnimator*)transitionAnimator;

@end
