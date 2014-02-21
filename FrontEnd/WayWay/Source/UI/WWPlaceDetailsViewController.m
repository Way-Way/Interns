//
//  WWPlaceDetailsViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 6/25/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"
#define BORDER_LAYER_TAG  1

@interface WWPlaceDetailsViewController () <UIGestureRecognizerDelegate>
{
    CGFloat _dragStart;
}

@property (nonatomic, strong) NSArray* photos;
@property (nonatomic, strong) WWPagedSearchResults* searchResults;
@property (assign) WWPhotoFilter currentFilter;
@property (nonatomic, strong) CALayer* fakeNavBottomBorder;

@end

@implementation WWPlaceDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentFilter = WWPhotoFilterNone;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WWPlacePhotoGridCell" bundle:nil] forCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WWHashTagSummaryHeaderView" bundle:nil] forCellWithReuseIdentifier:@"WWHashTagSummaryHeaderViewId"];
    [self.collectionView registerClass:[WWSpacerCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WWSpacerCellId"];
    
    self.categoriesLabel.font = WW_FONT_H5;
    self.categoriesLabel.textColor = WW_LIGHT_GRAY_FONT_COLOR;
    
    self.headerLabel.font = WW_FONT_H3;
    self.centeredHeaderLabel.font = WW_FONT_H3;
    
    self.behindStatusBarView.backgroundColor = WW_HEADER_BACKGROUND_COLOR;
    self.headerView.backgroundColor = WW_HEADER_BACKGROUND_COLOR;
    self.behindInfoView.backgroundColor = WW_HEADER_BACKGROUND_COLOR;
    self.infoView.backgroundColor = [UIColor clearColor];
    self.headerContainerView.backgroundColor = [UIColor clearColor];
    
    
    //Layer under place title
    CALayer* layer = [CALayer layer];
    layer.borderColor = [[UIColor uuColorFromHex:@"ADADAD"] CGColor];
    layer.borderWidth = 0.5f;
    [self.headerView.layer addSublayer:layer];
    self.fakeNavBottomBorder = layer;
    self.fakeNavBottomBorder.hidden = YES;
    
    //layer over screen collection view
    /*CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat borderWidth = screen.size.width;
    UIColor *borderColor = [UIColor uuColorFromHex:@"ADADAD"];
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, borderWidth, 0.5f)];
    
    topBorder.opaque = YES;
    topBorder.backgroundColor = borderColor;
    topBorder.tag = BORDER_LAYER_TAG;
    [self.collectionView addSubview:topBorder];*/
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat borderWidth = self.fakeNavBottomBorder.borderWidth;
    self.fakeNavBottomBorder.frame = CGRectMake(0, self.headerView.bounds.size.height - borderWidth, self.view.bounds.size.width, borderWidth);
    self.fakeNavBottomBorder.hidden = YES;
    
    if (!self.place)
    {
        NSLog(@" ***** ERROR!! How did we get a nil place here! ***** ");
        return;
    }
    
    if (self.currentFilter == WWPhotoFilterNone)
    {
        [self onTagsButtonClicked:nil];
    }
    
    
    
    self.tagsButton.hidden = NO;
    self.foodButton.hidden = NO;
    self.atmosphereButton.hidden = NO;
    self.peopleButton.hidden = NO;

    
    self.foodButton.enabled = self.place.hasFoodPhoto;
    self.peopleButton.enabled = self.place.hasPeoplePhoto;
    self.atmosphereButton.enabled = self.place.hasAtmospherePhoto;
    
    if(!self.place.hasFoodPhoto
       && !self.place.hasPeoplePhoto
       && !self.place.hasAtmospherePhoto)
    {
        self.tagsButton.hidden = YES;
        self.foodButton.hidden = YES;
        self.atmosphereButton.hidden = YES;
        self.peopleButton.hidden = YES;
    }
       
    
    [self refreshUi];
}

- (void) refreshUi
{
    [self.collectionView reloadData];
    [self refreshNoPhotosLabel];
    
    [self refreshHeaderView];
    [self refreshInfoView];
}

- (void) refreshNoPhotosLabel
{
    self.noPhotosLabel.hidden = YES;//(self.place.photos.count > 0);
    self.collectionView.hidden = NO;//(self.place.photos.count <= 0);
}

- (void) refreshHeaderView
{
    [self wwFormatScoreLabel:self.scoreLabel place:self.place];
    self.headerLabel.text = self.place.name;
    self.centeredHeaderLabel.text = self.place.name;
}

- (void) refreshInfoView
{
#warning : This is just for test
    self.categoriesLabel.text = [self.place combinedCategories];
    //self.categoriesLabel.text = [self.place relevantHashtags];
    self.trendingIcon.hidden = !self.place.isTrending.boolValue;
    
    [self refreshInfoLabel];
    
    [self.infoLabel wwResizeWidth];
    
    CGRect f = self.trendingIcon.frame;
    f.origin.x = self.infoLabel.frame.origin.x + self.infoLabel.frame.size.width;
    f.origin.y = self.infoLabel.frame.origin.y + (self.infoLabel.frame.size.height / 2) - (f.size.height / 2);
    self.trendingIcon.frame = f;
}

- (void) refreshInfoLabel
{
    UIColor* baseColor = WW_LIGHT_GRAY_FONT_COLOR;
    UIColor* blackColor = [UIColor blackColor];
    UIColor* trendingColor = WW_ORANGE_FONT_COLOR;
    
    NSDictionary* baseAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : baseColor };
    NSDictionary* blackAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : blackColor };
    NSDictionary* trendingAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : trendingColor };
    NSDictionary* pointAttrs = @{NSFontAttributeName : WW_FONT_H6, NSForegroundColorAttributeName : WW_LIGHT_GRAY_BUTTON_COLOR};
    
    
    NSString* distanceString = [self.place formattedDistance];
    
    NSMutableString* sb = [NSMutableString string];
    [sb appendFormat:@"$$$$ • %@", distanceString];
    
    NSString* trendingString = @"Trending";
    if (self.place.isTrending.boolValue)
    {
        [sb appendFormat:@" • %@", trendingString];
    }
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:sb attributes:nil];
    [as setAttributes:baseAttrs range:NSMakeRange(0, as.string.length)];
    [as setAttributes:blackAttrs range:NSMakeRange(0, self.place.price.length)];
    [as setAttributes:blackAttrs range:[sb rangeOfString:distanceString]];
    [as setAttributes:trendingAttrs range:[sb rangeOfString:trendingString]];
    [as setAttributes:pointAttrs range:[sb rangeOfString:@"•"]];
    
    self.infoLabel.attributedText = as;
}

