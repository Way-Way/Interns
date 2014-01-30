//
//  WWPagedSearchResults.h
//  WayWay
//
//  Created by Ryan DeVore on 8/1/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPagedSearchResults : NSObject

@property (nonatomic, retain) NSString* firstPageUrl;
@property (nonatomic, retain) NSString* lastPageUrl;
@property (nonatomic, retain) NSString* nextPageUrl;
@property (nonatomic, retain) NSString* prevPageUrl;
@property (nonatomic, retain) NSArray* data;

@end
