//
//  WWListResultsViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWListResultsViewController ()

@property (assign) BOOL hasNextResults;

@end

@implementation WWListResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WWResultsCell" bundle:nil] forCellReuseIdentifier:@"WWResultsCellId"];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:@"Popular Places"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self toggleNoResults:self.tableData.count <= 0];
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWResultsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WWResultsCellId"];
    WWPlace* obj = [self.tableData objectAtIndex:indexPath.row];
    
    [cell update:obj hashtag:self.searchedHashtag];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWPlace* obj = [self.tableData objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showHalfMapView:)])
    {
        [self.delegate performSelector:@selector(showHalfMapView:) withObject:obj];
    }
}

- (void) updateSearchResults:(NSArray*)results  isFirst:(BOOL)isFirst hasNext:(BOOL)hasNext
{   
    self.hasNextResults = hasNext;
    
    int oldCount = self.tableData.count;
    self.tableData = [results copy];
    
    if (isFirst)
    {
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    else
    {
        int newCount = self.tableData.count;
        
        NSMutableArray* updatedIndexPaths = [NSMutableArray array];
        for (int i = oldCount; i < newCount; i++)
        {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:i inSection:0];
            [updatedIndexPaths addObject:ip];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:updatedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    [self toggleNoResults:self.tableData.count <= 0];
}

- (void) reloadContent
{
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (self.hasNextResults)
    {
        NSArray* visibleRows = [self.tableView indexPathsForVisibleRows];
        if (visibleRows)
        {
            NSIndexPath* last = [visibleRows lastObject];
            if (last)
            {
                if ((self.tableData.count - last.row) < 8)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WW_TRIGGER_SERVER_FETCH_NEXT_PAGE_NOTIFICATION object:nil];
                }
            }
        }
    }
}

- (void) toggleNoResults:(BOOL)visible
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.noResultsPanel.alpha = (visible ? 1 : 0);
     }
     completion:^(BOOL finished)
     {
     }];
}

@end
