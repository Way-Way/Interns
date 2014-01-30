//
//  WWSettingsViewController.h
//  WayWay
//
//  Created by Ryan DeVore on 7/24/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *geolocSwitch;

- (IBAction)onToggleFacebookClicked:(id)sender;
- (IBAction)onToggleTwitterClicked:(id)sender;
- (IBAction)onToggleGeoLocClicked:(id)sender;

@end
