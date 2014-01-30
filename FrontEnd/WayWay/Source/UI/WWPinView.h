//
//  WWPinView.h
//  WayWay
//
//  Created by Ryan DeVore on 7/5/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "WWInclude.h"

@interface WWPinView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *trendingRankLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (strong, nonatomic) IBOutlet UIView *centerReferenceView;

- (void) update:(WWPlace*)place;
- (void) updateSelected:(BOOL)selected;


@end

@interface WWPinAnnotationView : MKAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end