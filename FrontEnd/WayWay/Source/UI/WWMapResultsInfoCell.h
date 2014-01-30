//
//  WWMapResultsInfoCell.h
//  WayWay
//
//  Created by Ryan DeVore on 8/15/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@protocol WWPlaceDetailsViewControllerDelegate;

@interface WWMapResultsInfoCell : UICollectionViewCell

@property (nonatomic, strong) WWPlaceDetailsViewController* contentViewController;

- (void) update:(WWPlace*)place
  swipeDelegate:(NSObject<WWPlaceDetailsViewControllerDelegate>*)delegate
     screenSize:(CGSize)screenSize
     fullScreen:(NSNumber*)fullScreen
     searchArgs:(WWSearchArgs*)searchArgs;

- (void) setViewFullscreen:(NSNumber*)fullScreen;

@end
