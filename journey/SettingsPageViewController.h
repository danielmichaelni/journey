//
//  SettingsPageViewController.h
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#ifndef journey_SettingsPageViewController_h
#define journey_SettingsPageViewController_h
#import <UIKit/UIKit.h>

@interface SettingsPageViewController :UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveChanges;
@property (strong, nonatomic) IBOutlet UITextField *updatePhone;
@property (strong, nonatomic) IBOutlet UITextField *updateEmail;
@property (strong, nonatomic) IBOutlet UIButton *changeFriendsList;
@property (strong, nonatomic) IBOutlet UISwitch *enableEmails;
@property (strong, nonatomic) IBOutlet UISwitch *enableTexts;
- (IBAction)saveChanges:(id)sender;
- (IBAction)changeFriends:(id)sender;

@end

#endif
