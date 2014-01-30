//
//  WWIntroViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 12/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWIntroViewController () <UIScrollViewDelegate>

@end

@implementation WWIntroViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scrollContent removeFromSuperview];
    [self.scrollView addSubview:self.scrollContent];
    self.scrollView.contentSize = self.scrollContent.bounds.size;
    
    [self.skipIntroButton setTitle:@"Skip Tutorial" forState:UIControlStateNormal];
    [self.skipIntroButton setTitleColor:WW_ORANGE_FONT_COLOR forState:UIControlStateNormal];
    self.skipIntroButton.titleLabel.font = [UIFont fontWithName:WW_DEFAULT_FONT_NAME size:16];
    self.skipIntroButton.alpha = 0;
    self.skipIntroButton.hidden = YES;
    
    self.exitSearchButtonOne.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonTwo.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonThree.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonFour.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonFive.backgroundColor = [UIColor clearColor];
    
    [self refreshDotsView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshDotsView];
}

-(NSArray*)introImages
{
    return @[ @"slider_1_4", @"slider_2_4", @"slider_3_4", @"slider_4_4" ];
}

-(void) resetIntro
{
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    [self refreshDotsView];
}

- (void) refreshDotsView
{
    int page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;

    NSArray* images = [self introImages];
    UIImage* img = nil;
    
    if(page > 0)
    {
        self.skipIntroButton.hidden = NO;
        [UIView animateWithDuration:0.375f animations:^
         {
             self.skipIntroButton.alpha = 1.0;
             
         } completion:^(BOOL finished)
         {
             
         }];
    }
    
    if (page >= 0 && page < images.count)
    {
        img = [UIImage imageNamed:images[page]];
    }
    
    self.dotsView.image = img;
}

- (IBAction)onExitSearchButtonOne:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashTagSearch:@"rooftop"];
}

- (IBAction)onExitSearchButtonTwo:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashTagSearch:@"burlesque"];
}

- (IBAction)onExitSearchButtonThree:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashTagSearch:@"ramenburger"];
}

- (IBAction)onExitSearchButtonFour:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashTagSearch:@"cronut"];
}

- (IBAction)onExitSearchButtonFive:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashTagSearch:@"dragqueen"];
}

- (IBAction)onExitIntro:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_SKIP_TUTORIAL];
    [self dismissView:NO];
}

- (void) launchHashTagSearch:(NSString*)hashTag
{
    WWSearchArgs* args = [WWSettings cachedSearchArgs];
    args.autoCompleteType = @"hashtag";
    args.autoCompleteArg = hashTag;
    args.lastAutoCompleteInput = hashTag;
    
    // Clear Filters
    args.locationName = nil;
    args.trendingOnly = nil;
    args.openRightNow = nil;
    args.priceOne = nil;
    args.priceTwo = nil;
    args.priceThree = nil;
    args.priceFour = nil;
    
    CLLocationCoordinate2D loc = [args coordinateRegion].center;
    
    CGFloat span = 1609.34 * 5; // 5 miles
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, span, span);
    [args setGeoboxFromMapRegion:region];
    
    [WWSettings saveCachedSearchArgs:args];
    [self dismissView:NO];
}

- (void) dismissView:(BOOL)cancelled
{
    if (self.dismissCallback)
    {
        self.dismissCallback(cancelled);
    }
    
    [UIView animateWithDuration:0.5f animations:^
     {
         self.view.alpha = 0;
         
     } completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
     }];
}

@end
