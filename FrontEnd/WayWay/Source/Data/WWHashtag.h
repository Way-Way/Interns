//
//  WWHashtag.h
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHashtag : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSNumber* count;

@property (nonatomic, strong) NSArray* photos;

@end
