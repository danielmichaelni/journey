/**
 * Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 * copy, modify, and distribute this software in source code or binary form for use
 * in connection with the web services and APIs provided by Parse.

 * As with any software that integrates with the Parse platform, your use of
 * this software is subject to the Parse Terms of Service
 * [https://www.parse.com/about/terms]. This copyright notice shall be
 * included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "UIKit/UIKit.h"

#import "LoginViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "ViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoLabel.font = [UIFont fontWithName:@"Hero-Light" size:30.0];
    UIColor *tintColor = [UIColor colorWithRed:15.0/255.0 green:43.0/255.0 blue:64.0/255.0 alpha:1];
    self.view.backgroundColor = tintColor;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:tintColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
}

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        PFUser *user = [PFUser currentUser];
        user.ACL = [PFACL ACLWithUser:user];
        [PFACL setDefaultACL:user.ACL withAccessForCurrentUser:YES];
        [user saveInBackground];
        [self _presentUserDetailsViewControllerAnimated:NO];
    }
}

#pragma mark -
#pragma mark Login

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email", @"user_friends", @"email"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                // new user
                [self _loadData];
                PFUser *user = [PFUser currentUser];
                user.ACL = [PFACL ACLWithUser:user];
                [user setValue:[NSNumber numberWithBool:YES] forKey:@"enableEmails"];
                [user setValue:[NSNumber numberWithBool:YES]  forKey:@"enableTexts"];
                [user setValue:[NSNumber numberWithBool:NO]  forKey:@"enableCalls"];
                [user saveInBackground];
                [self performSegueWithIdentifier:@"loginPhone" sender:self];
            } else {
                // logged in back loggedIn
                PFUser *user = [PFUser currentUser];
                user.ACL = [PFACL ACLWithUser:user];
                [self performSegueWithIdentifier:@"loggedIn" sender:self];
            }
        }
    }];
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
            PFUser *user = [PFUser currentUser];
            user.ACL = [PFACL ACLWithUser:user];
            [PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
            
            [user setObject:userProfile[@"pictureURL"] forKey:@"pictureURL"];
            [user setObject:userProfile forKey:@"profile"];
            [user saveInBackground];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

#pragma mark -
#pragma mark UserDetailsViewController

- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated
{
    [self performSegueWithIdentifier:@"loggedIn" sender:self];
}

@end
