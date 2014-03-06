//
//  WWIntroViewController.m
//  WayWay
//
//  Created by Ryan DeVore on 12/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

#define WW_DEFAULT_SEARCH_1 @"rooftop";
#define WW_DEFAULT_SEARCH_2 @"burlesque";
#define WW_DEFAULT_SEARCH_3 @"ramenburger";
#define WW_DEFAULT_SEARCH_4 @"cronut";
#define WW_DEFAULT_SEARCH_5 @"dragqueen";


@interface WWIntroViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) WWCity* featuredHashtags;
@property (nonatomic,strong) NSString* hashtag1;
@property (nonatomic,strong) NSString* hashtag2;
@property (nonatomic,strong) NSString* hashtag3;
@property (nonatomic,strong) NSString* hashtag4;
@property (nonatomic,strong) NSString* hashtag5;
@end

@implementation WWIntroViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scrollContent removeFromSuperview];
    [self.scrollView addSubview:self.scrollContent];
    self.scrollView.contentSize = self.scrollContent.bounds.size;
    
    //Format buttons
    UIColor* color = [UIColor blackColor];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(4, 15, 3, 15);
    
    //Labels
    self.analyzesLabel.text = @"WayWay analyzes social media to rank places around you.";
    self.analyzesLabel.backgroundColor = [UIColor clearColor];
    self.analyzesLabel.font = WW_FONT_H1;
    self.analyzesLabel.textColor = color;
    
    self.popularLabel.text = @"Very Popular";
    self.popularLabel.backgroundColor = [UIColor clearColor];
    self.popularLabel.font = WW_FONT_H3;
    self.popularLabel.textColor = color;
    
    self.trendingLabel.text = @"Trending Up";
    self.trendingLabel.backgroundColor = [UIColor clearColor];
    self.trendingLabel.font = WW_FONT_H3;
    self.trendingLabel.textColor = color;
    
    self.underradarLabel.text = @"Under the Radar";
    self.underradarLabel.backgroundColor = [UIColor clearColor];
    self.underradarLabel.font = WW_FONT_H3;
    self.underradarLabel.textColor = color;
    
    self.swipeLabel.text = @"Swipe to continue";
    self.swipeLabel.backgroundColor = [UIColor clearColor];
    self.swipeLabel.font = WW_FONT_H1;
    self.swipeLabel.textColor = color;
    
    self.feelLabel.text = @"Get a feel for places with user-generated hashtags and pictures.";
    self.feelLabel.backgroundColor = [UIColor clearColor];
    self.feelLabel.font = WW_FONT_H1;
    self.feelLabel.textColor = color;
    
    self.picturesLabel.text = @"Pictures are sorted so you can focus on what matters to you.";
    self.picturesLabel.backgroundColor = [UIColor clearColor];
    self.picturesLabel.font = WW_FONT_H1;
    self.picturesLabel.textColor = color;
    
    self.discoverLabel.text = @"Discover unique places by searching hashtags.";
    self.discoverLabel.backgroundColor = [UIColor clearColor];
    self.discoverLabel.font = WW_FONT_H1;
    self.discoverLabel.textColor = color;
    
    self.tapHashtagLabel.text = @"Tap a hashtag to get started.";
    self.tapHashtagLabel.backgroundColor = [UIColor clearColor];
    self.tapHashtagLabel.font = WW_FONT_H1;
    self.tapHashtagLabel.textColor = color;
    
    [self.skipIntroButton setTitle:@"Skip Tutorial" forState:UIControlStateNormal];
    [self.skipIntroButton setTitleColor:WW_LEAD_COLOR forState:UIControlStateNormal];
    self.skipIntroButton.titleLabel.font = WW_FONT_H4;
    self.skipIntroButton.alpha = 0;
    self.skipIntroButton.hidden = YES;
    
    self.exitSearchButtonOne.layer.cornerRadius = 4;
    self.exitSearchButtonTwo.layer.cornerRadius = 4;
    self.exitSearchButtonThree.layer.cornerRadius = 4;
    self.exitSearchButtonFour.layer.cornerRadius = 4;
    self.exitSearchButtonFive.layer.cornerRadius = 4;
    
    self.exitSearchButtonOne.layer.borderWidth = 1;
    self.exitSearchButtonTwo.layer.borderWidth = 1;
    self.exitSearchButtonThree.layer.borderWidth = 1;
    self.exitSearchButtonFour.layer.borderWidth = 1;
    self.exitSearchButtonFive.layer.borderWidth = 1;
    
    self.exitSearchButtonOne.layer.borderColor = WW_LEAD_COLOR.CGColor;
    self.exitSearchButtonTwo.layer.borderColor = WW_LEAD_COLOR.CGColor;
    self.exitSearchButtonThree.layer.borderColor = WW_LEAD_COLOR.CGColor;
    self.exitSearchButtonFour.layer.borderColor = WW_LEAD_COLOR.CGColor;
    self.exitSearchButtonFive.layer.borderColor = WW_LEAD_COLOR.CGColor;
    
    self.exitSearchButtonOne.titleLabel.font = WW_FONT_H1;
    self.exitSearchButtonTwo.titleLabel.font = WW_FONT_H1;
    self.exitSearchButtonThree.titleLabel.font = WW_FONT_H1;
    self.exitSearchButtonFour.titleLabel.font = WW_FONT_H1;
    self.exitSearchButtonFive.titleLabel.font = WW_FONT_H1;
    
    [self.exitSearchButtonOne setTitleColor:color forState:UIControlStateNormal];
    [self.exitSearchButtonTwo setTitleColor:color forState:UIControlStateNormal];
    [self.exitSearchButtonThree setTitleColor:color forState:UIControlStateNormal];
    [self.exitSearchButtonFour setTitleColor:color forState:UIControlStateNormal];
    [self.exitSearchButtonFive setTitleColor:color forState:UIControlStateNormal];
    
    self.exitSearchButtonOne.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonTwo.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonThree.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonFour.backgroundColor = [UIColor clearColor];
    self.exitSearchButtonFive.backgroundColor = [UIColor clearColor];
   
    [self.exitSearchButtonOne setTitleEdgeInsets:edgeInsets];
    [self.exitSearchButtonTwo setTitleEdgeInsets:edgeInsets];
    [self.exitSearchButtonThree setTitleEdgeInsets:edgeInsets];
    [self.exitSearchButtonFour setTitleEdgeInsets:edgeInsets];
    [self.exitSearchButtonFive setTitleEdgeInsets:edgeInsets];
    
    //Write default values
    self.hashtag1 = WW_DEFAULT_SEARCH_1;
    self.hashtag2 = WW_DEFAULT_SEARCH_2;
    self.hashtag3 = WW_DEFAULT_SEARCH_3;
    self.hashtag4 = WW_DEFAULT_SEARCH_4;
    self.hashtag5 = WW_DEFAULT_SEARCH_5;
    
    self.featuredHashtags = nil;
    [self loadHashtags];
    [self refreshHashtags];
    [self refreshDotsView];
}

