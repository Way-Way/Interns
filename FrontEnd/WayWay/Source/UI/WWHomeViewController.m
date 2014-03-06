//
//  WWHomeViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_FILTER_TRANSITION_ANIMATION_DURATION 0.3f

@interface WWDebugPlaceAnnotation : WWPlaceAnnotation

@end

@implementation WWDebugPlaceAnnotation

@end

@interface WWHomeViewController () <UIGestureRecognizerDelegate, WWListResultsDelegate>

@property (assign) BOOL isSearching;
@property (assign) BOOL firstSearch;
//@property (assign) BOOL searchOnNextLocationChange;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UIAlertView* locationAlert;

@property (nonatomic, strong) WWPagedSearchResults* lastPlaceSearchResults;
@property (nonatomic, strong) NSMutableArray* allPlaceResults;

@property (nonatomic, strong) UINavigationController* filterNavController;
@property (nonatomic, strong) WWFilterViewController* filterController;

@property (nonatomic, strong) UINavigationController* searchNavController;
@property (nonatomic, strong) WWSearchViewController* searchController;

@property (nonatomic, strong) WWListResultsViewController* listResultsController;

@property (nonatomic, strong) WWPlaceDetailsViewController* currentDetailsViewController;


@property (nonatomic, strong) NSDictionary* deviceId;

//Gestures ???
@property (assign) CGSize fullScreenSize;
@property (assign) CGPoint touchStart;
@property (assign) CGPoint originStart;
@property (assign) CGFloat halfMapViewHeight;


////////////////////////////////////////////////
// Map View
@property (assign) int currentOffset;
@property (assign) int pinLimit;
@property (nonatomic, strong) WWPlace* selectedPlace;
@property (nonatomic, strong) WWPlace* lastSelectedPlace;
@property (assign) BOOL hasNextResults;

@property (assign) BOOL detailsExpanded;

@end

