//
//  WWPlacePhotoGridCell.h
//  WayWay
//
//  Created by Ryan DeVore on 6/25/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_PLACE_PHOTO_GRID_CELL_ID @"WWPlacePhotoGridCellId"

@interface WWPlacePhotoGridCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;
@property (strong, nonatomic) IBOutlet UIImageView *placeholderPhoto;

- (void) update:(WWPhoto*)photo;
- (void) update:(WWPhoto*)photo drawRightBorder:(BOOL)drawRightBorder;
- (void) update:(WWPhoto*)photo drawRightBorder:(BOOL)drawRightBorder drawBottomBorder:(BOOL)drawBottomBorder;
- (void) clearUi:(BOOL)drawRightBorder;
- (void) clearUi:(BOOL)drawRightBorder drawBottomBorder:(BOOL)drawBottomBorder;

@end
