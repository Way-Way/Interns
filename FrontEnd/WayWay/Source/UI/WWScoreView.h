//
//  WWScoreView.h
//  WayWay
//
//  Created by OMB Labs on 2/26/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@interface WWScoreView : UIView
@property BOOL isTrending;
@property (strong, nonatomic) NSNumber* score;
@property (strong, nonatomic) UILabel* scoreLabel;
@end