- (void) loadHashtags
{
    if(self.featuredHashtags)
        return;
    
    CLLocation* location = [[UULocationManager sharedInstance] currentLocation];
    
    // For test
    //location = [[CLLocation alloc] initWithLatitude:45 longitude:2];
    if(location)
    {
        [[WWServer sharedInstance] featuredHashtagsWithLocation:location
                                                     completion:^(NSError* error, NSArray* results)
         {
             self.featuredHashtags = results[0];
             
             if((self.featuredHashtags!=nil) && (self.featuredHashtags.featured.count == 5))
             {
                 self.hashtag1 = self.featuredHashtags.featured[0];
                 self.hashtag2 = self.featuredHashtags.featured[1];
                 self.hashtag3 = self.featuredHashtags.featured[2];
                 self.hashtag4 = self.featuredHashtags.featured[3];
                 self.hashtag5 = self.featuredHashtags.featured[4];
             }
             
             [self refreshHashtags];
         }];
    }

}

-(void) refreshHashtags
{
    [self.exitSearchButtonOne setTitle:[NSString stringWithFormat:@"#%@", self.hashtag1] forState:UIControlStateNormal];
    [self.exitSearchButtonOne setNeedsDisplay];
    
    [self.exitSearchButtonTwo setTitle:[NSString stringWithFormat:@"#%@", self.hashtag2] forState:UIControlStateNormal];
    [self.exitSearchButtonTwo setNeedsDisplay];
    
    [self.exitSearchButtonThree setTitle:[NSString stringWithFormat:@"#%@", self.hashtag3] forState:UIControlStateNormal];
    [self.exitSearchButtonThree setNeedsDisplay];
    
    [self.exitSearchButtonFour setTitle:[NSString stringWithFormat:@"#%@", self.hashtag4] forState:UIControlStateNormal];
    [self.exitSearchButtonFour setNeedsDisplay];
    
    [self.exitSearchButtonFive setTitle:[NSString stringWithFormat:@"#%@", self.hashtag5] forState:UIControlStateNormal];
    [self.exitSearchButtonFive setNeedsDisplay];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadHashtags];
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
    [self launchHashtagSearch:self.hashtag1];
}

- (IBAction)onExitSearchButtonTwo:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashtagSearch:self.hashtag2];
}

- (IBAction)onExitSearchButtonThree:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashtagSearch:self.hashtag3];
}

- (IBAction)onExitSearchButtonFour:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashtagSearch:self.hashtag4];
}

- (IBAction)onExitSearchButtonFive:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_TAP_ON_INTRO_HASHTAG];
    [self launchHashtagSearch:self.hashtag5];
}

- (IBAction)onExitIntro:(id)sender
{
    [Flurry logEvent:WW_FLURRY_EVENT_SKIP_TUTORIAL];
    [self dismissView:NO];
}

- (void) launchHashtagSearch:(NSString*)hashtag
{
    WWSearchArgs* args = [WWSettings cachedSearchArgs];
    args.autoCompleteType = @"hashtag";
    args.autoCompleteArg = hashtag;
    args.lastAutoCompleteInput = hashtag;
    
    // Clear Filters
    [args clearFilterArgs];
    
    if(self.featuredHashtags)
    {
        args.maxlatitude = self.featuredHashtags.maxlatitude;
        args.minlatitude = self.featuredHashtags.minlatitude;
        args.maxlongitude = self.featuredHashtags.maxlongitude;
        args.minlongitude = self.featuredHashtags.minlongitude;
    }
    else
    {
        CLLocationCoordinate2D loc = [args coordinateRegion].center;
    
        CGFloat span = 1609.34 * 5; // 5 miles
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, span, span);
        [args setGeoboxFromMapRegion:region];
    }
    
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
