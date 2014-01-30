//
//  WWPhotoHashTagViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 11/22/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPhotoHashTagViewController ()
{
    CGFloat _dragStart;
}

@property (nonatomic, strong) NSArray* photos;
@property (nonatomic, strong) WWPagedSearchResults* searchResults;
@property (nonatomic) BOOL beginFetchPhotosDone;
@property (nonatomic, strong) CALayer* backgroundLayer;
@end

@implementation WWPhotoHashTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WWPlacePhotoGridCell" bundle:nil] forCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID];
    
    self.beginFetchPhotosDone = NO;
    
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = [[UIColor blackColor] CGColor];
    layer.bounds = self.view.bounds;
    self.backgroundLayer = layer;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
    self.navigationItem.titleView = [self wwCenterNavItem:[@"#" stringByAppendingString:self.hashTag.name]];
    
    if (self.beginFetchPhotosDone == NO)
        [self beginFetchPhotos];
    
    self.backgroundLayer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Collection View

- (BOOL) shouldDrawRightBorder:(NSIndexPath*)indexPath
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

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hashTag.count.integerValue;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self shouldDrawRightBorder:indexPath])
    {
        return CGSizeMake(107, 106);
    }
    else
    {
        return CGSizeMake(106, 106);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL drawRightBorder = [self shouldDrawRightBorder:indexPath];
    
    WWPlacePhotoGridCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WW_PLACE_PHOTO_GRID_CELL_ID forIndexPath:indexPath];
    cell.photo.image = nil;
    
    if (indexPath.row >= 0 && indexPath.row < self.photos.count)
    {
        id rowData = self.photos[indexPath.row];
        
        WWPhoto* photoInfo = (WWPhoto*)rowData;
        [cell update:photoInfo drawRightBorder:drawRightBorder drawBottomBorder:YES];
    }
    else
    {
        [cell clearUi:drawRightBorder drawBottomBorder:YES];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 0 && indexPath.row < self.photos.count)
    {
        id rowData = self.photos[indexPath.row];
        WWPhoto* photo = (WWPhoto*)rowData;
        
        NSMutableDictionary* d = [NSMutableDictionary dictionary];
        [d setValue:self.place forKey:@"place"];
        [d setValue:photo forKey:@"photo"];
        [d setValue:self.photos forKey:@"photos"];
        [d setValue:self.hashTag forKey:@"hashTag"];

        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGRect frame = [collectionView convertRect:cell.frame toView:self.view];
        CGPoint center = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        [d setValue:[NSValue valueWithCGPoint:center] forKey:@"viewCenter"];

        [[NSNotificationCenter defaultCenter] postNotificationName:WW_VIEW_PHOTO_NOTIFICATION object:d];
    }
}

- (void) beginFetchPhotos
{
    [self.place beginPhotoFetchByHashTag:self.hashTag.name completion:^(NSArray *photos, WWPagedSearchResults *pagedResults)
    {
        self.photos = [photos copy];
        self.searchResults = pagedResults;
        [self.collectionView reloadData];
    }];
    self.beginFetchPhotosDone = YES;
}

- (void) onPhotoTabRequestNewPage
{
    [self.place fetchNextPageOfPhotosByHashTag:self.hashTag.name completion:^(NSArray *photos, WWPagedSearchResults *pagedResults)
    {
        int oldCount = self.photos.count;
        self.photos = [photos copy];
        int newCount = self.photos.count;
        
        self.searchResults = pagedResults;
        
        NSMutableArray* updatedIndexPaths = [NSMutableArray array];
        for (int i = oldCount; i < newCount; i++)
        {
            NSIndexPath* ip = [NSIndexPath indexPathForItem:i inSection:0];
            [updatedIndexPaths addObject:ip];
        }
        
        [self.collectionView reloadItemsAtIndexPaths:updatedIndexPaths];
    }];
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

@end
