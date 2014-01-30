//
//  WWPhotoCell.h
//  WayWay
//
//  Created by Ryan DeVore on 6/27/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#define WW_PHOTO_CELL_ID @"WWPhotoCellId"

#import "WWInclude.h"

@interface WWPhotoCell : UICollectionViewCell <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *instagramUserView;
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;

- (void) update:(WWPhoto*)photo highlightedHashTag:(NSString*)hashTag;

@end
