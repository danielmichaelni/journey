//
//  ViewController.m
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController {
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView_;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.rotateGestures = NO;

    
    GMSCameraPosition *new_camera = [GMSCameraPosition cameraWithTarget:mapView_.myLocation.coordinate zoom:6];
    NSLog(@"User's location: %@", mapView_.myLocation);
    
    mapView_.myLocationEnabled = YES;
    
    mapView_.camera = new_camera;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = mapView_.myLocation.coordinate;//CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.title = @"Champaign";
    marker.snippet = @"United States";
    marker.map = mapView_;
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
