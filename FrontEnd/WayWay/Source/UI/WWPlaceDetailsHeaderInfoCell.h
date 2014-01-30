//
//  WWPlaceDetailsHeaderInfoCell.h
//  WayWay
//
//  Created by Ryan DeVore on 10/27/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPlaceDetailsHeaderInfoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *trendingIcon;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoriesLabel;

- (void) update:(WWPlace*)place;

@end
