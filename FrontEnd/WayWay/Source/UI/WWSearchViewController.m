//
//  WWSearchViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 11/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWSearchViewController ()

@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) NSArray* tableData;
@property (nonatomic, strong) NSArray* searchResults;
@property (nonatomic, strong) NSTimer* searchTimer;
@property (nonatomic, strong) UUHttpClient* searchClient;
@property (nonatomic, strong) UIButton* clearSearchButton;

@end

@implementation WWSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [self wwNavSearchBar];
    self.searchBar.frame = CGRectMake(2, 0, 319, 44);
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    
    WWNavView* container = [[WWNavView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    container.wwAlignmentRectInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    
    // This is an invisible button laid over the top of the search bar.  It appears that
    // when the search bar doesn't have focus and you tap on the cancel button, the
    // search bar gains focus.  The client's desired behavior here is that we cancel
    // out of the search view altogether.
    CGFloat dim = 30;
    self.clearSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.searchBar.bounds.size.width - (dim * 2), 6, dim * 2, dim)];
    [self.clearSearchButton addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //self.clearSearchButton.backgroundColor = [UIColor greenColor];
    //self.clearSearchButton.alpha = 0.5f;
    [container addSubview:self.searchBar];
    [container addSubview:self.clearSearchButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.buttonContainer.backgroundColor = [UIColor uuColorFromHex:@"F5F5F5"];
    [self.buttonContainer wwStyleNavBottomSeparatorBorder];
    
    UIFont *font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:15];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.searchTypeSelector setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshPlaceholderText];
    [self refreshTableData];
    [self.searchBar becomeFirstResponder];
}

- (void) refreshTableData
{
    if (self.searchBar.text.length > 0)
    {
        self.tableData = self.searchResults;
    }
    else
    {
        if (self.searchTypeSelector.selectedSegmentIndex == 0)
        {
            self.tableData = [WWSettings recentPlaceSearchArgs];
        }
        else
        {
            self.tableData = [WWSettings recentHashtagSearchArgs];
        }
    }
    
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableData.count > 0)
    {
        WWAutoCompleteResult* obj = self.tableData[indexPath.row];
        if ([obj.type isEqualToString:@"place_id"])
        {
            return 66;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableData.count > 0)
    {
        WWAutoCompleteResult* obj = self.tableData[indexPath.row];
        static NSString* cellId;
        UITableViewCellStyle cellStyle;
        
        
        //TODO : Move all this logic away to a class!!!!
        if([@"place_id" isEqualToString:obj.type])
        {
            cellId = @"SearchFilterPlaceCellId";
            cellStyle = UITableViewCellStyleSubtitle;
        }
        else if([@"category" isEqualToString:obj.type])
        {
            cellId = @"SearchFilterCategoryCellId";
            cellStyle = UITableViewCellStyleValue1;
        }
        else if([@"hashtag" isEqualToString:obj.type])
        {
            cellId = @"SearchFilterHashtagCellId";
            cellStyle = UITableViewCellStyleValue1;
        }
        else
        {
            cellId = @"SearchFilterDefaultCellId";
            cellStyle = UITableViewCellStyleValue1;
        }
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellId];
            
            [cell.textLabel wwStyleWithFontOfSize:18];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.selectedBackgroundView.backgroundColor = WW_LIGHT_BLUE_COLOR;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            
            cell.detailTextLabel.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:13.0f];
            cell.detailTextLabel.textColor = WW_LIGHT_GRAY_FONT_COLOR;
            
            UIView* v = [UIView new];
            v.backgroundColor = [UIColor clearColor];
            cell.backgroundView = v;
            cell.backgroundColor = [UIColor clearColor];
            
            if([cellId isEqualToString:@"SearchFilterHashtagCellId"])
            {
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                
                UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_counter"]];
                icon.frame = CGRectMake(0, (cell.frame.size.height - icon.frame.size.height)/2.0, icon.frame.size.width, icon.frame.size.height);
                
                UIView* view = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - 15 - icon.frame.size.width, 0, icon.frame.size.width, cell.frame.size.height)];
                view.backgroundColor = [UIColor clearColor];
                
                [view addSubview:icon];
                [cell addSubview:view];
                
                UILabel* counter = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 200 - 15 - icon.frame.size.width - 4, 0, 200, cell.frame.size.height)];
                counter.textAlignment = NSTextAlignmentRight;
                counter.tag = 1;
                [counter setTextColor:WW_LIGHT_GRAY_FONT_COLOR];
                [counter setFont:[UIFont fontWithName:WW_DEFAULT_FONT_NAME size:15.0f]];
                [cell addSubview:counter];
            }
        }
        
        cell.detailTextLabel.text = nil;
        cell.accessoryView = nil;
        
        if([obj.type isEqualToString:@"place_id"])
        {
            cell.textLabel.text = obj.name;
            cell.detailTextLabel.text =  obj.extraSpecs;
        }
        else if ([@"hashtag" isEqualToString:obj.type])
        {
            cell.textLabel.text = [@"#" stringByAppendingString:obj.name];
            
            UILabel* counter = (UILabel*)[cell viewWithTag:1];
            counter.text = nil;
            if(obj.extraSpecs)
            {
                counter.text = [obj.extraSpecs wwFormatAsMentionsSummary];
            }
        }
        else
        {
            cell.textLabel.text = obj.name;
        }
        
        
        return cell;
    }
    else
    {
        
        //TODO : Move all this to a different class !!!
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
            cell.backgroundColor = [UIColor clearColor];
        }
        //End move
        
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
        
        WWAutoCompleteResult* obj = self.tableData[indexPath.row];

        WWSearchArgs* args = [WWSettings cachedSearchArgs];
        args.autoCompleteType = obj.type;
        
        if([obj.type isEqualToString:@"place_id"])
        {
            [args setGeoboxFromLocation:obj.location];
        }
        
        if([obj.type isEqualToString:@"place_id"]|| [obj.type isEqualToString:@"category"])
        {
            args.autoCompleteArg = obj.identifier;
        }
        else
        {
            args.autoCompleteArg = obj.name;
        }
        
        // Clear Filters
        [args clearFilterArgs];
        
        args.lastAutoCompleteInput = obj.name;
        [WWSettings saveCachedSearchArgs:args];
        
        //set search bar text
        self.searchBar.text = obj.name;
        
        if ([@"place_id" isEqualToString:args.autoCompleteType])
        {
            [Flurry logEvent:WW_FLURRY_EVENT_PERFORM_PLACE_SEARCH];
        }
        else if ([@"hashtag" isEqualToString:args.autoCompleteType])
        {
            [Flurry logEvent:WW_FLURRY_EVENT_PERFORM_HASHTAG_SEARCH];
        }
        else if ([@"category" isEqualToString:args.autoCompleteType])
        {
            [Flurry logEvent:WW_FLURRY_EVENT_PERFORM_CATEGORY_SEARCH];
        }
        
        
        //No more than 5 recent searches!!!
        if (self.searchTypeSelector.selectedSegmentIndex == 1)
        {
            [WWSettings addRecentHashtagSearch:obj];
        }
        else
        {
            [WWSettings addRecentPlaceSearch:obj];
        }
        
        [self.searchBar resignFirstResponder];
        
        [self dismissView:NO];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - Search Bar

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.clearSearchButton.enabled = NO;
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.clearSearchButton.enabled = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:WW_SEARCH_DELAY target:self selector:@selector(performSearch) userInfo:nil repeats:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchTimer invalidate];
    
    if (searchBar.text.length == 0) // void search
    {
        WWSearchArgs* args = [WWSettings cachedSearchArgs];
        args.autoCompleteType = nil;
        args.autoCompleteArg = nil;
        args.lastAutoCompleteInput = nil;
        [WWSettings saveCachedSearchArgs:args];
        
        [self dismissView:NO];
        return;
    }
    else
    {
        [self performSearch];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];
    [self dismissView:YES];
    self.searchBar.text = @"";
}

