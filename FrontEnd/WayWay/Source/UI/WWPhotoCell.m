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
@property BOOL allowForZoom;

@end

@implementation WWPhotoCell

-(void) awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.instagramUserView  = [[UIView alloc] init];
}

-(void) layoutSubviews
{
    [super layoutSubviews];    
}

- (void) update:(WWPhoto*)photo highlightedHashTag:(NSString*)hashTag
{
    self.photo = photo;
    self.highlightedHashTag = hashTag;
    self.scrollView.contentOffset = CGPointMake(0,0);
    self.imageView.image = [UIImage imageNamed:@"image_placeholder"];
    
    CGRect frame = self.scrollContent.frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
    
    [self updateHashtagLabel];
    
    
    UIImage* thumbImage = nil;
    NSURL* thumbPhotoUrl = [NSURL URLWithString:[self.photo smallImageUrl]];
    if (thumbPhotoUrl)
    {
        NSData* thumbData = [UUDataCache uuDataForURL:thumbPhotoUrl];
        
        if (thumbData)
        {
            thumbImage = [UIImage imageWithData:thumbData];
            if(thumbImage)
            {
                self.imageView.image = thumbImage;
            }

        }
    }
    
    self.lockImage.hidden = YES;
    NSURL* fullPhotoUrl = [NSURL URLWithString:[self.photo fullUrl]];
    
    [WWImageDownloader downloadImage:fullPhotoUrl photoId:self.photo.identifier completion:^(BOOL success, UIImage *image)
     {
         if(![self.photo.fullUrl isEqualToString:[fullPhotoUrl absoluteString]])
             return;
         
         if(success)
         {
             self.imageView.image = image;
         }
         self.lockImage.hidden = success;
         self.allowForZoom = success;
     }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yDelta = - scrollView.contentOffset.y;
    
    
    if(yDelta > 0)
    {
        if(!self.allowForZoom)
        {
            self.scrollView.contentOffset = CGPointMake(0,0);
        }
        
        // you can implement any int/float value in context of what scale you want to zoom in or out
        
        CGFloat scale = 1.0 + yDelta/ self.imageView.frame.size.width;
        CGFloat translation = - yDelta/2.0;
        
        CGAffineTransform zoom = CGAffineTransformMakeScale(scale, scale);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, translation);
    
        self.imageView.transform = CGAffineTransformConcat(translate,zoom);
        
        //Why should we even need this???!
        translate = CGAffineTransformMakeTranslation(0, translation/4.0);
        self.hashtagContainer.transform = translate;
    }
}


- (void) updateHashtagLabel
{
    UIColor* color;
    WWHashtagButton* hashtag;
    double xPosition = 0;
    double yPosition = 16;
    
    double xSpacing = 6;
    double ySpacing = 6;
    
    [[self.hashtagContainer subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSString* s in self.photo.hashTags)
    {
        if([s isEqualToString:self.highlightedHashTag])
        {
            color = WW_ORANGE_FONT_COLOR;
        }
        else
        {
            color = WW_BLACK_FONT_COLOR;
        }
        
        hashtag = [[WWHashtagButton alloc ] initWithFrame:CGRectMake(xPosition, yPosition, 0, 0)];
        [hashtag setHashtag:s withColor:color];
        
        xPosition = xPosition + hashtag.frame.size.width;
        if(xPosition > self.hashtagContainer.frame.size.width)
        {
            xPosition = hashtag.frame.size.width;
            yPosition += hashtag.frame.size.height + ySpacing;
            hashtag.frame = CGRectMake(0.0,
                                       yPosition,
                                       hashtag.frame.size.width,
                                       hashtag.frame.size.height);
        }
        
        [hashtag addTarget:self action:@selector(launchHashtagSearch:) forControlEvents:UIControlEventTouchUpInside];

        [self.hashtagContainer addSubview:hashtag];
        xPosition+= xSpacing;
    }
    
    double yInstagramSpacing = 40;
    double instagramHeight = 30;
    double finalSpacing = 5;
    
    CGRect frame = self.hashtagContainer.frame;
    self.instagramUserView.frame = CGRectMake(0, yPosition + yInstagramSpacing, frame.size.width, instagramHeight);
    [self.hashtagContainer addSubview:self.instagramUserView];
    [self setInstagramContainer];
    
    yPosition += yInstagramSpacing + instagramHeight + finalSpacing;
    self.hashtagContainer.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y,
                                             frame.size.width,
                                             yPosition);
    
    frame = self.scrollContent.frame;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat maxBound = screenBounds.size.height + finalSpacing;
    
    CGFloat contentHeight = MAX(frame.size.width + yPosition + 64,
                                maxBound);
    self.scrollContent.frame = CGRectMake(frame.origin.x,
                                          frame.origin.y,
                                          frame.size.width,
                                          contentHeight);
    self.scrollView.contentSize = CGSizeMake(frame.size.width, contentHeight);
}

-(void) launchHashtagSearch:(id)sender
{
    NSString* hashtag = ((WWHashtagButton*)sender).hashtag;
    if (hashtag)
    {
        WWSearchArgs* args = [WWSettings cachedSearchArgs];
        args.autoCompleteArg = hashtag;
        args.lastAutoCompleteInput = hashtag;
        args.autoCompleteType = @"hashtag";
        
        [args clearFilterArgs];
        
        // We don't save this as they are a 'temporary' search, unless someone says otherwise.
        // The root home controller will always be the NSUserDefaults cached search
        
        [Flurry logEvent:WW_FLURRY_EVENT_TAP_HASH_TAG_BELOW_LARGE_PHOTO];
        [[NSNotificationCenter defaultCenter] postNotificationName:WW_PUSH_NEW_HOME_VIEW_NOTIFICATION object:args];
    }
}

//Set instagram container
-(void) setInstagramContainer
{
    [self.instagramUserView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //Add label
    UILabel* instagramUserLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    
    instagramUserLabel.font = WW_FONT_H6;
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

    //Instagram Logo
    UIImageView * instagramLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram"]];
    CGRect frame = instagramLogo.frame;
    

    
    double xposition = (self.instagramUserView.frame.size.width - (instagramUserLabel.frame.size.width + instagramLogo.frame.size.width))/2.0;
    instagramUserLabel.frame = CGRectMake(xposition, 4, instagramUserLabel.frame.size.width, instagramUserLabel.frame.size.height);
    instagramLogo.frame = CGRectMake(instagramUserLabel.frame.origin.x + instagramUserLabel.frame.size.width ,
                                     instagramUserLabel.frame.origin.y,
                                     frame.size.width,
                                     frame.size.height);
    

    
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
