//
//  ViewController.m
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "ViewController.h"

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
    [self findFriendAndCellPhone];
}

- (void)findFriendAndCellPhone
{
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    contacts = [[PFUser currentUser] objectForKey:@"contactList"];
    if([contacts count] > 0)
    {
        PFQuery *query = [PFUser query];
        [query whereKey:@"facebookId" containedIn:contacts];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count!=0) {
                    for (PFObject *object in objects) {
                        //NSLog(@"%@", object.objectId);
                        NSLog(@"%@", object[@"cellPhone"]);
                    }
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
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
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self _updateProfileData];
    }
    
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
            
            [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            [self logoutButtonAction:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}


// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    
    // Set the name in the header view label
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.headerNameLabel.text = name;
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.headerImageView.image = [UIImage imageWithData:data];
                                       
                                       // Add a nice corner radius to the image
                                       self.headerImageView.layer.cornerRadius = 8.0f;
                                       self.headerImageView.layer.masksToBounds = YES;
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}

@end
