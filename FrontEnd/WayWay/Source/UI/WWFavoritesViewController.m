//
//  WWFavoritesViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 8/7/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWFavoritesViewController ()

@property (assign) bool isSearching;
@property (nonatomic, strong) WWPagedSearchResults* lastPlaceSearchResults;
@property (nonatomic, strong) NSMutableArray* allPlaceResults;

@end

@implementation WWFavoritesViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.noResultsMessage.font = WW_FONT_H4;
    self.noResultsInfo.font = WW_FONT_H6;
    self.noResultsInfo.textColor = WW_GRAY_COLOR_7;
    
    self.navigationItem.leftBarButtonItem = [self wwMenuNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:@"My Favorites"];
    self.searchedHashtag = nil;
    self.displayLabel = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.titleView = [self wwCenterNavItem:@"My Favorites"];
    
    [self refreshDataFromServer];
}

- (void) showProgress:(NSString*)message
{
    if (!message)
    {
        message = @"Loading";
    }
    
    self.progressLabel.text = message;
    [self.view bringSubviewToFront:self.progressView];
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressView.alpha = 1.0f;
     }];
}

- (void) hideProgress
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressView.alpha = 0.0f;
     }];
}

- (void) refreshDataFromServer
{
    if (self.isSearching)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    self.isSearching = YES;
    self.noResultsPanel.alpha = 0;
    [self showProgress:@"Searching"];
    
    [[WWServer sharedInstance] listUserFavorites:[WWSettings currentUser] completionHandler:^(NSError *error, WWPagedSearchResults *results)
    {
         [self hideProgress];
         
         self.isSearching = NO;
         
         if (error == nil)
         {
             WWDebugLog(@"Valid search results:\n%@", results);
             self.lastPlaceSearchResults = results;
         }
         else
         {
             WWDebugLog(@"Error with search: %@", error);
         }
         
         BOOL hasNext = (results.nextPageUrl != nil);
         self.allPlaceResults = [NSMutableArray arrayWithArray:results.data];
        [self updateSearchResults:self.allPlaceResults isFirst:YES hasNext:hasNext];
        
        self.noResultsPanel.alpha = (results.data.count > 0) ? 0 : 1;
     }];    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void) tableView:(UITableView *)inTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        WWPlace* obj = [self.tableData objectAtIndex:indexPath.row];
        
        NSMutableArray* tmp = [self.tableData mutableCopy];
        [tmp removeObject:obj];
        self.tableData = tmp.copy;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        obj.isFavorite = @(NO);
        WWUser* user = [WWSettings currentUser];
        [[WWServer sharedInstance] user:user
                         updateFavorite:obj
                             completion:nil];
        
        self.noResultsPanel.alpha = (self.tableData.count > 0) ? 0 : 1;
    }
}

/*- (BOOL) prefersStatusBarHidden
{
    return NO;
}*/

@end