#pragma mark - Collection View

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photos && self.photos.count > 0)
    {
        return self.photos.count;
    }
    else
    {
        int cells = (int)(collectionView.bounds.size.height / 106.0f) + 1;
        return 3 * cells;
    }
}

- (BOOL) shouldDrawRightBorder:(NSIndexPath*)indexPath
{
    //Revise this !!!
    // 107 + 107 + 106 = 320
    if(self.photos.count == 0)
        return NO;
    
    
    if (self.currentFilter == WWPhotoFilterTags)
    {
        id current = self.photos[indexPath.row];
        if (![current isKindOfClass:[WWPhoto class]])
        {
            return NO;
        }
        
        // Walk back to the previous hash tag index
        int i = 0;
        for (i = indexPath.row; i >= 0; i--)
        {
            id obj = self.photos[i];
            if ([obj isKindOfClass:[WWHashtag class]])
            {
                break;
            }
        }
        
        i++; // Move past the one we just found
        
        int relativeIndex = indexPath.row - i;
        
        if ((relativeIndex % 3) == 2)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if ((indexPath.row % 3) == 2)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photos && self.photos.count > 0)
    {
        id rowData = self.photos[indexPath.row];
        
        if ([rowData isKindOfClass:[WWPhoto class]])
        {
            // 107 + 107 + 106 = 320
            if ([self shouldDrawRightBorder:indexPath])
            {
                //NSLog(@"row %d is 107x106", indexPath.row);
                return CGSizeMake(107, 106);
            }
            else
            {
                //NSLog(@"row %d is 106x106", indexPath.row);
                return CGSizeMake(106, 106);
            }
        }
        else if ([rowData isKindOfClass:[WWHashtag class]])
        {
            return CGSizeMake(320, 44);
        }
        else
        {
            return CGSizeZero;
        }
    }
    else
    {
        if (self.currentFilter == WWPhotoFilterTags)
        {
            if ((indexPath.row % 4) == 0)
            {
                return CGSizeMake(320, 44);
            }
        }
        
        if ([self shouldDrawRightBorder:indexPath])
        {
            //NSLog(@"placeholder row %d is 107x106", indexPath.row);
            return CGSizeMake(107, 106);
        }
        else
        {
            //NSLog(@"placeholder row %d is 106x106", indexPath.row);
            return CGSizeMake(106, 106);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.currentFilter == WWPhotoFilterTags)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL drawRightBorder = [self shouldDrawRightBorder:indexPath];
    
    if (self.photos && self.photos.count > 0)
    {
        id rowData = self.photos[indexPath.row];
        
        if ([rowData isKindOfClass:[WWPhoto class]])
        {
            WWPlacePhotoGridCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID forIndexPath:indexPath];
            WWPhoto* photoInfo = (WWPhoto*)rowData;
            [cell update:photoInfo drawRightBorder:drawRightBorder];
            return cell;
        }
        else if ([rowData isKindOfClass:[WWHashtag class]])
        {
            WWHashTagSummaryHeaderView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WWHashTagSummaryHeaderViewId" forIndexPath:indexPath];
            cell.photoIcon.hidden = NO;
            WWHashtag* hashTag = (WWHashtag*)rowData;
            
            id prev = nil;
            int prevIndex = indexPath.row - 1;
            if (prevIndex >= 0 && prevIndex < self.photos.count)
            {
                prev = self.photos[prevIndex];
            }
            
            id next = nil;
            int nextIndex = indexPath.row + 1;
            if (nextIndex >= 0 && nextIndex < self.photos.count)
            {
                next = self.photos[nextIndex];
            }
            
            [cell update:hashTag prev:prev next:next];
            return cell;
        }
        else
        {
            WWDebugLog(@"Unknown row data type: %@", [rowData class]);
            return nil;
        }
    }
    else
    {
        if (self.currentFilter == WWPhotoFilterTags)
        {
            if ((indexPath.row % 4) == 0)
            {
                WWHashTagSummaryHeaderView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WWHashTagSummaryHeaderViewId" forIndexPath:indexPath];
                cell.hashTagLabel.text = @"";
                cell.countLabel.text = @"";
                return cell;
            }
            else
            {
                WWPlacePhotoGridCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID forIndexPath:indexPath];
                [cell clearUi:drawRightBorder];
                return cell;
            }
            
        }
        else
        {
            WWPlacePhotoGridCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID forIndexPath:indexPath];
            [cell clearUi:drawRightBorder];
            return cell;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGFloat y = self.buttonContainerView.frame.origin.y + self.buttonContainerView.frame.size.height;
    CGFloat diff = self.view.frame.size.height - y;
    
    CGFloat h = diff + self.buttonContainerView.frame.size.height + diff;
    return CGSizeMake(collectionView.frame.size.width, h);
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([UICollectionElementKindSectionFooter isEqualToString:kind])
    {
        WWSpacerCell* cell = (WWSpacerCell*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WWSpacerCellId" forIndexPath:indexPath];
        
        if (self.currentFilter == WWPhotoFilterTags)
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            cell.backgroundColor = [UIColor blackColor];
        }
        
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photos && self.photos.count > 0)
    {
        id rowData = self.photos[indexPath.row];
        
        if ([rowData isKindOfClass:[WWPhoto class]])
        {
            if (self.currentFilter == WWPhotoFilterTags)
            {
                [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_SMALL_PHOTO_BELOW_HASHTAG];
            }
            else
            {
                [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_SMALL_PHOTO];
            }
            
            WWPhoto* photo = (WWPhoto*)rowData;
            NSMutableDictionary* d = [NSMutableDictionary dictionary];
            [d setValue:self.place forKey:@"place"];
            [d setValue:photo forKey:@"photo"];
            [d setValue:[self findHashTagAboveIndex:indexPath] forKey:@"hashtag"];
            [d setValue:[NSNumber numberWithInteger:(self.currentFilter)] forKey:@"currentFilter"];
            
            NSArray* photoList = [self findPhotosInCurrentSection:indexPath];
            [d setValue:photoList forKey:@"photos"];
            
            //This is for photo animated transition - Jon Evans
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            CGRect frame = [collectionView convertRect:cell.frame toView:self.view];
            CGPoint center = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
            [d setValue:[NSValue valueWithCGPoint:center] forKey:@"viewCenter"];
            //
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_PHOTO_NOTIFICATION object:d];
        }
        else if ([rowData isKindOfClass:[WWHashtag class]])
        {
            [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_HASH_TAG];
            
            WWHashtag* hashTag = (WWHashtag*)rowData;
            
            NSMutableDictionary* d = [NSMutableDictionary dictionary];
            [d setValue:self.place forKey:@"place"];
            [d setValue:hashTag forKey:@"hashtag"];
            [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_PHOTOS_BY_HASH_TAG_NOTIFICATION object:d];
        }
    }
}

