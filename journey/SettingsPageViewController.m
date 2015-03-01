//
//  SettingsPageViewController.m
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Foundation/Foundation.h>
#import "SettingsPageViewController.h"

@interface SettingsPageViewController ()
{
    
}
@end

@implementation SettingsPageViewController





// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.profilePhoto.image = [UIImage imageWithData:data];
                                       
                                       // Add a nice corner radius to the image
                                       self.profilePhoto.layer.cornerRadius = 8.0f;
                                       self.profilePhoto.layer.masksToBounds = YES;
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}


- (IBAction)saveChanges:(id)sender {
}
@end