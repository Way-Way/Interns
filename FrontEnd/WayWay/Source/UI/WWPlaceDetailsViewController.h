//
//  WWPlaceDetailsViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 6/25/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

@interface WWMenuButton : UIButton

@end


#import "WWInclude.h"


@protocol WWPlaceDetailsViewControllerDelegate <NSObject>

- (void) onSwipeDetailsUp;
- (void) onSwipeDetailsDown;
- (void) onToggleDetails;
- (void) onLongPress:(UIGestureRecognizer*)gesture;

@end

@interface WWPlaceDetailsViewController : UIViewController
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate
>

@property (nonatomic, strong) WWPlace* place;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *tagsButton;
@property (strong, nonatomic) IBOutlet UIButton *foodButton;
@property (strong, nonatomic) IBOutlet UIButton *atmosphereButton;
@property (strong, nonatomic) IBOutlet UIButton *peopleButton;

@property (strong, nonatomic) IBOutlet UILabel *noPhotosLabel;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIView *buttonContainerView;



@property (strong, nonatomic) IBOutlet UIImageView *trendingIcon;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) IBOutlet UIView *behindStatusBarView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *collectionGestureOverlay;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *navBackButton;
@property (strong, nonatomic) IBOutlet UIView *behindInfoView;
@property (strong, nonatomic) IBOutlet UILabel *centeredHeaderLabel;

@property (strong, nonatomic) WWSearchArgs* currentSearchArgs;

@property (nonatomic, strong) NSObject<WWPlaceDetailsViewControllerDelegate>* swipeDelegate;

- (IBAction)onSwipeDetailsUp:(id)sender;
- (IBAction)onSwipeDetailsDown:(id)sender;
- (IBAction)onToggleDetails:(id)sender;
- (IBAction)onLongPress:(id)sender;

- (IBAction)onTagsButtonClicked:(id)sender;
- (IBAction)onFoodButtonClicked:(id)sender;
- (IBAction)onAtmosphereButtonClicked:(id)sender;
- (IBAction)onPeopleButtonClicked:(id)sender;
- (IBAction)onInfoButtonClicked:(id)sender;

- (void) setViewFullscreen:(NSNumber*)fullScreen animated:(BOOL)animated;

@end
