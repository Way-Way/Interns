//
//  WWPhotoCell.h
//  WayWay
//
//  Created by Ryan DeVore on 6/27/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#define WW_PHOTO_CELL_ID @"WWPhotoCellId"

#import "WWInclude.h"

@interface WWPhotoCell : UICollectionViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *scrollContent;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;

@property (strong, nonatomic) IBOutlet UIView *hashtagContainer;

@property (strong, nonatomic) UIView *instagramUserView;

- (void) update:(WWPhoto*)photo highlightedHashTag:(NSString*)hashTag;
-(void) launchHashtagSearch:(id)sender;

@end
