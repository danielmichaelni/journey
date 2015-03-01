//
//  ViewController.m
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"
#import "Communication.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

@end

@implementation ViewController {
    GMSMapView *mapView_;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(logoutButtonAction:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // Map Set-up!

    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    NSLog(@"User's location: %@", mapView_.myLocation);
    
    self.view.autoresizesSubviews = YES;
    
    [self _loadData];
    if (NO){
        [self contactFriends];
    }

}

- (void)contactFriends
{

    PFObject *current = [PFUser currentUser];
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    contacts = [current objectForKey:@"contactList"];
    BOOL emailsEnabled = current[@"enableEmails"];
    BOOL textEnabled = current[@"enableTexts"];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"facebookId" containedIn:contacts];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count!=0) {
                for (PFObject *contact in objects) {
                    NSLog(@"%@", contact[@"name"]);
                    if (textEnabled) {
                        NSLog(@"HERE",nil);
                        [Communication SendSMS:contact from:current];
                    }
                    if (emailsEnabled) {
                        NSLog(@"THERE",nil);
                        [Communication SendEmail:contact from:current];
                    }
                }
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
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
    if([segue.identifier isEqualToString:@"selectDestinationSegue"]) {
        TimerViewController *destinationViewController = segue.destinationViewController;
        self.journey = [[Journey alloc] init];
        destinationViewController.journey = self.journey;
    }
}

@end
