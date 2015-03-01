//
//  FriendPickerViewController.h
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#ifndef journey_FriendPickerViewController_h
#define journey_FriendPickerViewController_h

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface FriendPickerViewController : UIViewController <FBFriendPickerDelegate, UISearchBarDelegate>

- (IBAction)pickFriendsButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *friendPickerButton;

@end

#endif
