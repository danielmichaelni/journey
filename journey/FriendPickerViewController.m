//
//  FriendPickerViewController.m
//  journey
//
//  Created by Malika Aubakirova on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface FriendPickerViewController ()

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

@end

@implementation FriendPickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pick Contacts";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIColor *tintColor = [UIColor colorWithRed:15.0/255.0 green:43.0/255.0 blue:64.0/255.0 alpha:1];
    /*
    self.friendPickerButton.layer.borderWidth= 3.0f;
    self.friendPickerButton.layer.borderColor= [[UIColor blackColor] CGColor];
    */
}

- (void) viewDidUnload
{
    self.friendPickerController = nil;
    
    self.selectedFriendsView = nil;
    self.searchBar = nil;
    self.friendPickerController.doneButton = nil;
    self.friendPickerController.cancelButton = nil;
}

- (IBAction)pickFriendsButtonClick:(id)sender {
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
                                              [self pickFriendsButtonClick:sender];
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
    /*
    [self presentViewController:self.friendPickerController animated:YES completion:^(void){
        [self addSearchBarToFriendPickerView];
    }];
    */
}

#pragma Facebook Friends View

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableString *text = [[NSMutableString alloc] init];
    NSMutableArray *contacts =[[NSMutableArray alloc] init];
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
        [contacts addObject:user.objectID];
    }
    if([contacts count] > 0)
    {
        [[PFUser currentUser] setObject:contacts forKey:@"contactList"];
        [[PFUser currentUser] saveInBackground];
    }
    
    
    self.selectedFriendsView.text = text;
    
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
    NSLog(@"searchBarCancelButtonClicked");
    [searchBar resignFirstResponder];
}


- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    /*
    // If there is a search query, filter the friend list based on this.
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            // If friend name matches partially, show the friend
            return YES;
        } else {
            // If no match, do not show the friend
            return NO;
        }
    } else {
        // If there is no search query, show all friends.
        return YES;
    }
    */
    return YES;
}


@end