@implementation WWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.halfMapViewHeight = 195 + 20; // Spec says 390retina, plus 20 for the fake header   // 114 + 106; // header + one photo row
    
    WWHomeViewController* weakSelf = self;
    

    [self.filterButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(WW_FILTER, nil)] forState:UIControlStateNormal];
    self.filterButton.titleLabel.font = WW_FONT_H6;
    self.filterButton.titleLabel.textColor = WW_GRAY_COLOR_11;
    [self.filterButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    
    self.filterController = [WWFilterViewController new];
    self.filterController.delegate = self;
    self.filterNavController = [[UINavigationController alloc] initWithRootViewController:self.filterController];
    self.filterController.dismissCallback = ^(BOOL cancelled)
    {
        if (!cancelled)
        {
            weakSelf.hasSetupMap = NO;
            [weakSelf beginPlaceSearch];
        }
    };
    
    
    self.searchController = [WWSearchViewController new];
    self.searchNavController = [[UINavigationController alloc] initWithRootViewController:self.searchController];
    self.searchController.dismissCallback = ^(BOOL cancelled)
    {
        if (!cancelled)
        {
            [weakSelf beginPlaceSearch];
        }
    };
    
    self.listResultsController = [WWListResultsViewController new];
    self.listResultsController.delegate = self;
    
    UISearchBar* searchBar = [self wwNavSearchBar];
    searchBar.frame = CGRectMake(0, 0, 217, 44);
    self.searchBar = searchBar;
    searchBar.userInteractionEnabled = NO;
    
    [searchBar setImage:[UIImage imageNamed:@"clear_search"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"clear_search_white"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [searchBar setPositionAdjustment:UIOffsetMake(-3, 1) forSearchBarIcon:UISearchBarIconClear];
    
    
    UIView* centerNavContainer = [[UIView alloc] initWithFrame:CGRectMake(47, 0, 217, 44)];
    [centerNavContainer addSubview:searchBar];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = centerNavContainer.bounds;
    [self.searchButton addTarget:self action:@selector(onNavSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerNavContainer addSubview:self.searchButton];
    
    CGFloat dim = 30;
    self.clearSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(searchBar.bounds.size.width - dim - 8, 6, dim, dim)];
    [self.clearSearchButton addTarget:self action:@selector(onNavClearSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerNavContainer addSubview:self.clearSearchButton];
    
    WWNavView* navBarContainer = [[WWNavView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navBarContainer.wwAlignmentRectInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    
    
    
    if (self == self.navigationController.viewControllers.firstObject || self.forceLeftMenuAlways)
    {
        UIView* leftNav = [[self wwMenuNavItem] customView];
        leftNav.frame = CGRectMake(0, 0, 54, 44);
        [navBarContainer addSubview:leftNav];
    }
    else
    {
        UIView* leftNav = [[self wwBackNavItem] customView];
        leftNav.frame = CGRectMake(0, 0, 54, 44);
        [navBarContainer addSubview:leftNav];
        
        centerNavContainer = [self wwCenterNavItem:@""];
        centerNavContainer.frame = CGRectMake(47, 0, 217, 44);
        
        UILabel* label = (UILabel*)[centerNavContainer viewWithTag:WW_UI_NAV_BAR_PLACE_NAME_LABEL_TAG];
        label.frame = centerNavContainer.bounds;
        
    }
    
    UIView* listButton = [[self wwListNavItem] customView];
    self.listButton = (UIButton*)listButton;
    listButton.frame = CGRectMake(navBarContainer.bounds.size.width - listButton.bounds.size.width - 6, 1, listButton.bounds.size.width, listButton.bounds.size.height);
    [navBarContainer addSubview:listButton];
    
    [navBarContainer addSubview:centerNavContainer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBarContainer];
    
    //self.searchOnNextLocationChange = YES;
    
    self.progressView.alpha = 0;
    
    self.firstSearch = YES;
    self.detailsExpanded = NO;
    
    //////////////////////////////////////////
    // ALERT VIEW
    self.locationAlert = [[UIAlertView alloc] initWithTitle:@"Turn on Location Services"
                                                    message:@"1. Go to your iPhone Settings \n 2. Tap on Privacy \n 3. Tap on Location Services  \n 4. Turn on WayWay"
                                                   delegate:nil
                                          cancelButtonTitle:@"Got it"
                                          otherButtonTitles: nil];
    //self.locationAlert.delegate = self;
    
    
    /////////////////////////////////////////
    // Map View Handling
    
    self.pinLimit = WW_DEFAULT_MAP_PIN_COUNT;
    self.selectedPlace = nil;
    self.hasSetupMap = NO;
    self.isSearching = NO;
    
    
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTouched:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
    UIPinchGestureRecognizer* pinchRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTouched:)];
    [pinchRec setDelegate:self];
    [self.mapView addGestureRecognizer:pinchRec];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTouched:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [doubleTap setDelegate:self];
    [self.mapView addGestureRecognizer:doubleTap];
    
    self.mapView.showsUserLocation = YES;
    
    [self.infoCollectionView registerNib:[UINib nibWithNibName:@"WWMapResultsInfoCell" bundle:nil] forCellWithReuseIdentifier:@"WWMapResultsInfoCellId"];
    
    self.progressAnimation.animationImages = @[
        [UIImage imageNamed:@"loader_00"],
        [UIImage imageNamed:@"loader_01"],
        [UIImage imageNamed:@"loader_02"],
        [UIImage imageNamed:@"loader_03"],
        [UIImage imageNamed:@"loader_04"],
        [UIImage imageNamed:@"loader_05"],
        [UIImage imageNamed:@"loader_06"],
        [UIImage imageNamed:@"loader_07"],
        [UIImage imageNamed:@"loader_08"],
        [UIImage imageNamed:@"loader_09"],
        [UIImage imageNamed:@"loader_10"],
        [UIImage imageNamed:@"loader_11"],
        [UIImage imageNamed:@"loader_12"],
        [UIImage imageNamed:@"loader_13"],
        [UIImage imageNamed:@"loader_14"],
        [UIImage imageNamed:@"loader_15"],
        [UIImage imageNamed:@"loader_16"],
        [UIImage imageNamed:@"loader_17"],
        [UIImage imageNamed:@"loader_18"],
        [UIImage imageNamed:@"loader_19"],
        [UIImage imageNamed:@"loader_20"],
        [UIImage imageNamed:@"loader_21"],
        [UIImage imageNamed:@"loader_22"],
        [UIImage imageNamed:@"loader_23"],
        [UIImage imageNamed:@"loader_24"],
        [UIImage imageNamed:@"loader_25"],
        [UIImage imageNamed:@"loader_26"],
        [UIImage imageNamed:@"loader_27"],
        [UIImage imageNamed:@"loader_28"],
        [UIImage imageNamed:@"loader_29"],
        [UIImage imageNamed:@"loader_30"]];
    
    self.progressAnimation.animationRepeatCount = -1;
    self.progressAnimation.animationDuration = 1.0f;
    [self.progressAnimation startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTriggerServerFetchNextPageNotification:) name:WW_TRIGGER_SERVER_FETCH_NEXT_PAGE_NOTIFICATION object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationUpdateNotification:) name:UULocationChangedNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationErrorNotification:) name:UULocationErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationAuthChangedNotification:) name:UULocationChangedNotification object:nil];
    
    NSString* deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.deviceId = @{ @"device_id"     : deviceId};
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.progressCacheView.hidden = YES;
    
    CGSize size = self.navigationController.view.bounds.size;
    self.fullScreenSize = size;
    
    [self.mapView wwHideLegalLabel];
    
    [self refreshLocateMeButton];
    
    if (self.selectedPlace == nil)
    {
        CGRect detailFrame = self.infoCollectionView.frame;
        detailFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        
        self.infoCollectionView.frame = detailFrame;
        
        CGRect shadowFrame = self.shadowView.frame;
        shadowFrame.origin.y = self.view.frame.size.height;
        self.shadowView.frame = shadowFrame;
    }
    
    [self.navigationController setNavigationBarHidden:(self.selectedPlace != nil && self.detailsExpanded) animated:NO];
    self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
    
    [self refreshFilterButton];
    
    if(self.firstSearch)
    {
        [self beginPlaceSearch];
    }
}

