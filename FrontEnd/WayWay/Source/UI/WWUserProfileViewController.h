//
//  WWUserProfileViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 7/12/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@interface WWUserProfileViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (strong, nonatomic) IBOutlet UITableView *tableViewFirst;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSecond;

@end


@interface WWGradientView : UIView
{
    
}

@property (nonatomic, retain) UIColor* beginGradientColor;
@property (nonatomic, retain) UIColor* endGradientColor;

+ (UIImage*) buildGradientView:(CGRect)rect start:(UIColor*)start end:(UIColor*)end;

@end


