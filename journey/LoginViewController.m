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
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    [super viewDidLoad];
    
    UIImage *textLogoImage = [UIImage imageNamed:@"textLogo.png"];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    float scale = textLogoImage.size.width / width;
    UIImage *scaledTextLogoImage = [UIImage imageWithCGImage:[textLogoImage CGImage] scale:scale orientation:textLogoImage.imageOrientation];
    self.textLogoImageView = [[UIImageView alloc] initWithImage:scaledTextLogoImage];
    self.textLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.textLogoImageView];
    [self.textLogoImageView.superview sendSubviewToBack:self.textLogoImageView];
    
    
    UIColor *tintColor = [UIColor colorWithRed:25.0/255.0 green:74.0/255.0 blue:99.0/255.0 alpha:1];
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
                [[PFUser currentUser] setValue:[NSNumber numberWithBool:YES] forKey:@"enableEmails"];
                [[PFUser currentUser] setValue:[NSNumber numberWithBool:YES]  forKey:@"enableTexts"];
                [[PFUser currentUser] saveInBackground];
                [self performSegueWithIdentifier:@"loginPhone" sender:self];
            } else {
                // logged in back
                [self performSegueWithIdentifier:@"loggedIn" sender:self];
            }
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