-(BOOL) isLocationAuthorized
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

-(void) setSearchArgsFromCurrentMap
{
    //reset search arguments
    MKCoordinateRegion region = self.mapView.region;
    WWSearchArgs* args = [self searchArgs];
    [args setGeoboxFromMapRegion:region];
    [self saveSearchArgs:args];
}

- (WWSearchArgs*) searchArgs
{
    /*if (self.fixedSearchArgs)
    {
        return self.fixedSearchArgs;
    }
    else
    {
        return [WWSettings cachedSearchArgs];
    }*/
    
    return [WWSettings cachedSearchArgs];
}

- (void) saveSearchArgs:(WWSearchArgs*)args
{
    // Only save to NSUserDefault if the fixed self.searchArgs are nil.  This will
    // only be the case on the root home view.  A pushed on home view (from a tap
    // on a hash tag will set self.searchArgs and just use them as a temporary search).
    /*if (self.fixedSearchArgs)
    {
        self.fixedSearchArgs = args;
    }
    else
    {
        [WWSettings saveCachedSearchArgs:args];
    }*/
    
    [WWSettings saveCachedSearchArgs:args];
}

#pragma marrk - No location alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//Cancel button pressed
    {
        
    }
    else if(buttonIndex == 1)//Go To Settings button pressed.
    {

    }
}

#pragma mark - Notifications

/*- (void) handleLocationUpdateNotification:(NSNotification*)notification
{
    //WWDebugLog(@"Location Update: %@", notification);
    if (self.searchOnNextLocationChange)
    {
        self.searchOnNextLocationChange = NO;
        [self onLocateMeClicked:nil];
        [self beginPlaceSearch];
    }
    
    CLLocation* loc = [[UULocationManager sharedInstance] currentLocation];
    if (loc)
    {
        [Flurry setLatitude:loc.coordinate.latitude
                  longitude:loc.coordinate.longitude
         horizontalAccuracy:loc.horizontalAccuracy
           verticalAccuracy:loc.verticalAccuracy];
    }
    
    [self refreshLocateMeButton];
}

- (void) handleLocationErrorNotification:(NSNotification*)notification
{
    [self refreshLocateMeButton];
}*/

- (void) handleLocationAuthChangedNotification:(NSNotification*)notification
{
    [self refreshLocateMeButton];
}

#pragma mark - Private

- (void) showProgress:(NSString*)message
{
    if (!message)
    {
        message = @"Loading";
    }
    
    self.progressCacheView.hidden = NO;
    [self listButtonIsActive:NO];
    
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
    
    [self listButtonIsActive:YES];
    self.progressCacheView.hidden = YES;
}

