//
//  WWMenuSectionHeader.h
//  WayWay
//
//  Created by Ryan DeVore on 8/6/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWMenuSectionHeader : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *sectionTitle;
@property (strong, nonatomic) IBOutlet UIButton *expandButton;

@end
