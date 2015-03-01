//
//  CellPhoneViewController.m
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellPhoneViewController.h"

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CellPhoneViewController.h"

@interface CellPhoneViewController ()

@end

@implementation CellPhoneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.cellPhone.text = @"3122135143";
}

-(void)saveCellPhone
{
    NSString *cellPhone = self.cellPhone.text;
    [[PFUser currentUser] setObject:cellPhone forKey:@"cellPhone"];
    [[PFUser currentUser] saveInBackground];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotCellPhone"])
    {
        [self saveCellPhone];
    }
}

@end