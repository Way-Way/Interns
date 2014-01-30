//
//  WWMapResultsInfoCell.m
//  WayWay
//
//  Created by Ryan DeVore on 8/15/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_VIEW_CELL_TAG 1000000

@interface WWMapResultsInfoCell ()

@end

@implementation WWMapResultsInfoCell

- (void) update:(WWPlace*)place
  swipeDelegate:(NSObject<WWPlaceDetailsViewControllerDelegate>*)delegate
     screenSize:(CGSize)screenSize
     fullScreen:(NSNumber*)fullScreen
     searchArgs:(WWSearchArgs*)searchArgs
{
    UIView* old = [self viewWithTag:WW_VIEW_CELL_TAG];
    [old removeFromSuperview];
    
    WWPlaceDetailsViewController* vc = [WWPlaceDetailsViewController new];
    vc.view.tag = WW_VIEW_CELL_TAG;
    vc.swipeDelegate = delegate;
    vc.place = place;
    vc.currentSearchArgs = searchArgs;
    
    self.contentViewController = vc;
    
    vc.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [vc setViewFullscreen:fullScreen animated:NO];
    [self addSubview:vc.view];
}

- (void) setViewFullscreen:(NSNumber*)fullScreen
{
    [self.contentViewController setViewFullscreen:fullScreen animated:YES];
}

@end