- (void) refreshSearchBar
{
    WWSearchArgs* args = [self searchArgs];
    if (args.lastAutoCompleteInput.length > 0)
    {
        self.searchButton.hidden = NO;
        self.searchBar.hidden = NO;
        
        NSString* text = args.lastAutoCompleteInput;
        NSString* navtitle;
        if ([@"hashtag" isEqualToString:args.autoCompleteType])
        {
            [self.searchBar setImage:[UIImage imageNamed:@"hashtag_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
            [self.searchBar wwSetSearchIconSize:CGSizeMake(WW_WAY_WAY_SEARCH_ICON_DIM, WW_WAY_WAY_SEARCH_ICON_DIM)];
            
            navtitle = [NSString stringWithFormat:@"#%@", text];
        }
        else
        {
            [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
            [self.searchBar wwSetSearchIconSizeToDefault];
            
            navtitle = text;
        }
        
        self.searchBar.text = text;
        [self wwUpdateNavTitle:navtitle];
        [self.searchBar wwSetClearButtonMode:UITextFieldViewModeAlways];
        [self.clearSearchButton setHidden:NO];
    }
    else
    {
        self.searchButton.hidden = NO;
        self.searchBar.hidden = NO;
        self.searchBar.text = @"";
        self.searchBar.placeholder = NSLocalizedString(WW_SEARCH, nil);
        [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self.searchBar wwSetClearButtonMode:UITextFieldViewModeNever];
        [self.searchBar wwSetSearchIconSizeToDefault];
        [self.clearSearchButton setHidden:YES];
    }
}

- (void) refreshFilterButton
{
    NSString* filterTitle = @"";
    WWSearchArgs* args = [self searchArgs];
    int numberOfFilters = 0;
    
    if(args.categoryCoffee)
    {
        filterTitle = [filterTitle stringByAppendingString:@"Coffee"];
        
        numberOfFilters += 1;
    }
    if(args.categoryBar)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"Bar"];
        
        numberOfFilters += 1;
    }
    if(args.categoryRestaurant)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"Restaurant"];
        
        numberOfFilters += 1;
    }
    if(args.categorySnack)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"Snack"];
        
        numberOfFilters += 1;
    }
    if(args.priceOne)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"$"];
        
        numberOfFilters += 1;
    }
    if(args.priceTwo)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"$$"];
        
        numberOfFilters += 1;
    }
    if(args.priceThree)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"$$$"];
        
        numberOfFilters += 1;
    }
    if(args.priceFour)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"$$$$"];
        
        numberOfFilters += 1;
    }
    if(args.openRightNow)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"Open"];
        
        numberOfFilters += 1;
    }
    if(args.trendingOnly)
    {
        if(![filterTitle isEqualToString:@""])
            filterTitle = [filterTitle stringByAppendingString:@" • "];
        filterTitle = [filterTitle stringByAppendingString:@"Trending"];
        
        numberOfFilters += 1;
    }
    
    if(numberOfFilters >= 3)
    {
        filterTitle = [NSString stringWithFormat:@"%d %@", numberOfFilters, NSLocalizedString(WW_COUNT_FILTERS, nil) ];
    }
    
    if(![filterTitle isEqualToString:@""])
    {
        [self.filterButton setTitle:[NSString stringWithFormat:@"  %@  ",filterTitle] forState:UIControlStateNormal];
        [self.filterButton setTitleColor:WW_LEAD_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [self.filterButton setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(WW_FILTER, nil) ] forState:UIControlStateNormal];
        [self.filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //This is not enough ... minimum size, ...
    [self.filterButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [self.filterButton sizeToFit];
}

- (void) toggleNoResults:(BOOL)visible
{
    [UIView animateWithDuration:0.3f animations:^
    {
        self.noResultsPanel.alpha = (visible ? 1 : 0);
    }
    completion:^(BOOL finished)
    {
        if (visible)
        {
            [UIView animateWithDuration:4.0f animations:^
             {
                 self.noResultsPanel.alpha = 0;
             }];
        }
    }];
}

-(void) showUnsupportedCity
{
    CLLocationCoordinate2D mapCenter = [self.mapView centerCoordinate];
    CLLocation*closestLocation = [[CLLocation alloc] initWithLatitude:mapCenter.latitude
                                                            longitude:mapCenter.longitude];
    
    [[WWServer sharedInstance] featuredHashtagsWithLocation:closestLocation
                                                 completion:^(NSError* error, NSArray* results)
     {
         NSString*message;
         WWCity* city;
         
         if(results)
             city = (WWCity*)results[0];
         
         if(closestLocation && city)
         {
             //Get the nearest city
             message =[NSString stringWithFormat:@"We are working hard to cover more cities. The closest one is %@. Do you want to go there?", city.city];
         }
         else
         {
             message =@"We are working hard to cover more cities. We are currently in New York, Paris and London... Do you want to go to New York?";
         }
         
         UIAlertView* unsupportedCityAlert = [[UIAlertView alloc] initWithTitle:@"This area is uncovered"
                                                                        message:message
                                                              completionHandler:^(NSInteger buttonIndex)
                                                                {
                                                                    if(buttonIndex == 1)
                                                                    {
                                                                        WWSearchArgs* args = [WWSearchArgs new];
                                                                        if(city)
                                                                            [args setFromCity:city];
                                                                        else
                                                                            [args setDefaultGeobox];
                                                                        
                                                                        [self updateMapBeforeSearch:args];
                                                                        
                                                                        [self beginPlaceSearch];
                                                                    }
                                                                    return;
                                                                }
                                                                   buttonTitles:@"Nevermind",@"Yes!", nil];
         
         [unsupportedCityAlert show];
     }];
}

-(void) listButtonIsActive:(BOOL)isActive
{
    UIButton* button = self.listButton;
    button.enabled = isActive;
    if(isActive)
    {
        button.alpha = 1.0;
    }
    else
    {
        button.alpha = 0.4;
    }
}

-(void) refreshButtonsLayout
{
    self.filterButton.hidden = NO;
    [self listButtonIsActive:YES];
    WWSearchArgs* args = [self searchArgs];
    if([args.autoCompleteType isEqualToString:@"place_id"])
    {
        self.filterButton.hidden = YES;
        [self listButtonIsActive:NO];
    }
}

- (void) beginPlaceSearch
{
    [self refreshSearchBar];
    [self refreshFilterButton];
    [self toggleNoResults:NO];
    
    if (self.isSearching)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    WWSearchArgs* args = [self searchArgs];
    
    if (![args hasGeoBox])
    {
        CLLocation *currentlocation = [[UULocationManager sharedInstance]  currentLocation];
        
        if(currentlocation)
        {
            [args setGeoboxFromLocation:currentlocation];
        }
        else
        {
            [args setDefaultGeobox];
        }
        [WWSettings saveCachedSearchArgs:args];
        self.hasSetupMap = NO;
    }
    
    self.firstSearch = NO;
    self.isSearching = YES;
    [self showProgress:@"Searching"];
    
    if (!self.hasSetupMap)
    {
        [self updateMapBeforeSearch:args];
    }

    [[WWServer sharedInstance] beginSearchPlaces:args completionHandler:^(NSError *error, WWPagedSearchResults *results)
     {
         [self hideProgress];
         
         self.isSearching = NO;
         
         if([results.error isEqualToString:WW_UNSUPPORTED_CITY])
         {
             WWDebugLog(@"Unsupported City: %@", results.error);
             [self showUnsupportedCity];
             
             return;
         }
             
         
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
         WWDebugLog(@"Got %d place results back", self.allPlaceResults.count);
         
         [self updateSearchResults:self.allPlaceResults isFirst:YES hasNext:hasNext];
         [self.listResultsController updateSearchResults:self.allPlaceResults isFirst:YES hasNext:hasNext];
         
         if ([@"place_id" isEqualToString:args.autoCompleteType] ||
             [@"hashtag" isEqualToString:args.autoCompleteType])
         {
             if (self.allPlaceResults && self.allPlaceResults.count > 0)
             {
                 [self changeSelectedPlace:self.allPlaceResults[0]];
             }
         }
         
         [self refreshButtonsLayout];
     }];
}

- (void) onPhotoTabRequestNewPage
{
    [self handleTriggerServerFetchNextPageNotification:nil];
}

- (void) handleTriggerServerFetchNextPageNotification:(NSNotification*)notification
{
    if (self.isSearching)
    {
        WWDebugLog(@"Already searching, let's bail");
        return;
    }
    
    if (!self.lastPlaceSearchResults)
    {
        WWDebugLog(@"Don't have cached place results, nothing to do");
        return;
    }
    
    if (!self.lastPlaceSearchResults.nextPageUrl)
    {
        WWDebugLog(@"Don't have next place page URL, nothing to do");
        return;
    }
    
    self.firstSearch = NO;
    self.isSearching = YES;
    [self showProgress:@"Searching"];
    
    [[WWServer sharedInstance] fetchNextPlacesPage:self.lastPlaceSearchResults.nextPageUrl completionHandler:^(NSError *error, WWPagedSearchResults *results)
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
         
         [self.allPlaceResults addObjectsFromArray:results.data];
         
         BOOL hasNext = (results.nextPageUrl != nil);
         [self updateSearchResults:self.allPlaceResults isFirst:NO hasNext:hasNext];
         [self.listResultsController updateSearchResults:self.allPlaceResults isFirst:NO hasNext:hasNext];
     }];
}

- (IBAction) onFilterButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER withParameters:self.deviceId];
    
    [self setSearchArgsFromCurrentMap];
    
    self.filterController.mapRegion = self.mapView.region;
    self.filterController.currentSearchArgs = [self searchArgs];
    [self.filterNavController wwShowWithBackgroundBlurInView:self.navigationController.view];
}