- (NSArray*) findPhotosInCurrentSection:(NSIndexPath*)indexPath
{
    //Revise this !!!
    
    if (self.currentFilter == WWPhotoFilterTags)
    {
        NSMutableArray* a = [NSMutableArray array];
        
        // Walk back to the previous hash tag index
        int i = 0;
        for (i = indexPath.row; i >= 0; i--)
        {
            id obj = self.photos[i];
            if ([obj isKindOfClass:[WWHashtag class]])
            {
                break;
            }
        }
        
        i++; // Move past the one we just found
        
        // Now walk forward to the following hash tag
        for (; i < self.photos.count; i++)
        {
            id obj = self.photos[i];
            if ([obj isKindOfClass:[WWHashtag class]])
            {
                break;
            }
            else
            {
                [a addObject:obj];
            }
        }
        
        return [a copy];
    }
    
    return self.photos;
}

- (NSString*) findHashTagAboveIndex:(NSIndexPath*)indexPath
{
    if (self.currentFilter == WWPhotoFilterTags)
    {
        for (int i = indexPath.row; i >= 0; i--)
        {
            id obj = self.photos[i];
            if ([obj isKindOfClass:[WWHashtag class]])
            {
                WWHashtag* hashTag = (WWHashtag*)obj;
                return hashTag.name;
            }
        }
    }
    
    return nil;
}

