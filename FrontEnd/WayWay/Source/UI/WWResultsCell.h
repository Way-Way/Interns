//
//  WWResultsCell.h
//  WayWay
//
//  Created by Ryan DeVore on 5/31/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWResultsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *trendingIcon;
//@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *dimmerView;

@property (strong, nonatomic) WWListLabel *listLabel;

- (void) update:(WWPlace*)place hashtag:(NSString*)hashtag displayLabel:(BOOL)displayLabel;

@end

