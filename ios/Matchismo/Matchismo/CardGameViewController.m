//
//  CardGameViewController.m
//  Matchismo
//
//  Created by mo_r on 08/11/13.
//  Copyright (c) 2013 mo_r. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
//private properties here

//text filed is static, it can't send IBAction like a button
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *deck;
@end


@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount; //_flipCount is an instance variable of flipCount property
                            // it only appears in getter and setter
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips : %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender { // IBAction is a Typedef void
    sender.selected = !sender.isSelected;
    self.flipCount++; //calls setFlipCount method
}


- (IBAction)shareFb {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageNamed:@"steveJobs.jpg"]];
        NSString *comment = [[NSString alloc] initWithFormat:@"flipCount = %d" , self.flipCount];
        [slComposeViewController setInitialText:comment];
        [slComposeViewController addURL:[NSURL URLWithString:@"http://www.google.com"]];
        [self presentViewController:slComposeViewController animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook account" message:@"There are no facebook accounts configured." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

@end
