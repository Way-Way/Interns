//
//  WWMenuItemCell.h
//  WayWay
//
//  Created by Ryan DeVore on 8/6/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWMenuItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;

@end
