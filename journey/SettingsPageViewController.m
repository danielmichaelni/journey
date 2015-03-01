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
#import <FacebookSDK/FacebookSDK.h>
#import <Foundation/Foundation.h>
#import "SettingsPageViewController.h"

@interface SettingsPageViewController ()
    @property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
    @property (retain, nonatomic) UISearchBar *searchBar;
    @property (retain, nonatomic) NSString *searchText;
@end

@implementation SettingsPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.enableEmails setOnTintColor:[UIColor colorWithRed:25.0/255.0 green:74.0/255.0 blue:99.0/255.0 alpha:1]];
    
    [self.enableTexts setOnTintColor:[UIColor colorWithRed:25.0/255.0 green:74.0/255.0 blue:99.0/255.0 alpha:1]];
    
    
    bool chosenBool = [[[PFUser currentUser] objectForKey: @"enableEmails"] boolValue];
    if(chosenBool == false) {
        [self.enableEmails setOn:NO animated:YES];
    };
    
    chosenBool = [[[PFUser currentUser] objectForKey: @"enableTexts"] boolValue];
    if(chosenBool == false) {
        [self.enableTexts setOn:NO animated:YES];
    };
    
    self.updatePhone.delegate = self;
    self.updateEmail.delegate = self;
    
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];    

    [self _updateProfileData];
}

- (void) viewDidUnload
{
    self.friendPickerController = nil;
    self.searchBar = nil;
    self.friendPickerController.doneButton = nil;
    self.friendPickerController.cancelButton = nil;
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



- (IBAction)changeFriends:(id)sender
{
    // FBSample logic
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends", @"friends_about_me"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self changeFriends:sender];
                                          }
                                      }];
        return;
    }
    
    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=picture,name,username,location,first_name,last_name" parameters:nil HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        //store result into facebookFriendsArray
        NSArray* friends = [result objectForKey:@"data"];
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id", friend.name);
        }
    }];
    
    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    self.friendPickerController.allowsMultipleSelection = TRUE;
    self.friendPickerController.delegate = self;
    
    self.friendPickerController.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:nil];
    
    [self.navigationController pushViewController: self.friendPickerController animated:YES];
}


#pragma Facebook Friends View

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableString *text = [[NSMutableString alloc] init];
    NSMutableArray *contacts =[[NSMutableArray alloc] init];
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
        [contacts addObject:user.objectID];
    }
    
    [[PFUser currentUser] setObject:contacts forKey:@"contactList"];
    [[PFUser currentUser] saveInBackground];
    
    
    // self.selectedFriendsView.text = text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma Search Bar
- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
}


- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    return YES;
}


@end