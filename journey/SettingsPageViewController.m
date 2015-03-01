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


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.enableEmails.on = [PFUser currentUser][@"enableEmails"];
    NSLog(@"enable emails: %@", [PFUser currentUser][@"enableEmails"]);
    self.enableTexts.on = [PFUser currentUser][@"enableTexts"];
    self.updatePhone.delegate = self;
    self.updateEmail.delegate = self;
    
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];    
    
    [self _updateProfileData];
}


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


- (IBAction)saveChanges:(id)sender
{
    
    bool cont = true;
    BOOL chosen = FALSE;
    chosen =self.enableEmails.on;
    [[PFUser currentUser] setValue:[NSNumber numberWithBool:chosen]  forKey:@"enableEmails"];
    chosen = self.enableTexts.on;
    [[PFUser currentUser] setValue:[NSNumber numberWithBool:chosen]  forKey:@"enableTexts"];
    
    NSString *currentPhone = [PFUser currentUser][@"cellPhone"];
    NSString *upPhone = self.updatePhone.text;
    if(upPhone != currentPhone && upPhone.length == 10) {
        [[PFUser currentUser] setValue:upPhone  forKey:@"cellPhone"];
    } else {
        if(upPhone.length != 0 && upPhone.length != 10)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone"
                                                            message:@"Wrong phone input. Please try the format 3332225143"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
            cont = false;
        }
    }
    NSString *currentEmail = [PFUser currentUser][@"email"];
    NSString *upEmail = self.updateEmail.text;

    if(upEmail != currentEmail && upEmail.length > 5) {
        [[PFUser currentUser] setValue:upEmail  forKey:@"email"];
    } else {
         if(upEmail.length != 0 && upEmail.length < 5 && cont == true)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                             message:@"Wrong email input"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Dismiss", nil];
             [alert show];
             cont = false;
         }
    }
    
    
    if(cont == true)
    {
        [[PFUser currentUser] saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.updateEmail resignFirstResponder];
    [self.updatePhone resignFirstResponder];
}


@end