//
//  ViewController.m
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Communication.h"


@interface ViewController ()

@end

@implementation ViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instructionLabel.font = [UIFont fontWithName:@"Hero-Light" size:20.0];
    
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(logoutButtonAction:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // Map Set-up!
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = YES;
    usleep(50000);
    self.journey.locationManager = self.locationManager;
    
    // Set Map to current location.
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 600, 600);
    self.mapView.region = region;
    
    
    
//    self.hawaiiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkLocation) userInfo:nil repeats:YES];
    
    
    
    
    // All of this deals in intercepting taps and their consequences.
    
    WildcardGestureRecognizer *tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        NSArray *array = [touches allObjects];
        if (array.count == 1) {
            UITouch *touch = array.lastObject;
            if (touch.tapCount == 2) {
                // NSLog(@"DOUBLE");
                CLLocationCoordinate2D srcCoord = self.locationManager.location.coordinate;
                
                CLLocationCoordinate2D dstCoord = [self.mapView convertPoint:[touch locationInView:self.mapView] toCoordinateFromView:self.view];
                self.journey = [[Journey alloc] initWithSource:srcCoord andDestination:dstCoord];
                
                
                // Convert Coordinate to Address
                
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                CLGeocoder *geocoder2 = [[CLGeocoder alloc] init];
                
                
                // Initialize Locations
                
                CLLocation *dstLoc = [[CLLocation alloc] initWithCoordinate:dstCoord altitude:0 horizontalAccuracy:0 verticalAccuracy:100 course:0 speed:0 timestamp:0];//self.locationManager.location; //
                
                CLLocation *srcLoc = [[CLLocation alloc] initWithCoordinate:srcCoord altitude:0 horizontalAccuracy:0 verticalAccuracy:100 course:0 speed:0 timestamp:0];
                
                
                
                // Directions
                
                
                MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                [request setSource:[MKMapItem mapItemForCurrentLocation]];
                

                // Print Locations
                

                
                [geocoder reverseGeocodeLocation:dstLoc completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (placemarks && placemarks.count > 0) {
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", [placemark subThoroughfare] ? [placemark subThoroughfare] : @"" , [placemark thoroughfare] ? [placemark thoroughfare] : @"", [placemark locality] ? [placemark locality] : @"", [placemark administrativeArea] ? [placemark administrativeArea] : @"the location"];
                        NSLog(@"Destination: %@",address);
                        self.journey.destinationString = address;
                        
                        
                        // Direction Part
                        
                        // This could be a serious problem.
                        [request setDestination:[[MKMapItem alloc] initWithPlacemark: placemark]];
                    }
                }];
                
                [geocoder2 reverseGeocodeLocation:srcLoc completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (placemarks && placemarks.count > 0) {
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", [placemark subThoroughfare] ? [placemark subThoroughfare] : @"" , [placemark thoroughfare] ? [placemark thoroughfare] : @"", [placemark locality] ? [placemark locality] : @"", [placemark administrativeArea] ? [placemark administrativeArea] : @"the location"];
                        NSLog(@"Location: %@", address);//[address isEqualToString:@"  Urbana IL"] ? @"1251–1487 W Springfield Ave Urbana IL" : address );
                        self.journey.sourceString = address;
                        
                    }
                }];
                
                
                // Get and Set Directions
                
                [request setTransportType:MKDirectionsTransportTypeWalking];
                [request setRequestsAlternateRoutes:NO];
                
                MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
                
                [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                    if ( !error && [response routes] > 0) {
                        MKRoute *route = [[response routes] objectAtIndex:0];
                        
                        NSLog(@"Distance: %f; Time: %f", route.distance, route.expectedTravelTime);
                        
                    } else {
                        NSLog(@"Problem with Directions.");
                    }
                }];
                
                
                // Perform Segue
                [self performSegueWithIdentifier:@"toTimerViewControllerSegue" sender:self];
            }
        }
    };
    [self.mapView addGestureRecognizer:tapInterceptor];
    
    
    UIColor *tintColor = [UIColor colorWithRed:15.0/255.0 green:43.0/255.0 blue:64.0/255.0 alpha:1];
    self.view.backgroundColor = tintColor;
    
}


- (void)checkLocation {
    if (!self.locationManager.location.coordinate.latitude) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 600, 600);
        self.mapView.region = region;
        
//        [self.hawaiiTimer invalidate];
//        self.hawaiiTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutButtonAction:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)_loadData {
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:40];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
                [[PFUser currentUser] setObject:facebookID forKey:@"facebookId"];
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
                [[PFUser currentUser] setObject:name forKey:@"name"];
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                userProfile[@"location"] = location;
                [[PFUser currentUser] setObject:location forKey:@"location"];
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                userProfile[@"gender"] = gender;
                [[PFUser currentUser] setObject:gender forKey:@"gender"];
            }
            
            NSString *birthday = userData[@"birthday"];
            if (birthday) {
                userProfile[@"birthday"] = birthday;
            }
            
            NSString *relationshipStatus = userData[@"relationship_status"];
            if (relationshipStatus) {
                userProfile[@"relationship"] = relationshipStatus;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            
            NSString *email = userData[@"email"];
            if (email) {
                userProfile[@"email"] = email;
                [[PFUser currentUser] setObject:email forKey:@"email"];
            }
            
            [[PFUser currentUser] setObject:userProfile[@"pictureURL"] forKey:@"pictureURL"];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];

        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            [self logoutButtonAction:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toTimerViewControllerSegue"]) {
        TimerViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.journey = self.journey;
    }
}

@end
