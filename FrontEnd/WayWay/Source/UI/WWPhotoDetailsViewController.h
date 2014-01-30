//
//  WWPhotoDetailsViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 10/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPhotoDetailsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) WWPlace* place;
@property (nonatomic, strong) NSArray* photos;

// Photo to be selected
@property (nonatomic, strong) WWPhoto* photo;

//Filter to be applied
@property (assign) WWPhotoFilter currentFilter;

// Hash tag to be highlighted
@property (nonatomic, copy) NSString* highlightedHashTag;

@end
