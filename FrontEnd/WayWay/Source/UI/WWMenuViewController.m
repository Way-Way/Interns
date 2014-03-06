//
//  WWMenuViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_MENU_SECTION_CELL_ID @"WWMenuSectionCellId"

@interface WWMenuViewController ()

@property (nonatomic, strong) NSArray* tableData;

@end

@implementation WWMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.rankView = [WWRankView wwLoadAndReplaceView:self.rankView];
    self.tableView.backgroundColor = WW_GRAY_COLOR_2;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backNavView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WWMenuSectionCell" bundle:nil] forCellReuseIdentifier:WW_MENU_SECTION_CELL_ID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = self.place.name;
    //[self.rankView update:self.place];
    [self refreshDataFromServer];
}

- (void) refreshDataFromServer
{
    [self showProgress:nil];
    self.noMenuPanel.hidden = YES;
    
    [[WWServer sharedInstance] listMenus:self.place completion:^(NSError *error, NSArray *results)
    {
        self.tableData = results;
        [self.tableView reloadData];
        
        [self hideProgress:^
        {
            self.tableView.hidden = (results.count <= 0);
            self.noMenuPanel.hidden = !self.tableView.hidden;
        }];
        
    }];
}

- (void) showProgress:(NSString*)message
{
    if (!message)
    {
        message = @"Loading";
    }
    
    self.progressLabel.text = message;
    [self.view bringSubviewToFront:self.progressView];
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressView.alpha = 1.0f;
     }];
}

- (void) hideProgress:(void (^)())completion
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.progressView.alpha = 0.0f;
     }
    completion:^(BOOL finished)
     {
        if (completion)
        {
            completion();
        }
     }];
}

- (IBAction)onBackNavTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table callbacks

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWMenu* menu = [self.tableData objectAtIndex:indexPath.row];
    
    WWMenuSectionCell* cell = [tableView dequeueReusableCellWithIdentifier:WW_MENU_SECTION_CELL_ID forIndexPath:indexPath];
    cell.sectionTitleLabel.text = menu.title;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellData = [self.tableData objectAtIndex:indexPath.row];
    if ([cellData isKindOfClass:[WWMenu class]])
    {
        WWMenu* menu = [self.tableData objectAtIndex:indexPath.row];
        
        WWMenuSectionViewController* c = [[WWMenuSectionViewController alloc] initWithNibName:@"WWMenuViewController" bundle:nil];
        c.place = self.place;
        c.menu = menu;
        [self.navigationController pushViewController:c animated:YES];
    }
}

@end
