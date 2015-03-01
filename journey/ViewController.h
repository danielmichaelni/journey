//
//  ViewController.h
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"
#import "wildcard.h"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) Journey *journey;

@end