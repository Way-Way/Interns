//
//  WWPhotoCell.m
//  WayWay
//
//  Created by Ryan DeVore on 6/27/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"
#import "WWImageDownloader.h"

@interface WWPhotoCell ()

@property (nonatomic, strong) WWPhoto* photo;
@property (nonatomic, copy) NSString* highlightedHashTag;

@end

@implementation WWPhotoCell

-(void) layoutSubviews
{
    [super layoutSubviews];

    float height = 40.0;
    float ypos;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568)
    {
        //iphone5
        ypos = 476;
    }
    else
    {
        //iphone4
        ypos = 388;
    }

    [self.instagramUserView setFrame:CGRectMake(0.0,
                                              ypos,
                                              screenBounds.size.width,
                                              height)];

}

- (void) update:(WWPhoto*)photo highlightedHashTag:(NSString*)hashTag
{
    self.photo = photo;
    self.highlightedHashTag = hashTag;
    [self updateHashTagLabel];
    [self setInstagramContainer];
    
    UIImage* thumbImage = nil;
    NSURL* thumbPhotoUrl = [NSURL URLWithString:[self.photo smallImageUrl]];
    if (thumbPhotoUrl)
    {
        NSData* thumbData = [UUDataCache uuDataForURL:thumbPhotoUrl];
        
        if (thumbData)
        {
            thumbImage = [UIImage imageWithData:thumbData];
        }
    }
    self.imageView.image = thumbImage;
    
    self.lockImage.hidden = (thumbImage != nil);
    
    NSURL* fullPhotoUrl = [NSURL URLWithString:[self.photo fullUrl]];
    [WWImageDownloader downloadImage:fullPhotoUrl photoId:self.photo.identifier completion:^(BOOL success, UIImage *image)
     {
         if(![self.photo.fullUrl isEqualToString:[fullPhotoUrl absoluteString]])
             return;
         
         self.imageView.image = image;
         
         if (!success)
         {
             self.lockImage.hidden = NO;
         }
     }];
}

- (void) updateHashTagLabel
{
    [self.webView loadHTMLString:[self.photo formattedHashTags:self.highlightedHashTag] baseURL:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* hashTag = [request.URL.absoluteString uuFindQueryStringArg:@"gotohashtag"];
    if (hashTag)
    {
        WWSearchArgs* args = [WWSettings cachedSearchArgs];
        args.autoCompleteArg = hashTag;
        args.lastAutoCompleteInput = hashTag;
        args.autoCompleteType = @"hashtag";
        args.locationName = nil;
        args.trendingOnly = nil;
        args.openRightNow = nil;
        args.priceOne = nil;
        args.priceTwo = nil;
        args.priceThree = nil;
        args.priceFour = nil;

        //[WWSettings saveCachedSearchArgs:args];

        // We don't save this as they are a 'temporary' search, unless someone says otherwise.
        // The root home controller will always be the NSUserDefaults cached search
        
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_HASH_TAG_BELOW_LARGE_PHOTO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WW_PUSH_NEW_HOME_VIEW_NOTIFICATION object:args];
    }
    
    return YES;
}

//Set instagram container
-(void) setInstagramContainer
{
    [self.instagramUserView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    int size = 15;
    int sizex = 70;
    int sizey = 20;
    //Add label
    UILabel* instagramUserLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    
    instagramUserLabel.font =[UIFont fontWithName:WW_DEFAULT_FONT_NAME size:size];
    NSString* text;
    if(self.photo.instagramUserName)
    {
        text = [NSString stringWithFormat:@"%@ on ", self.photo.instagramUserName];
    }
    else
    {
        text = @"Powered by ";
    }
    [instagramUserLabel setText:text];
    [instagramUserLabel setTextColor:WW_LIGHT_GRAY_FONT_COLOR];
    [instagramUserLabel sizeToFit];
    
    double xposition = (self.instagramUserView.frame.size.width - (instagramUserLabel.frame.size.width + sizex))/2.0;
    instagramUserLabel.frame = CGRectMake(xposition, 0, instagramUserLabel.frame.size.width, instagramUserLabel.frame.size.height);

    //Instagram Logo
    UIImageView * instagramLogo =[[UIImageView alloc] initWithFrame:CGRectMake(instagramUserLabel.frame.origin.x
                                                              + instagramUserLabel.frame.size.width ,
                                                              instagramUserLabel.frame.origin.y,
                                                              sizex,
                                                              sizey)];
    instagramLogo.image = [UIImage imageNamed:@"instagram"];
    

    
    [self.instagramUserView addSubview:instagramUserLabel];
    [self.instagramUserView addSubview:instagramLogo];
    
    //Add tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onInstagramContainerTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.instagramUserView addGestureRecognizer:tapRecognizer];
    
    
}

- (void)onInstagramContainerTapped:(id)sender
{
    if (self.photo.instagramUserName)
    {
        NSString *url = [@"instagram://user?username=" stringByAppendingString:self.photo.instagramUserName];
        NSURL *instagramURL = [NSURL URLWithString:url];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
    }
}

@end