- (IBAction)onSwipeDetailsUp:(id)sender
{
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(onSwipeDetailsUp)])
    {
        [self.swipeDelegate performSelector:@selector(onSwipeDetailsUp)];
    }
}

- (IBAction)onSwipeDetailsDown:(id)sender
{
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(onSwipeDetailsDown)])
    {
        [self.swipeDelegate performSelector:@selector(onSwipeDetailsDown)];
    }
}

- (IBAction)onToggleDetails:(id)sender
{
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(onToggleDetails)])
    {
        [self.swipeDelegate performSelector:@selector(onToggleDetails)];
    }
}

- (IBAction)onLongPress:(id)sender
{
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(onLongPress:)])
    {
        [self.swipeDelegate performSelector:@selector(onLongPress:) withObject:sender];
    }
}

- (IBAction)onTagsButtonClicked:(id)sender
{
    if(sender)
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_TAGS_TAB];
    }
    
    self.tagsButton.selected = YES;
    self.foodButton.selected = NO;
    self.atmosphereButton.selected = NO;
    self.peopleButton.selected = NO;
    
    [self changePhotoFilter:WWPhotoFilterTags];
}

- (IBAction)onFoodButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_FOOD_TAB];
    
    self.tagsButton.selected = NO;
    self.foodButton.selected = YES;
    self.atmosphereButton.selected = NO;
    self.peopleButton.selected = NO;
    
    [self changePhotoFilter:WWPhotoFilterFood];
}

