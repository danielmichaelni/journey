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

- (id) initWithDestination:(GMSCameraPosition *)destination andTimer:(NSTimer *)timer {
    self.destination = destination;
    self.timer = timer;
    
    return self;
}

@end
