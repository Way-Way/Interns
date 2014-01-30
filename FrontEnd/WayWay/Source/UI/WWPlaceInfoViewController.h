//
//  WWPlaceInfoViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 10/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPlaceInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WWPlace* place;

@end