- (IBAction)onAtmosphereButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ATMOSPHERE_TAB];
    
    self.tagsButton.selected = NO;
    self.foodButton.selected = NO;
    self.atmosphereButton.selected = YES;
    self.peopleButton.selected = NO;
    
    [self changePhotoFilter:WWPhotoFilterVenue];
}

- (IBAction)onPeopleButtonClicked:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_PEOPLE_TAB];
    
    self.tagsButton.selected = NO;
    self.foodButton.selected = NO;
    self.atmosphereButton.selected = NO;
    self.peopleButton.selected = YES;
    
    [self changePhotoFilter:WWPhotoFilterPeople];
}

- (IBAction)onInfoButtonClicked:(id)sender
{
    // The fake status bar is hidden when the view is in half map mode
    if (self.behindStatusBarView.hidden)
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INFO_WHILE_HALF_MAP];
    }
    else
    {
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INFO_WHILE_EXPANDED];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_PLACE_INFO_NOTIFICATION object:self.place];
}

- (void) beginFetchPhotos
{
    [self.collectionView setContentOffset:CGPointZero animated:NO];
    self.photos = nil;
    [self.collectionView reloadData];
    
    NSString* hashtag = nil;
    WWSearchArgs* args = self.currentSearchArgs;
    if([args.autoCompleteType isEqualToString:@"hashtag"])
    {
        hashtag = args.autoCompleteArg;
    }
    
    if(self.currentFilter == WWPhotoFilterTags)
    {
        [self.place beginHashtagFetch:hashtag
                           completion:^(NSArray *hashtagsAndPhotos, WWPagedSearchResults *pagedResults)
         {
             self.photos = [hashtagsAndPhotos copy];
             self.searchResults = pagedResults;
             [self refreshNoPhotosLabel];
             [self.collectionView reloadData];
         }];
    }
    else
    {
        [self.place beginPhotoFetchByFilter:self.currentFilter completion:^(NSArray *photos, WWPagedSearchResults *pagedResults)
         {
             self.photos = [photos copy];
             self.searchResults = pagedResults;
             [self refreshNoPhotosLabel];
             [self.collectionView reloadData];
         }];
    }
}

- (void) onPhotoTabRequestNewPage
{
    NSString* hashtag = nil;
    WWSearchArgs* args = self.currentSearchArgs;
    if([args.autoCompleteType isEqualToString:@"hashtag"])
    {
        hashtag = args.autoCompleteArg;
    }
    
    if(self.currentFilter == WWPhotoFilterTags)
    {
        [self.place fetchNextPageOfHashtags:hashtag completion:^(NSArray *hashtagsAndPhotos, WWPagedSearchResults *pagedResults)
         {
             [self handleNextPageResponse:hashtagsAndPhotos pagedResults:pagedResults];
         }];
    }
    else
    {
        [self.place fetchNextPageOfPhotosByFilter:self.currentFilter completion:^(NSArray *photos, WWPagedSearchResults *pagedResults)
         {
             [self handleNextPageResponse:photos pagedResults:pagedResults];
        }];
    }
}