- (void) onNavSearchButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_SEARCH withParameters:self.deviceId];
    
    [self setSearchArgsFromCurrentMap];
    [self.searchNavController wwShowWithBackgroundBlurInView:self.navigationController.view];
}

- (void) onNavClearSearchClicked:(id)sender
{
    [self setSearchArgsFromCurrentMap];
    
    WWSearchArgs* args = [self searchArgs];
    if (args.autoCompleteArg && args.autoCompleteType)
    {
        args.autoCompleteType = nil;
        args.autoCompleteArg = nil;
        args.lastAutoCompleteInput = nil;
        [[self.searchController wwNavSearchBar] setText:@""];
        [self saveSearchArgs:args];
        
        [self beginPlaceSearch];
    }
}

-(void)autoRefreshOnGesture:(UIGestureRecognizer*)gr withTime:(double)time
{
    [self.timer invalidate];
    self.timer = nil;
    if (gr.state == UIGestureRecognizerStateEnded)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval: time
                                                      target: self
                                                    selector:@selector(refreshResults)
                                                    userInfo: nil repeats:NO];
    }
}

- (void)refreshResults
{
    [self setSearchArgsFromCurrentMap];
    [self beginPlaceSearch];
}

- (void) mapViewTouched:(UIGestureRecognizer*)gr
{
    //This is not taking into account that even when the gesture is ended the movement of the map can continue ...
    if (gr.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    if([gr isKindOfClass:[UIPinchGestureRecognizer class]] || [gr isKindOfClass:[UIPanGestureRecognizer class]])
    {
        [Flurry logEvent:WW_FLURRY_EVENT_MOVE_MAP withParameters:self.deviceId];
    }
    
    [self toggleRefreshButton:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) updateSearchResults:(NSArray*)results  isFirst:(BOOL)isFirst hasNext:(BOOL)hasNext
{
    self.hasNextResults = hasNext;
    
    if (isFirst)
    {
        self.currentOffset = 0;
        
        if (self.selectedPlace)
        {
            self.selectedPlace = [results firstObject];
        }
    }
    
    self.isSearching = NO;
    
    [self.infoCollectionView reloadData];
    [self setupMap:NO];
    
    //Deactivate/activate buttons
    BOOL noResults = self.allPlaceResults.count <= 0;
    [self toggleRefreshButton:noResults];
    [self toggleNoResults:noResults];
    [self listButtonIsActive:(!noResults)];
}

- (void) toggleRefreshButton:(BOOL)visible
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.refreshButton.alpha = visible ? 1 : 0;
     }];
}

- (IBAction)onRefreshButtonTapped:(id)sender
{
    [self refreshResults];
    
    if (self.selectedPlace)
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_REDO_SEARCH_HALF_MAP withParameters:self.deviceId];
    }
    else
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_REDO_SEARCH_FULL_MAP withParameters:self.deviceId];
    }
}

