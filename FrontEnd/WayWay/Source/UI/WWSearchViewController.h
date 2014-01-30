//
//  WWSearchViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 11/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchTypeSelector;
@property (strong, nonatomic) IBOutlet UIView *buttonContainer;
@property (nonatomic, copy) void (^dismissCallback)(BOOL cancelled);

- (IBAction)onSearchTypeChanged:(id)sender;

@end
