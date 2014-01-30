//
//  WWFilterViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@protocol WWFilterViewControllerDelegate <NSObject>
-(void) refreshFilterButton;
@end

@interface WWFilterViewController : UIViewController

@property (nonatomic) NSObject<WWFilterViewControllerDelegate>* delegate;

@property (strong, nonatomic) IBOutlet WWFlatButton *locationFilterButton;
@property (strong, nonatomic) IBOutlet WWFlatButton *openNowButton;
@property (strong, nonatomic) IBOutlet WWFlatButton *trendingOnlyButton;
@property (strong, nonatomic) IBOutlet UIButton *priceOneButton;
@property (strong, nonatomic) IBOutlet UIButton *priceTwoButton;
@property (strong, nonatomic) IBOutlet UIButton *priceThreeButton;
@property (strong, nonatomic) IBOutlet UIButton *priceFourButton;
@property (strong, nonatomic) IBOutlet UIView *priceButtonContainer;
@property (strong, nonatomic) IBOutlet UIButton *categoryCoffeeButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryBarButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryRestaurantButton;
@property (strong, nonatomic) IBOutlet UIButton *categorySnackButton;
@property (strong, nonatomic) IBOutlet UIView *categoryButtonContainer;
@property (strong, nonatomic) IBOutlet UIButton *clearFiltersButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseLocationChevronButton;
@property (strong, nonatomic) IBOutlet UIButton *clearLocationButton;
@property (nonatomic, copy) void (^dismissCallback)(BOOL cancelled);

- (IBAction)onOpenNowClicked:(id)sender;
- (IBAction)onLocationFilterClicked:(id)sender;
- (IBAction)onTrendingOnlyClicked:(id)sender;
- (IBAction)onPriceOneClicked:(id)sender;
- (IBAction)onPriceTwoClicked:(id)sender;
- (IBAction)onPriceThreeClicked:(id)sender;
- (IBAction)onPriceFourClicked:(id)sender;
- (IBAction)onCategoryCoffeeClicked:(id)sender;
- (IBAction)onCategoryBarClicked:(id)sender;
- (IBAction)onCategoryRestaurantClicked:(id)sender;
- (IBAction)onCategorySnackClicked:(id)sender;
- (IBAction)onDismissKeyboard:(id)sender;
- (IBAction)onClearFilters:(id)sender;
- (IBAction)onClearLocationFilterClicked:(id)sender;

@property (assign) MKCoordinateRegion mapRegion;

@property (nonatomic, strong) WWSearchArgs* currentSearchArgs;

@end