- (IBAction)onLocateMeClicked:(id)sender
{
    // Using nil argument when manually calling this, don't want to produce incorrect flurry events
    if (sender)
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_RECENTER withParameters:self.deviceId];
    }
    
    if(![self isLocationAuthorized])
    {
        [self popupNoLocationAuthorized];
        return;
    }
    
    CLLocation* loc = [[UULocationManager sharedInstance] currentLocation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, WW_DEFAULT_SEARCH_RADIUS, WW_DEFAULT_SEARCH_RADIUS);
    [self.mapView setRegion:region animated:YES];
    [self toggleRefreshButton:YES];

    //Set search arguments
    WWSearchArgs* args = [self searchArgs];
    [args setGeoboxFromMapRegion:region];
    [self saveSearchArgs:args];
    [self beginPlaceSearch];
}

- (void) popupNoLocationAuthorized
{
    [self.locationAlert show];
}

- (void)onListButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_VIEW_LIST_RESULTS withParameters:self.deviceId];
    
    WWSearchArgs* args = [self searchArgs];
    NSString* hashtag = nil;
    if([args.autoCompleteType isEqualToString:@"hashtag"])
        hashtag = args.autoCompleteArg;
    self.listResultsController.searchedHashtag = hashtag;
    self.listResultsController.displayLabel = YES;
    [self.navigationController pushViewController:self.listResultsController animated:YES];
}

#pragma mark - WWPlaceDetailsViewControllerDelegate

- (void) onSwipeDetailsUp
{
    //NSLog(@" *** SWIPE UP GESTURE *** ");
    self.detailsExpanded = YES;
    [self updateSelectedPlace];
}

- (void) onSwipeDetailsDown
{
    //NSLog(@" *** SWIPE DOWN GESTURE *** ");
    self.detailsExpanded = NO;
    [self updateSelectedPlace];
}

- (void) onToggleDetails
{
    if (self.detailsExpanded)
    {
        [Flurry logEvent:WW_FLURRY_EVENT_CLOSE_PLACE_DETAILS withParameters:self.deviceId];
    }
    else
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_TOP_OF_HALF_MAP_TO_EXPAND withParameters:self.deviceId];
    }
    
    self.detailsExpanded = !self.detailsExpanded;
    [self updateSelectedPlace];
}

- (void) refreshLocateMeButton
{
    //self.locateMeButton.enabled = [self isLocationAuthorized];
}

#pragma mark - Map View

- (void) updateMapBeforeSearch:(WWSearchArgs*)args
{
    self.hasSetupMap = YES;
    
    MKCoordinateRegion region = [args coordinateRegion];
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self saveSearchArgs:args];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[WWPinAnnotationView class]])
    {
        BOOL anythingSelected = (self.selectedPlace != nil);
        
        WWPlaceAnnotation* annotation = (WWPlaceAnnotation*)view.annotation;
        self.selectedPlace = annotation.place;
        [self updateSelectedPlace];
        self.lastSelectedPlace = nil;
        
        NSDictionary* d = @{@"PlaceId":self.selectedPlace.identifier};
        
        if (anythingSelected)
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_PIN_WHILE_HALF_MAP withParameters:d];
        }
        else
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_PIN_WHILE_FULL_MAP withParameters:d];
        }
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[WWPinAnnotationView class]])
    {
        self.lastSelectedPlace = self.selectedPlace;
        [self performSelector:@selector(clearSelectedPlace) withObject:view.annotation afterDelay:0.01f];
    }
}

- (void) clearSelectedPlace
{
    if (self.lastSelectedPlace == self.selectedPlace)
    {
        self.selectedPlace = nil;
        [self updateSelectedPlace];
    }
}

