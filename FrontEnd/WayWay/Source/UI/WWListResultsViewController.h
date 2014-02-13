//
//  WWListResultsViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@protocol WWListResultsDelegate <NSObject>

- (void) showHalfMapView:(WWPlace*)place;

@end

@interface WWListResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString* searchedHashtag;
@property (nonatomic) BOOL displayLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView* noResultsPanel;
@property (strong, nonatomic) NSObject<WWListResultsDelegate>* delegate;
@property (nonatomic, strong) NSArray* tableData;

- (void) updateSearchResults:(NSArray*)results isFirst:(BOOL)isFirst hasNext:(BOOL)hasNext;
- (void) reloadContent;

@end
