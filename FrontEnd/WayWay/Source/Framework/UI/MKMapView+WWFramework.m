//
//  MKMapView+WWFramework.m
//  WayWay
//
//  Created by Ryan DeVore on 11/19/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#import "MKMapView+WWFramework.h"

@implementation MKMapView (WWFramework)

- (void) wwHideLegalLabel
{
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:NSClassFromString(@"MKAttributionLabel")])
        {
            v.hidden = YES;
        }
    }
}

@end
