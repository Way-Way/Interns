//
//  WWMenuSectionViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 8/6/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_MENU_ITEM_CELL_ID @"WWMenuItemCellId"
#define WW_MENU_SECTION_HEADER_ID @"WWMenuSectionHeaderId"

@interface WWMenuSectionViewController ()

@end

@implementation WWMenuSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.rankView = [WWRankView wwLoadAndReplaceView:self.rankView];
    self.tableView.backgroundColor = WW_GRAY_COLOR_2;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backNavView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WWMenuItemCell" bundle:nil] forCellReuseIdentifier:WW_MENU_ITEM_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"WWMenuSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:WW_MENU_SECTION_HEADER_ID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = self.place.name;
    self.progressView.hidden = YES;
    self.noMenuPanel.hidden = YES;
    //[self.rankView update:self.place];
    [self.tableView reloadData];
}

- (IBAction)onBackNavTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table callbacks

- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menu.sections.count;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WWMenuSection* menuSection = self.menu.sections[section];
    if (menuSection.isExpanded.boolValue)
    {
        return [[self.menu.sections[section] items] count];
    }
    else
    {
        return 0;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WWMenuSectionHeader* v = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:WW_MENU_SECTION_HEADER_ID];
    [v.expandButton addTarget:self action:@selector(onExpandClicked:) forControlEvents:UIControlEventTouchUpInside];
    v.expandButton.tag = section;
    //v.tintColor = WW_LIGHT_GREY_BACKGROUND_COLOR;
    
    WWMenuSection* menuSection = self.menu.sections[section];
    v.sectionTitle.text = menuSection.title;
    
    if (!menuSection.isExpanded)
    {
        menuSection.isExpanded = @(NO);
    }
    
    return v;
}

- (void) onExpandClicked:(UIButton*)button
{
    int section = button.tag;
    WWMenuSection* menuSection = self.menu.sections[section];
    menuSection.isExpanded = @(!menuSection.isExpanded.boolValue);
    
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (int i = 0; i < menuSection.items.count; i++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    if (menuSection.isExpanded.boolValue)
    {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [UIView animateWithDuration:0.3f animations:^
     {
         if (menuSection.isExpanded.boolValue)
         {
             button.transform = CGAffineTransformMakeRotation(M_PI);
         }
         else
         {
             button.transform = CGAffineTransformIdentity;
         }
     }];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWMenuSection* menuSection = self.menu.sections[indexPath.section];
    WWMenuItem* menuItem = menuSection.items[indexPath.row];
    
    WWMenuItemCell* cell = [tableView dequeueReusableCellWithIdentifier:WW_MENU_ITEM_CELL_ID forIndexPath:indexPath];
    cell.itemTitle.text = menuItem.title;
    cell.itemDescription.text = menuItem.itemDescription;
    cell.itemPrice.text = menuItem.price;
    return cell;
}

@end
