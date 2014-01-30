//
//  WWPhotoDownloader.h
//  WayWay
//
//  Created by Roman Berenstein on 12/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWImageDownloader : NSObject

+ (void) downloadImage:(NSURL*)url photoId:(NSNumber*)photoId completion:(void (^)(BOOL success, UIImage* image))completion;

@end
