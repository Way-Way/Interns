//
//  WWHomeViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWHomeViewController : UIViewController
<
    MKMapViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,

    WWPlaceDetailsViewControllerDelegate,
    WWFilterViewControllerDelegate
>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UICollectionView *infoCollectionView;

@property (strong, nonatomic) IBOutlet UIView *progressCacheView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *progressAnimation;


@property (strong, nonatomic) IBOutlet UIView* noResultsPanel;
@property (strong, nonatomic) IBOutlet UIView *behindStatusBarView;
@property (strong, nonatomic) IBOutlet UIGestureRecognizer* longPressGesture;


//@property (strong, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *locateMeButton;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic) IBOutlet UILabel *noPlacesFoundLabel;
@property (assign) BOOL forceLeftMenuAlways;
@property (assign) BOOL hasSetupMap;
@property (strong, nonatomic) IBOutlet UIImageView *shadowView;

// If set these are to be used over the cached args
@property (nonatomic, strong) WWSearchArgs* fixedSearchArgs;

- (IBAction)onRefreshButtonTapped:(id)sender;
- (IBAction)onLocateMeClicked:(id)sender;
- (IBAction)onListButtonClicked:(id)sender;

- (void) changeSelectedPlace:(WWPlace*)p;
- (void)refreshResults;
- (void) beginPlaceSearch;

@end
