//
//  NoAnimationSegue.m
//  journey
//
//  Created by Daniel Ni on 5/7/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "NoAnimationSegue.h"

@implementation NoAnimationSegue

-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
