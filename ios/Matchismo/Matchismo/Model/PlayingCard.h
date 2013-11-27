//
//  PlayingCard.h
//  Matchismo
//
//  Created by mo_r on 08/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic)NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
