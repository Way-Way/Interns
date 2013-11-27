//
//  Deck.h
//  Matchismo
//
//  Created by mo_r on 08/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
