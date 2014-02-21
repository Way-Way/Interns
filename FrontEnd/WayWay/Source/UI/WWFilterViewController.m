//
//  WWFilterViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWFilterViewController ()

@property (nonatomic, strong) WWLocationFilterViewController* locationFilterController;
@property (nonatomic, strong) UINavigationController* locationFilterNavController;

@end

@implementation WWFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.locationFilterButton wwStyleLightGrayButtonBorder];
    [self.locationFilterButton wwStyleLightGrayAndOrangeButton];
    
    [self.priceButtonContainer wwStyleLightGrayButtonBorder];
    [self.priceOneButton wwStyleLightGrayAndOrangeButton];
    [self.priceTwoButton wwStyleLightGrayAndOrangeButton];
    [self.priceThreeButton wwStyleLightGrayAndOrangeButton];
    [self.priceFourButton wwStyleLightGrayAndOrangeButton];
    self.priceButtonContainer.backgroundColor = [UIColor clearColor];
    
    [self.categoryButtonContainer wwStyleLightGrayButtonBorder];
    [self.categoryCoffeeButton wwStyleLightGrayAndOrangeButton];
    [self.categoryBarButton wwStyleLightGrayAndOrangeButton];
    [self.categoryRestaurantButton wwStyleLightGrayAndOrangeButton];
    [self.categorySnackButton wwStyleLightGrayAndOrangeButton];
    self.categoryButtonContainer.backgroundColor = [UIColor clearColor];
    
    [self.openNowButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(WW_OPEN_NOW, nil)]
                        forState:UIControlStateNormal];
    [self.openNowButton wwStyleLightGrayButtonBorder];
    [self.openNowButton wwStyleLightGrayAndOrangeButton];
    
    [self.trendingOnlyButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(WW_TRENDING, nil)]
                             forState:UIControlStateNormal];
    [self.trendingOnlyButton wwStyleLightGrayButtonBorder];
    [self.trendingOnlyButton wwStyleLightGrayAndOrangeButton];

    self.clearFiltersButton.backgroundColor = [UIColor clearColor];
    [self.clearFiltersButton setTitle:NSLocalizedString(WW_CLEAR_FILTER, nil) forState:UIControlStateNormal];
    
    [self.clearFiltersButton setBackgroundImage:[UIImage wwSolidColorImage:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.clearFiltersButton setBackgroundImage:[UIImage wwSolidColorImage:[UIColor clearColor]] forState:UIControlStateDisabled];
    [self.clearFiltersButton setBackgroundImage:[UIImage wwSolidColorImage:WW_GRAY_BACKGROUND] forState:UIControlStateHighlighted];
    
    
    [self.clearFiltersButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.clearFiltersButton setTitleColor:WW_LIGHT_GRAY_BUTTON_COLOR forState:UIControlStateDisabled];
    [self.clearFiltersButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    
    self.clearFiltersButton.titleLabel.font = WW_FONT_H4;
    
    //Location autocomplete
    self.locationFilterController = [WWLocationFilterViewController new];
    
    __weak __typeof(&*self) weakSelf = self;
    self.locationFilterController.locationSelectedBlock = ^(WWArea* autoCompleteResult)
    {
        if (autoCompleteResult)
        {
            weakSelf.currentSearchArgs.locationName = autoCompleteResult.name;
            
            weakSelf.currentSearchArgs.minlatitude = autoCompleteResult.minLatitude;
            weakSelf.currentSearchArgs.maxlatitude = autoCompleteResult.maxLatitude;
            weakSelf.currentSearchArgs.minlongitude = autoCompleteResult.minLongitude;
            weakSelf.currentSearchArgs.maxlongitude = autoCompleteResult.maxLongitude;
        }
        else
        {
            [weakSelf.currentSearchArgs setGeoboxFromMapRegion:weakSelf.mapRegion];
        }
        
        [weakSelf refreshUi];
    };
    
    self.locationFilterNavController = [[UINavigationController alloc] initWithRootViewController:self.locationFilterController];
    
    self.navigationItem.leftBarButtonItem = [self wwCloseNavItem:@selector(closeFromNavBar)];
    self.navigationItem.titleView = [self wwCenterNavItem:NSLocalizedString(WW_FILTER, nil)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(WW_APPLY_FILTER, nil) style:UIBarButtonItemStylePlain target:self action:@selector(onExecuteSearchClicked:)];
}

- (void) onExecuteSearchClicked:(id)sender
{
    [WWSettings saveCachedSearchArgs:self.currentSearchArgs];
    [self dismissView:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.currentSearchArgs)
    {
        self.currentSearchArgs = [WWSearchArgs new];
    }
    
    [self refreshUi];
}

- (void) refreshUi
{
    if (self.currentSearchArgs.locationName)
    {
        [self.locationFilterButton setTitle:self.currentSearchArgs.locationName forState:UIControlStateNormal];
        self.locationFilterButton.selected = YES;
        self.chooseLocationChevronButton.hidden = YES;
        self.clearLocationButton.hidden = NO;
    }
    else
    {
        [self.locationFilterButton setTitle:NSLocalizedString(WW_CURRENT_LOCATION, nil) forState:UIControlStateNormal];
        self.locationFilterButton.selected = NO;
        self.chooseLocationChevronButton.hidden = NO;
        self.clearLocationButton.hidden = YES;
    }
    
    self.priceOneButton.selected = self.currentSearchArgs.priceOne.boolValue;
    self.priceTwoButton.selected = self.currentSearchArgs.priceTwo.boolValue;
    self.priceThreeButton.selected = self.currentSearchArgs.priceThree.boolValue;
    self.priceFourButton.selected = self.currentSearchArgs.priceFour.boolValue;
    self.categoryCoffeeButton.selected = self.currentSearchArgs.categoryCoffee.boolValue;
    self.categoryBarButton.selected = self.currentSearchArgs.categoryBar.boolValue;
    self.categoryRestaurantButton.selected = self.currentSearchArgs.categoryRestaurant.boolValue;
    self.categorySnackButton.selected = self.currentSearchArgs.categorySnack.boolValue;
    self.openNowButton.selected = self.currentSearchArgs.openRightNow.boolValue;
    self.trendingOnlyButton.selected = self.currentSearchArgs.trendingOnly.boolValue;
    
    [self.delegate refreshFilterButton];
    [self refreshClearButton];
    [self refreshPriceContainer];
    [self refreshCategoryContainer];
}

- (void) refreshPriceContainer
{
    if ((self.currentSearchArgs.priceOne == nil || !self.currentSearchArgs.priceOne.boolValue) &&
        (self.currentSearchArgs.priceTwo == nil || !self.currentSearchArgs.priceTwo.boolValue) &&
        (self.currentSearchArgs.priceThree == nil || !self.currentSearchArgs.priceThree.boolValue) &&
        (self.currentSearchArgs.priceFour == nil || !self.currentSearchArgs.priceFour.boolValue))
    {
        [self.priceButtonContainer wwStyleLightGrayButtonBorder];
    }
    else
    {
        [self.priceButtonContainer wwStyleLightOrangeBorder];
    }
}

- (void) refreshCategoryContainer
{
    if ((self.currentSearchArgs.categoryCoffee == nil || !self.currentSearchArgs.categoryCoffee.boolValue) &&
        (self.currentSearchArgs.categoryBar == nil || !self.currentSearchArgs.categoryBar.boolValue) &&
        (self.currentSearchArgs.categoryRestaurant == nil || !self.currentSearchArgs.categoryRestaurant.boolValue) &&
        (self.currentSearchArgs.categorySnack == nil || !self.currentSearchArgs.categorySnack.boolValue))
    {
        [self.categoryButtonContainer wwStyleLightGrayButtonBorder];
    }
    else
    {
        [self.categoryButtonContainer wwStyleLightOrangeBorder];
    }
}

- (void) refreshClearButton
{
    if (self.currentSearchArgs.locationName == nil &&
        (self.currentSearchArgs.trendingOnly == nil || !self.currentSearchArgs.trendingOnly.boolValue) &&
        (self.currentSearchArgs.openRightNow == nil || !self.currentSearchArgs.openRightNow.boolValue) &&
        (self.currentSearchArgs.priceOne == nil || !self.currentSearchArgs.priceOne.boolValue) &&
        (self.currentSearchArgs.priceTwo == nil || !self.currentSearchArgs.priceTwo.boolValue) &&
        (self.currentSearchArgs.priceThree == nil || !self.currentSearchArgs.priceThree.boolValue) &&
        (self.currentSearchArgs.priceFour == nil || !self.currentSearchArgs.priceFour.boolValue) &&
        (self.currentSearchArgs.categoryCoffee == nil || !self.currentSearchArgs.categoryCoffee.boolValue) &&
        (self.currentSearchArgs.categoryBar == nil || !self.currentSearchArgs.categoryBar.boolValue) &&
        (self.currentSearchArgs.categoryRestaurant == nil || !self.currentSearchArgs.categoryRestaurant.boolValue) &&
        (self.currentSearchArgs.categorySnack == nil || !self.currentSearchArgs.categorySnack.boolValue))
    {
        self.clearFiltersButton.enabled = NO;
    }
    else
    {
        self.clearFiltersButton.enabled = YES;
    }
}

- (IBAction)onOpenNowClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_OPEN_NOW];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.openRightNow = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.openRightNow = @(btn.selected);
    }
    [self refreshClearButton];
}

