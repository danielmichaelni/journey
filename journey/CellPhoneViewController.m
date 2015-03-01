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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    self.cellPhoneTextField.delegate = self;
}

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
    [self.cellPhoneTextField resignFirstResponder];
}

@end