//
//  WWPhotoDetailsAnimator.m
//  WayWay
//
//  Created by Jon Evans on 1/22/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWPhotoDetailsAnimator.h"

@implementation WWPhotoDetailsAnimator

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.reverse = YES;
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    toViewController.view.alpha = 0.0;
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
        toViewController.view.center = self.startPoint;
        toViewController.view.transform = CGAffineTransformMakeScale(0.33, 0.33);
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:0.7f delay:0 options:0 animations:^{
        if (self.reverse) {
            
            fromViewController.view.transform = CGAffineTransformMakeScale(0.33f, 0.33f);
            fromViewController.view.center = self.startPoint;
            fromViewController.view.alpha = 0.0;
            
            toViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            toViewController.view.alpha = 1.0;

        } else {
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
            toViewController.view.alpha = 1.0;
            
            CGPoint point;
            
            CGRect screenRect = [UIScreen mainScreen].bounds;
            if (self.startPoint.x == 53.5)
            {
                point.x = (screenRect.size.width * 3) / 2;
            }
            else if (self.startPoint.x == 160.5)
            {
                point.x = screenRect.size.width - (screenRect.size.width / 2);
            }
            else
            {
                point.x = - screenRect.size.width + (screenRect.size.width / 2);
            }
            point.y = (161 * 3) + (self.startPoint.y * 2);

            fromViewController.view.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
            fromViewController.view.center = point;
            fromViewController.view.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        toViewController.navigationController.delegate=nil;
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15f;
}
@end
