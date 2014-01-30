//
//  WWAutoCompleteResult.h
//  WayWay
//
//  Created by Roman Berenstein on 28/11/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"


@interface WWAutoCompleteResult : NSObject

//This should be an enum ???
@property (nonatomic, copy) NSString* type;

@property (nonatomic, copy) NSString* identifier;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* extraSpecs;

//If type is place_id
@property (nonatomic,copy) CLLocation* location;

// Used by WWSettings to sort most recent searches
@property (nonatomic, strong) NSDate* timestamp;

+ (instancetype) fromDictionary:(NSDictionary*)dictionary;

- (NSDictionary*) toDictionary;

@end
