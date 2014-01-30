//
//  WWPlacePhotoGridCell.m
//  WayWay
//
//  Created by Ryan DeVore on 6/25/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"
#import "WWImageDownloader.h"
#import "UUHttpClient.h"

@interface WWPlacePhotoGridCell ()

@property (nonatomic, strong) WWPhoto* photoInfo;
@property (nonatomic, strong) CALayer* rightBorder;
@property (nonatomic, strong) CALayer* bottomBorder;

@end

@implementation WWPlacePhotoGridCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 1.0f;
    self.rightBorder = layer;
    [self.layer addSublayer:layer];
    layer.hidden = YES;
    
    layer = [CALayer layer];
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 1.0f;
    self.bottomBorder = layer;
    [self.layer addSublayer:layer];
    layer.hidden = YES;
}

- (void) update:(WWPhoto*)photo
{
    [self update:photo drawRightBorder:NO drawBottomBorder:NO];
}

- (void) update:(WWPhoto*)photo drawRightBorder:(BOOL)drawRightBorder
{
    [self update:photo drawRightBorder:drawRightBorder drawBottomBorder:NO];
}

- (void) update:(WWPhoto*)photo drawRightBorder:(BOOL)drawRightBorder drawBottomBorder:(BOOL)drawBottomBorder
{
    self.photoInfo = photo;

    NSURL* photoUrl = [NSURL URLWithString:[self.photoInfo thumbUrl]];
    
    self.photo.image = nil;
        
    BOOL alreadyExists = [UUDataCache uuDoesCachedDataExistForURL:photoUrl];
    if (!alreadyExists)
    {
        self.photo.alpha = 0;
    }
    else
    {
        self.photo.alpha = 1;
    }
    
    self.lockImage.hidden = YES;
    
    [WWImageDownloader downloadImage:photoUrl photoId:self.photoInfo.identifier completion:^(BOOL success, UIImage *image)
    {
        if(![[self.photoInfo thumbUrl] isEqualToString:[photoUrl absoluteString]])
            return;
        
        self.photo.image = image;
        
        if (!alreadyExists)
        {
            [UIView animateWithDuration:0.15f animations:^
            {
                self.photo.alpha = 1;
            }];
        }
        
        if (!success)
        {
            self.lockImage.hidden = NO;
        }
    }];
    
    self.rightBorder.hidden = !drawRightBorder;
    self.bottomBorder.hidden = !drawBottomBorder;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // Adjust the frame of the photo so that it is not covered by the borders.
    CGRect f = self.bounds;
    
    if (!self.rightBorder.hidden)
    {
        --f.size.width;
    }
    
    if (!self.bottomBorder.hidden)
    {
        --f.size.height;
    }
    
    self.photo.frame = f;
    self.placeholderPhoto.frame = f;
    
    self.rightBorder.frame = CGRectMake(self.bounds.size.width - self.rightBorder.borderWidth, 0, self.rightBorder.borderWidth, self.bounds.size.height);
    self.bottomBorder.frame = CGRectMake(0, self.bounds.size.height - self.bottomBorder.borderWidth, self.bounds.size.width, self.bottomBorder.borderWidth);
}

- (void) clearUi:(BOOL)drawRightBorder
{
    [self clearUi:drawRightBorder drawBottomBorder:NO];
}

- (void) clearUi:(BOOL)drawRightBorder drawBottomBorder:(BOOL)drawBottomBorder
{
    self.photo.image = nil;
    self.lockImage.hidden = YES;
    self.rightBorder.hidden = !drawRightBorder;
    self.bottomBorder.hidden = !drawBottomBorder;
}

@end