- (void) setupMap:(BOOL)centerOnSelected
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    WWPlaceAnnotation* annotationToSelect = nil;
    
    int count = self.allPlaceResults.count;
    for (int i = self.currentOffset; i < count && self.mapView.annotations.count <= self.pinLimit; i++)
    {
        WWPlace* p = self.allPlaceResults[i];
        WWPlaceAnnotation* annotation = [WWPlaceAnnotation annotationForPlace:p];
        [self.mapView addAnnotation:annotation];
        
        // DEBUG ONLY -- Helpful when figuring out how to center the pins
        //WWDebugPlaceAnnotation* debugAnnotation = [WWDebugPlaceAnnotation annotationForPlace:p];
        //[self.mapView addAnnotation:debugAnnotation];
        
        if (self.selectedPlace)
        {
            if ([p.identifier isEqualToNumber:self.selectedPlace.identifier])
            {
                annotationToSelect = annotation;
            }
        }
    }
    
    if (annotationToSelect)
    {
        if (centerOnSelected)
        {
            [self.mapView setCenterCoordinate:annotationToSelect.coordinate animated:YES];
        }
        
        [self.mapView selectAnnotation:annotationToSelect animated:NO];
    }
    
    if (!self.hasSetupMap)
    {
        self.hasSetupMap = YES;
        [self.mapView uuZoomToAnnotations:YES];
    }
    
    if (centerOnSelected)
    {
        [self setSearchArgsFromCurrentMap];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString* kMapReuseId = @"WWMapPlacemarkId";
    
    if ([annotation isKindOfClass:[WWDebugPlaceAnnotation class]])
    {
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"WWDebugPinAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"WWDebugPinAnnotation"];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.annotation = annotation;
        return annotationView;
    }
    else if ([annotation isKindOfClass:[WWPlaceAnnotation class]])
	{
        WWPinAnnotationView* annotationView = (WWPinAnnotationView*)[theMapView dequeueReusableAnnotationViewWithIdentifier:kMapReuseId];
        if (annotationView == nil)
        {
            annotationView = [[WWPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kMapReuseId];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.enabled = YES;
        annotationView.annotation = annotation;
        return annotationView;
    }
    
	return nil;
}

- (void) updateSelectedPlace
{
    if (self.selectedPlace != nil)
    {
        CGRect detailFrame = self.navigationController.view.bounds;
        CGRect mapFrame = self.navigationController.view.bounds;
        CGRect shadowFrame = self.shadowView.frame;
        
        CGFloat offset = self.halfMapViewHeight;
        
        if (!self.detailsExpanded)
        {
            detailFrame.origin.y = self.navigationController.view.bounds.size.height - offset;
        }
        
        detailFrame.size = self.fullScreenSize;
        mapFrame.size.height = mapFrame.size.height - offset + 20;
        shadowFrame.origin.y = mapFrame.size.height - shadowFrame.size.height;
        
        if (self.infoCollectionView.frame.origin.y != detailFrame.origin.y)
        {
            int row = [self.allPlaceResults indexOfObject:self.selectedPlace];
            if (row >= 0 && row < self.allPlaceResults.count)
            {
                [self.infoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
            
            if (!self.detailsExpanded)
            {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                self.infoCollectionView.scrollEnabled = YES;
                self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
                
                [self.infoCollectionView.visibleCells makeObjectsPerformSelector:@selector(setViewFullscreen:) withObject:@(NO)];
            }
            else
            {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                self.infoCollectionView.scrollEnabled = NO;
                self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
                
                [self.infoCollectionView.visibleCells makeObjectsPerformSelector:@selector(setViewFullscreen:) withObject:@(YES)];
            }
            
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut
             animations:^
             {
                 self.infoCollectionView.frame = detailFrame;
                 self.mapView.frame = mapFrame;
                 self.shadowView.frame = shadowFrame;
                 
                 CGFloat bottom = mapFrame.origin.y + mapFrame.size.height;
                 
                 CGRect f = self.refreshButton.frame;
                 f.origin.y = bottom - f.size.height;
                 self.refreshButton.frame = f;
                 
                 f = self.locateMeButton.frame;
                 f.origin.y = bottom - f.size.height;
                 self.locateMeButton.frame = f;
             }
             completion:^(BOOL finished)
             {
             }];
        }
        else
        {
            [self.infoCollectionView.visibleCells makeObjectsPerformSelector:@selector(setViewFullscreen:) withObject:@(self.detailsExpanded)];
            
            int row = [self.allPlaceResults indexOfObject:self.selectedPlace];
            if (row >= 0 && row < self.allPlaceResults.count)
            {
                int intermediateIndex = -1;
                
                NSArray* visibleIndexPaths = [self.infoCollectionView indexPathsForVisibleItems];
                if (visibleIndexPaths && visibleIndexPaths.count > 0)
                {
                    NSIndexPath* ip = [visibleIndexPaths firstObject];
                    intermediateIndex = ip.row;
                }
                
                if (intermediateIndex >= 0 && intermediateIndex < self.allPlaceResults.count)
                {
                    if (intermediateIndex > row)
                    {
                        intermediateIndex = row + 1;
                    }
                    else if (intermediateIndex < row)
                    {
                        intermediateIndex = row - 1;
                    }
                    
                    if (intermediateIndex != row && intermediateIndex >= 0 && intermediateIndex < self.allPlaceResults.count)
                    {
                        [self.infoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:intermediateIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                    }
                }
                
                [self.infoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            }
        }
    }
    else
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_FULL_MAP];
        
        CGRect detailFrame = self.infoCollectionView.frame;
        detailFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.infoCollectionView.scrollEnabled = YES;
        self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
        
        [self.infoCollectionView.visibleCells makeObjectsPerformSelector:@selector(setViewFullscreen:) withObject:@(NO)];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut
         animations:^
         {
             self.infoCollectionView.frame = detailFrame;
             self.mapView.frame = self.view.bounds;
             
             CGRect mapFrame = self.mapView.frame;
             CGFloat bottom = mapFrame.origin.y + mapFrame.size.height;
             
             CGRect f = self.refreshButton.frame;
             f.origin.y = bottom - f.size.height;
             self.refreshButton.frame = f;
             
             f = self.locateMeButton.frame;
             f.origin.y = bottom - f.size.height;
             self.locateMeButton.frame = f;
             
             f = self.shadowView.frame;
             f.origin.y = mapFrame.size.height;
             self.shadowView.frame = f;
         }
         completion:^(BOOL finished)
         {
         }];
    }
}

//! function of UIScrollView.h
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollPos: %f, %f of %f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y,
    //      scrollView.contentSize.width, scrollView.contentSize.height);
    
    int col = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //not necessary change of place !!
    WWPlace* p = self.allPlaceResults[col];
    [self changeSelectedPlace:p];
    NSDictionary* ed = @{@"PlaceId":p.identifier};
    [Flurry logEvent:WW_FLURRY_EVENT_SCROLL_HALF_MAP withParameters:ed];
}

- (void) changeSelectedPlace:(WWPlace*)p
{
    int index = -1;
    
    for (int i = 0; i < self.allPlaceResults.count; i++)
    {
        WWPlace* place = self.allPlaceResults[i];
        if ([place.identifier isEqualToNumber:p.identifier])
        {
            index = i;
            break;
        }
    }
    
    if (index == -1)
    {
        WWDebugLog(@" ****** ERROR finding index of place: %@ - %@", p.identifier, p.name);
        return;
    }
    
    int pinsLeftToShow = self.allPlaceResults.count - index;
    if (pinsLeftToShow < 5 && self.hasNextResults)
    {
        WWDebugLog(@"Fetching another page of places");
        [[NSNotificationCenter defaultCenter] postNotificationName:WW_TRIGGER_SERVER_FETCH_NEXT_PAGE_NOTIFICATION object:nil];
    }
    
    for (id anno in self.mapView.annotations)
    {
        if ([anno isKindOfClass:[WWPlaceAnnotation class]])
        {
            WWPlaceAnnotation* placeAnnotation = (WWPlaceAnnotation*)anno;
            if (placeAnnotation.place.identifier.intValue == p.identifier.intValue)
            {
                [self.mapView setCenterCoordinate:placeAnnotation.coordinate animated:YES];
                [self.mapView selectAnnotation:anno animated:YES];
                return;
            }
        }
    }
    
    // If we get here it means we didn't find an annotation to select and we need to adjust the currentOffset
    int pinPage = index / self.pinLimit;
    self.currentOffset = pinPage * self.pinLimit;
    
    //NSLog(@"New Data Offset %d", self.currentOffset);
    self.selectedPlace = p;
    [self updateSelectedPlace];
    
    //[self updateButtonPanel];
    [self setupMap:YES];
}

- (void) showHalfMapView:(WWPlace*)place
{
    [self changeSelectedPlace:place];
    [self.navigationController popToViewController:self animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_SWITCH_TO_HOME_CONTROLLER object:nil];
}


#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPlaceResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WWMapResultsInfoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WWMapResultsInfoCellId" forIndexPath:indexPath];
    
    WWPlace* p = self.allPlaceResults[indexPath.row];
    [cell update:p swipeDelegate:self screenSize:self.fullScreenSize fullScreen:@(self.detailsExpanded) searchArgs:[self searchArgs]];
    
    if (p == self.selectedPlace)
    {
        self.currentDetailsViewController = cell.contentViewController;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.fullScreenSize;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void) wwOnPlaceDetailsTapped
{
    [self onToggleDetails];
}

- (void) wwOnPlaceInfoTapped
{
    WWPlaceInfoViewController* c = [WWPlaceInfoViewController new];
    c.place = self.selectedPlace;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)onLongPress:(UIGestureRecognizer*)sender
{
    //NSLog(@" *** LONG PRESS GESTURE *** ");
    
    UILongPressGestureRecognizer* gesture = (UILongPressGestureRecognizer*)sender;
    
    CGPoint location = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat yDiff = location.y - self.touchStart.y;
        
        if (self.detailsExpanded)
        {
            if (self.infoCollectionView.frame.origin.y > 50)
            {
                [self onSwipeDetailsDown];
            }
            else
            {
                [self onSwipeDetailsUp];
            }
        }
        else
        {
            if (yDiff < -50)
            {
                [self onSwipeDetailsUp];
            }
            else
            {
                [self onSwipeDetailsDown];
            }
        }
        
        return;
    }
    else if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.touchStart = location;
        self.originStart = self.infoCollectionView.frame.origin;
    }
    
    //self.infoCollectionView.scrollEnabled = NO;
    
    CGFloat yDiff = location.y - self.touchStart.y;
    CGRect frame = self.infoCollectionView.frame;
    frame.origin.y = self.originStart.y + yDiff;
    
    CGFloat yMax = self.navigationController.view.bounds.size.height - self.halfMapViewHeight;
    
    if (frame.origin.y > yMax)
    {
        frame.origin.y = yMax;
    }
    
    if (frame.origin.y < 0)
    {
        frame.origin.y = 0;
    }
    
    self.infoCollectionView.frame = frame;
    
    if (self.originStart.y > 0) // touch started when half map was not at the top of the screen
    {
        if (self.infoCollectionView.frame.origin.y > self.originStart.y) // user has pulled DOWN
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
        }
        else if (self.infoCollectionView.frame.origin.y < self.originStart.y) // user is pulling UP
        {
            if (yDiff < -50)
            {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
            }
            else
            {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                self.behindStatusBarView.hidden = !self.navigationController.isNavigationBarHidden;
            }
        }
    }
}

@end


