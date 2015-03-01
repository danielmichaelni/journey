//
//  Journey.m
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"

@implementation Journey

- (id) initWithSource:(CLLocationCoordinate2D)source andDestination:(CLLocationCoordinate2D) destination {
    self.source = source;
    self.destination = destination;
    
    return self;
}

@end
