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
    //self.instagramUserView  = [[UIView alloc] init];
    self.instagramLogo.hidden = YES;
    
    //Add tap gesture
    self.instagramLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onInstagramLogoTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.instagramLogo addGestureRecognizer:tapRecognizer];
}

-(void) layoutSubviews
{
    [super layoutSubviews];    
}

- (void) update:(WWPhoto*)photo highlightedHashTag:(NSString*)hashTag
{
    self.instagramLogo.hidden = YES;
    self.lockImage.hidden = YES;
    
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
                self.instagramLogo.hidden = NO;
                self.imageView.image = thumbImage;
            }

        }
    }
    
    NSURL* fullPhotoUrl = [NSURL URLWithString:[self.photo fullUrl]];
    
    [WWImageDownloader downloadImage:fullPhotoUrl photoId:self.photo.identifier completion:^(BOOL success, UIImage *image)
     {
         if(![self.photo.fullUrl isEqualToString:[fullPhotoUrl absoluteString]])
             return;
         
         if(success)
         {
             self.imageView.image = image;
         }
         
         if(self.instagramLogo.hidden)
             self.instagramLogo.hidden = !success;
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
        CGAffineTransform translateLogo = CGAffineTransformMakeTranslation(0, translation/2.0);
    
        self.imageView.transform = CGAffineTransformConcat(translate,zoom);
        self.instagramLogo.transform = translateLogo;
        
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
            color = WW_LEAD_COLOR;
        }
        else
        {
            color = WW_GRAY_COLOR_11;
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
    
    double yExtraSpacing = 40;
    double finalSpacing = 35;
    

    
    //Time Logo
    UIImageView * timeLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
    timeLogo.frame = CGRectMake(0.0,
                                yPosition + yExtraSpacing,
                                timeLogo.frame.size.width,
                                timeLogo.frame.size.height);
    
    [self.hashtagContainer addSubview:timeLogo];
    
    //Time label
    UILabel* timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; //to comment later for translation
    
    [formatter setDateFormat:@"EEEE"];
    NSString* day = [formatter stringFromDate:self.photo.timestamp];
    
    [formatter setDateFormat:@"MMMM"];
    NSString* month = [formatter stringFromDate:self.photo.timestamp];

    
    //timezone pb...
    NSString* timeOfDay = @"";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit) fromDate:self.photo.timestamp];
    NSInteger hour = [components hour];
    
    if(2<hour && hour<=5)
        timeOfDay = @"late at night";
    else if(5<hour && hour<=8)
        timeOfDay = @"early in the morning";
    else if(8<hour && hour<=11)
        timeOfDay = @"morning";
    else if(11<hour && hour<=14)
        timeOfDay = @"at noon";
    else if(14<hour && hour<=17)
        timeOfDay = @"afternoon";
    else if(17<hour && hour<=21)
        timeOfDay = @"evening";
    else
        timeOfDay = @"night";
        
    
    NSString* text= [NSString stringWithFormat:@"on a %@ %@, in %@", day, timeOfDay, month];
    [timeLabel setText:text];
    timeLabel.font = WW_FONT_H5;
    [timeLabel setTextColor:WW_GRAY_COLOR_4];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(timeLogo.frame.size.width + xSpacing,
                                 yPosition + yExtraSpacing,
                                 timeLabel.frame.size.width,
                                 timeLabel.frame.size.height);
    
    [self.hashtagContainer addSubview:timeLabel];

    
    
    //Set-up the scroll container
    CGRect frame = self.hashtagContainer.frame;
    yPosition += yExtraSpacing + finalSpacing;
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

- (void)onInstagramLogoTapped:(id)sender
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
