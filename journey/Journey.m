//
//  Journey.m
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"

@implementation Journey

- (id) initWithDestination:(GMSCameraPosition *)destination {
    self.destination = destination;
    
    return self;
}

@end