- (void) handleNextPageResponse:(NSArray*)photos pagedResults:(WWPagedSearchResults*)pagedResults
{
    int oldCount = self.photos.count;
    self.photos = [photos copy];
    int newCount = self.photos.count;
    
    self.searchResults = pagedResults;
    [self refreshNoPhotosLabel];
    
    NSMutableArray* updatedIndexPaths = [NSMutableArray array];
    for (int i = oldCount; i < newCount; i++)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForItem:i inSection:0];
        [updatedIndexPaths addObject:ip];
    }
    
    [self.collectionView performBatchUpdates:^
     {
         [self.collectionView insertItemsAtIndexPaths:updatedIndexPaths];
         
     } completion:^(BOOL finished)
     {
     }];
}

- (void) wwOnPlaceDetailsTapped
{
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(onToggleDetails)])
    {
        [self.swipeDelegate performSelector:@selector(onToggleDetails)];
    }
}

- (void) wwOnPlaceInfoTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_PLACE_INFO_NOTIFICATION object:self.place];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragStart = scrollView.contentOffset.y;
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView
                      withVelocity:(CGPoint)velocity
               targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat diff = _dragStart - scrollView.contentOffset.y;

    if (diff < 0) // dragging down
    {
        [self onPhotoTabRequestNewPage];
    }
}

- (void) changePhotoFilter:(WWPhotoFilter)filter
{
    if (self.currentFilter != filter)
    {
        if (filter == WWPhotoFilterTags)
        {
            // This causes a weird visual effect when returning to this view. The
            // collection view redraws briefly and you see one flash of the
            // background color between cells
            //self.collectionView.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            self.collectionView.backgroundColor = [UIColor blackColor];
        }
        
        [self.collectionView reloadData];
        
        self.currentFilter = filter;
        [self beginFetchPhotos];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.infoButton];
    if ([self.infoButton pointInside:p withEvent:nil])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void) setViewFullscreen:(NSNumber*)fullScreen animated:(BOOL)animated
{
    self.behindStatusBarView.hidden = !fullScreen.boolValue;
    self.collectionView.scrollEnabled = fullScreen.boolValue;
    self.collectionGestureOverlay.hidden = fullScreen.boolValue;
    
    [UIView animateWithDuration:animated ? 0.2f : 0.0f animations:
     ^{
         [self toggleInfoView:!fullScreen.boolValue];
         [self.collectionView setContentOffset:CGPointZero animated:NO];
         
         self.headerLabel.alpha = fullScreen.boolValue ? 0 : 1;
         self.centeredHeaderLabel.alpha = fullScreen.boolValue ? 1 : 0;
         
         self.navBackButton.alpha = fullScreen.boolValue ? 1 : 0;
         self.scoreLabel.alpha = fullScreen.boolValue ? 0 : 1;
        
     }];
    

    self.fakeNavBottomBorder.hidden = !fullScreen.boolValue;
    //[self.collectionView viewWithTag:BORDER_LAYER_TAG].hidden = fullScreen.boolValue;
}

- (void) toggleInfoView:(BOOL)showInfoView
{
    CGRect newCollectionViewFrame = self.collectionView.frame;
    
    if (showInfoView)
    {
        newCollectionViewFrame.origin.y = self.headerContainerView.bounds.size.height;
    }
    else
    {
        newCollectionViewFrame.origin.y = self.headerView.frame.origin.y + self.headerView.bounds.size.height;
    }
    
    newCollectionViewFrame.size.height = self.view.bounds.size.height - newCollectionViewFrame.origin.y;
    self.collectionView.frame = newCollectionViewFrame;
    
    /*[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    if (showInfoView)
        self.fakeExtendedDetails.alpha = 1.0;
    else
        self.fakeExtendedDetails.alpha = 0.0;
    [UIView commitAnimations];*/
    self.infoView.hidden = !showInfoView;
}

@end
