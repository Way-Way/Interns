//
//  WWMenuViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel* nameLabel;
//@property (strong, nonatomic) IBOutlet WWRankView* rankView;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIView *backNavView;
@property (strong, nonatomic) IBOutlet UIView *noMenuPanel;

@property (strong, nonatomic) WWPlace* place;

- (IBAction)onBackNavTapped:(id)sender;

@end
