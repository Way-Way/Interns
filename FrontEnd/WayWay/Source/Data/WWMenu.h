//
//  WWMenu.h
//  WayWay
//
//  Created by Ryan DeVore on 8/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface NSObject (JsonParsing)

- (instancetype) initFromDictionary:(NSDictionary*)dictionary;
+ (instancetype) fromDictionary:(NSDictionary*)dictionary;
+ (NSArray*) fromArray:(NSArray*)array;

@end

@interface WWMenu : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray* sections; // WWMenuSection

@end

@interface WWMenuSection : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray* items; // WWMenuItem

// For TableView use
@property (nonatomic, strong) NSNumber* isExpanded;

@end

@interface WWMenuItem : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* itemDescription;

@end