- (IBAction)onLocationFilterClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_LOCATION];
    
    self.locationFilterController.mapRegion = self.mapRegion;
    [self presentViewController:self.locationFilterNavController animated:YES completion:nil];
}

- (IBAction)onTrendingOnlyClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_TRENDING];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    self.currentSearchArgs.trendingOnly = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.trendingOnly = @(btn.selected);
    }
    [self refreshClearButton];
}

- (IBAction)onPriceOneClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_PRICE];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.priceOne = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.priceOne = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshPriceContainer];
}

- (IBAction)onPriceTwoClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_PRICE];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.priceTwo = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.priceTwo = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshPriceContainer];
}

- (IBAction)onPriceThreeClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_PRICE];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.priceThree = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.priceThree = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshPriceContainer];
}

- (IBAction)onPriceFourClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_FILTER_SELECT_PRICE];
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.priceFour = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.priceFour = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshPriceContainer];
}

- (IBAction)onCategoryCoffeeClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.categoryCoffee = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.categoryCoffee = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshCategoryContainer];
}

- (IBAction)onCategoryBarClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.categoryBar = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.categoryBar = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshCategoryContainer];
}

- (IBAction)onCategoryRestaurantClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.categoryRestaurant = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.categoryRestaurant = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshCategoryContainer];
}

