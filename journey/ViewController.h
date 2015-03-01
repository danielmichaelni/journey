//
//  ViewController.h
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet GMSMapView *mapView_;

@property (nonatomic, strong) Journey *journey;

@end