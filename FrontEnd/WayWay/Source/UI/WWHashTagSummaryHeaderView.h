//
//  WWHashTagSummaryHeaderView.h
//  WayWay
//
//  Created by Ryan DeVore on 10/18/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWHashTagSummaryHeaderView : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *hashTagLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoIcon;

- (void) update:(WWHashtag*)hashTag prev:(id)prev next:(id)next;

@end
