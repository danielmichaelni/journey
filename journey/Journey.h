//
//  Journey.h
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Journey : NSObject

@property (strong, nonatomic) GMSCameraPosition *destination;
@property (nonatomic) int minutesCount;

- (id) initWithDestination:(GMSCameraPosition *)destination;

@end
