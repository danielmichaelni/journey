//
//  Journey.h
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Journey : NSObject

@property (nonatomic) CLLocationCoordinate2D source;
@property (nonatomic) CLLocationCoordinate2D destination;
@property (strong, nonatomic) NSString *sourceString;
@property (strong, nonatomic) NSString *destinationString;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) int minutesCount;

- (id) initWithSource:(CLLocationCoordinate2D)source andDestination:(CLLocationCoordinate2D) destination;

@end
