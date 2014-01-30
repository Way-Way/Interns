//
//  WWLocationFilterViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 11/2/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@interface WWLocationFilterViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) NSArray* tableData;
@property (nonatomic, strong) NSTimer* searchTimer;
@property (nonatomic, strong) UUHttpClient* searchClient;
@end

@implementation WWLocationFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [self wwNavSearchBar];
    self.searchBar.frame = CGRectMake(2, 0, 319, 44);
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    
    WWNavView* container = [[WWNavView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    container.wwAlignmentRectInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    
    [container addSubview:self.searchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.searchBar.text = @"";
    //[self refreshTableData:nil];
    //[self.tableView reloadData];
    
    [self.searchBar becomeFirstResponder];
}


#pragma mark - Table View

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableData.count > 0)
    {
        return self.tableData.count;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableData.count > 0)
    {
        static NSString* cellId = @"SearchFilterCellId";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.textLabel wwStyleWithFontOfSize:18];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.selectedBackgroundView.backgroundColor = WW_LIGHT_BLUE_COLOR;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            
            UIView* v = [UIView new];
            v.backgroundColor = [UIColor clearColor];
            cell.backgroundView = v;
        }
        
        WWArea* obj = self.tableData[indexPath.row];

        cell.textLabel.text = obj.name;
        
        return cell;
    }
    else
    {
        static NSString* cellId = @"NoDataCellId";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.textLabel wwStyleWithFontOfSize:18];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            UIView* v = [UIView new];
            v.backgroundColor = [UIColor clearColor];
            cell.backgroundView = v;
        }
        
        if (indexPath.row == 1)
        {
            if (self.searchBar.text.length > 0)
            {
                cell.textLabel.text = @"No results for your search";
            }
        }
        else
        {
            cell.textLabel.text = @"";
        }
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableData.count > 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        WWArea* obj = self.tableData[indexPath.row];
        
        [self.searchBar resignFirstResponder];
        
        if (self.locationSelectedBlock)
        {
            self.locationSelectedBlock(obj);
        }
        
        self.searchBar.text = obj.name;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:WW_SEARCH_DELAY target:self selector:@selector(performSearch) userInfo:nil repeats:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchTimer invalidate];
    [self performSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)performSearch
{
    if (self.searchBar.text.length > 0)
    {
        NSString* text = self.searchBar.text;
        WWDebugLog(@"Search with text: %@", text);
        
        if (self.searchClient)
        {
            WWDebugLog(@"Cancelling pending search");
            [self.searchClient cancel];
        }
        
        self.searchClient = [[WWServer sharedInstance] queryLocationSearch:text
                                                             mapRegion:self.mapRegion
                                                            completion:^(NSError *error, NSArray *results)
         {
             [self refreshTableData:results];
             self.searchClient = nil;
         }];
    }
    else
    {
        self.tableData = nil;
        [self.tableView reloadData];
    }
}

- (void) refreshTableData:(NSArray*)results
{
    self.tableData = results;
    [self.tableView reloadData];
}

- (void) resignAllResponders
{
    [self.searchBar resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self resignAllResponders];
    return YES;
}

@end
