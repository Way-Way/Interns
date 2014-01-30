//
//  WWPhotoHashTagViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 11/22/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPhotoHashTagViewController  : UIViewController
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate
>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) WWPlace* place;
@property (nonatomic, strong) WWHashtag* hashTag;

@end