- (IBAction)onCategorySnackClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    self.currentSearchArgs.categorySnack = nil;
    if(btn.selected)
    {
        self.currentSearchArgs.categorySnack = @(btn.selected);
    }
    [self refreshClearButton];
    [self refreshCategoryContainer];
}

- (IBAction)onDismissKeyboard:(id)sender
{
}

- (IBAction)onClearFilters:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_FILTER_CLEAR_FILTER];
    
    [self.currentSearchArgs clearFilterArgs];
    
    WWSearchArgs* cached = [WWSettings cachedSearchArgs];
    self.currentSearchArgs.minlongitude = cached.minlongitude;
    self.currentSearchArgs.maxlongitude = cached.maxlongitude;
    self.currentSearchArgs.minlatitude = cached.minlatitude;
    self.currentSearchArgs.maxlatitude = cached.maxlatitude;
    
    [self refreshUi];
    [self onExecuteSearchClicked:nil];
}

- (IBAction)onClearLocationFilterClicked:(id)sender
{
    self.currentSearchArgs.locationName = nil;
    
    WWSearchArgs* cached = [WWSettings cachedSearchArgs];
    self.currentSearchArgs.minlongitude = cached.minlongitude;
    self.currentSearchArgs.maxlongitude = cached.maxlongitude;
    self.currentSearchArgs.minlatitude = cached.minlatitude;
    self.currentSearchArgs.maxlatitude = cached.maxlatitude;
    
    [self refreshUi];
}

- (void) closeFromNavBar
{
    [self dismissView:YES];
}

- (void) dismissView:(BOOL)cancelled
{
    [self.delegate refreshFilterButton];
    
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
