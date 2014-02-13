//
//  WWPhotoDetailsViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 10/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPhotoDetailsViewController ()
@end

@implementation WWPhotoDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WWPhotoCell" bundle:nil] forCellWithReuseIdentifier:WW_PHOTO_CELL_ID];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.leftBarButtonItem = [self wwBackNavItem];
    
    if (self.highlightedHashTag)
    {
        self.navigationItem.titleView = [self wwCenterNavItem:[@"#" stringByAppendingString:self.highlightedHashTag]];
    }
    else
    {
        self.navigationItem.titleView = [self wwCenterNavItem:self.place.name];
    }
    
    NSUInteger index = [self.photos wwIndexOfPhoto:self.photo];
    
    if (index < self.photos.count)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    //Preload all small resolution images
    [self loadSmallResImages];
}

-(void) loadSmallResImages
{
    for(WWPhoto* photo in self.photos)
    {
        NSURL* photoUrl = [NSURL URLWithString:[photo smallImageUrl]];
        [WWImageDownloader downloadImage:photoUrl photoId:photo.identifier completion:nil];
    }
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WWPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WW_PHOTO_CELL_ID forIndexPath:indexPath];
    WWPhoto* photoInfo = self.photos[indexPath.row];
    [cell update:photoInfo highlightedHashTag:self.highlightedHashTag];
    return cell;
}

#pragma mark - Scroll View

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [Flurry logEvent:WW_FLURRY_EVENT_SCROLL_LARGE_PHOTOS_HORIZONTALLY];
    
    if((self.currentFilter != WWPhotoFilterTags && [self.photos count] < 30) ||
       (self.currentFilter == WWPhotoFilterTags && [self.photos count] > 3 && [self.photos count] < 30))
    {
        return;
    }
    
    int threshold = -1;
    if(self.currentFilter != WWPhotoFilterTags)
    {
        threshold = [self.photos count] - 5;
    }
    else if (self.currentFilter == WWPhotoFilterTags && [self.photos count] > 3)
    {
         threshold = [self.photos count] - 15;
    }
        
    
    UICollectionViewCell* currentCell = ([[self.collectionView visibleCells] count] > 0) ? [[self.collectionView visibleCells] objectAtIndex:0] : nil;
    
    int index;
    if(currentCell != nil)
    {
        index = [self.collectionView indexPathForCell:currentCell].row;
        if(index > threshold)
        {
            if(self.currentFilter != WWPhotoFilterTags)
            {
                [self.place fetchNextPageOfPhotosByFilter:self.currentFilter
                                               completion:^(NSArray *photos, WWPagedSearchResults *pagedResults)
                 {
                     [self handleNextPageResponse:photos pagedResults:pagedResults];
                 }];
            }
            else
            {
                if(self.photos.count <=3)
                {
                    [self.place beginPhotoFetchByHashTag:self.highlightedHashTag
                                              completion:^(NSArray* photos, WWPagedSearchResults* pagedResults)
                     {
                         [self handleNextPageResponse:photos pagedResults:pagedResults];
                     }];
                }
                else
                {
                    [self.place fetchNextPageOfPhotosByHashTag:self.highlightedHashTag
                                                    completion:^(NSArray* photos, WWPagedSearchResults* pagedResults)
                     {
                         [self handleNextPageResponse:photos pagedResults:pagedResults];
                     }];
                }
            }
        }
    }
}

- (void) handleNextPageResponse:(NSArray*)photos pagedResults:(WWPagedSearchResults*)pagedResults
{
    int oldCount = self.photos.count;
    
    if(self.currentFilter != WWPhotoFilterTags)
        self.photos = [photos copy];
    else
    {
        //This is a hack??
        //first 3 photos
        int lastIndexToKeep = MIN(2, self.photos.count-1);
        NSArray* firstPhotos = [self.photos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, lastIndexToKeep + 1)]];
        self.photos = [firstPhotos arrayByAddingObjectsFromArray:[photos copy]];
    }
    int newCount = self.photos.count;
    
    [self loadSmallResImages];
    
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

@end