- (void)performSearch
{
    WWSearchArgs* args = [WWSettings cachedSearchArgs];
    
    if (self.searchBar.text.length > 0)
    {
        NSString* text = self.searchBar.text;
        WWDebugLog(@"Search with text: %@", text);
       
        if (self.searchClient)
        {
            WWDebugLog(@"Cancelling pending search");
            [self.searchClient cancel];
        }
        
        BOOL searchHashTags = (self.searchTypeSelector.selectedSegmentIndex == 1);
        self.searchClient = [[WWServer sharedInstance] queryTextSearch:text
                                                              hashTags:searchHashTags
                                                        withSearchArgs:args
                                                            completion:^(NSError *error, NSArray *results)
        {
            self.searchResults = results;
            [self refreshTableData];
            self.searchClient = nil;
        }];
    }
    else
    {
        self.searchResults = nil;
        [self refreshTableData];
    }
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

- (IBAction)onSearchTypeChanged:(id)sender
{
    if (self.searchTypeSelector.selectedSegmentIndex == 1)
    {
        [self.searchBar setImage:[UIImage imageNamed:@"hashtag_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self.searchBar wwSetSearchIconSize:CGSizeMake(WW_WAY_WAY_SEARCH_ICON_DIM, WW_WAY_WAY_SEARCH_ICON_DIM)];
    }
    else
    {
        [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self.searchBar wwSetSearchIconSizeToDefault];
    }
    
    [self refreshPlaceholderText];
    [self.searchTimer invalidate];
    [self performSearch];
}

- (void) refreshPlaceholderText
{
    if (self.searchTypeSelector.selectedSegmentIndex == 1)
    {
        self.searchBar.placeholder = @"rooftop, neonart, datenight";
    }
    else
    {
        self.searchBar.placeholder = @"e.g. Joe's pizza, sushi";
    }
}

- (void) dismissView:(BOOL)cancelled
{
    if (self.dismissCallback)
    {
        self.dismissCallback(cancelled);
    }
    
    [UIView animateWithDuration:0.5f animations:^
     {
         self.navigationController.view.alpha = 0;
         
     } completion:^(BOOL finished)
     {
         [self.navigationController.view removeFromSuperview];
     }];
}

@end
