//
//  WWFavoritesViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 8/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWFavoritesViewController : WWListResultsViewController

@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIView *noResultsPanel;
@property (strong, nonatomic) IBOutlet UILabel *noResultsMessage;
@property (strong, nonatomic) IBOutlet UILabel *noResultsInfo;

@end
