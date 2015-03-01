//
//  CellPhoneViewController.m
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellPhoneViewController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@implementation CellPhoneViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"loginPhone"]) {
        NSString *currentPhone = [PFUser currentUser][@"cellPhone"];
        NSString *upPhone = self.cellPhoneTextField.text;
        if(upPhone != currentPhone && upPhone.length == 10) {
            [[PFUser currentUser] setValue:upPhone  forKey:@"cellPhone"];
        } else {
            if(upPhone.length != 10)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone"
                                                                message:@"Wrong phone input. Please try the format 3332225143"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Dismiss", nil];
                [alert show];
                return FALSE;
            }
        }
    }
    
    return TRUE;
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"loginPhone"]) {
        NSString *currentPhone = [PFUser currentUser][@"cellPhone"];
        NSString *upPhone = self.cellPhoneTextField.text;
        if(upPhone != currentPhone && upPhone.length == 10) {
            [[PFUser currentUser] setValue:upPhone  forKey:@"cellPhone"];
        } else {
            if(upPhone.length != 10)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone"
                                                                message:@"Wrong phone input. Please try the format 3332225143"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Dismiss", nil];
                [alert show];
                return;
            }
        }
    }
}
*/
@end