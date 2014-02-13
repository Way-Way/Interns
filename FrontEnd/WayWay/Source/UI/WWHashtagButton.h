//
//  WWHashtagButton.h
//  WayWay
//
//  Created by OMB Labs on 2/4/14.
//  Copyright (c) 2014 OMB Labs. All rights reserved.
//

#import "WWInclude.h"

@interface WWHashtagButton : UIButton
@property (nonatomic, strong) NSString* hashtag;

- (id)initWithFrame:(CGRect)frame;
-(void) setHashtag:(NSString*)hashtag withColor:(UIColor*)color;
@end
