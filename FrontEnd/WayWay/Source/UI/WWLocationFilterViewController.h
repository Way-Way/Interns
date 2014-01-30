//
//  WWLocationFilterViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"
@class WWArea;

@interface WWLocationFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign) MKCoordinateRegion mapRegion;
@property (nonatomic, copy) void (^locationSelectedBlock)(WWArea* autoCompleteResult);

@end
