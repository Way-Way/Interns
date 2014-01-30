//
//  WWPhotoDownloader.m
//  WayWay
//
//  Created by Roman Berenstein on 12/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


#import "WWInclude.h"

@implementation WWImageDownloader

+ (void) downloadImage:(NSURL*)url photoId:(NSNumber*)photoId completion:(void (^)(BOOL success, UIImage* image))completion
{
    NSData* existing = [[UUDataCache sharedCache] objectForKey:[url absoluteString]];
    if (existing)
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
       ^{
           UIImage* image = [UIImage imageWithData:existing];
           if (completion)
           {
               dispatch_sync(dispatch_get_main_queue(),
              ^{
                    completion(YES, image);
               });
           }
        });
        
        return;
    }
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    NSOperationQueue* queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            //WWDebugLog(@"IsMainThread: %d", [NSThread isMainThread]);

            UIImage* image = nil;
            BOOL success = NO;
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                if(httpResponse.statusCode == 200)
                {
                    success = YES;
                }
                else
                {
                    success = NO;
                    
                    if (httpResponse.statusCode == 403 && photoId)
                    {
                        // 403 is HTTP Forbidden which in this case means the Photo's
                        // permissions have been revoked. In this case we will mark
                        // it as a bad photo.
                        dispatch_async(dispatch_get_main_queue(),
                       ^{
                               //WWDebugLog(@"badPhoto, IsMainThread: %d", [NSThread isMainThread]);
                               [WWSettings addBadPhoto:photoId];
                        });
                    }
                }
            }

            if (!connectionError && data && success)
            {
                image = [UIImage imageWithData:data];
                [[UUDataCache sharedCache] setObject:data forKey:[url absoluteString]];
            }
            

            if (completion)
            {
                dispatch_async(dispatch_get_main_queue(),
               ^{
                    //WWDebugLog(@"callback, IsMainThread: %d", [NSThread isMainThread]);
                    completion(success, image);
                });
            }
        });
     }];
}

@end

