//
//  Communication.m
//  journey
//
//  Created by  Apple on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Communication.h"

@implementation Communication

+ (void)contactFriends:(Journey *)journey
{
    PFObject *current = [PFUser currentUser];
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    contacts = [current objectForKey:@"contactList"];
    BOOL emailsEnabled = current[@"enableEmails"];
    BOOL textEnabled = current[@"enableTexts"];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"facebookId" containedIn:contacts];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count!=0) {
                for (PFObject *contact in objects) {
                    NSString *name = contact[@"name"];
                    NSString *phone = contact[@"cellPhone"];
                    NSString *email = contact[@"email"];
                    NSLog(@"%@ %@ %@", name, phone, email);
                    if (textEnabled) {
                        [Communication SendSMS:contact from:current on:journey];
                    }
                    if (emailsEnabled) {
                        [Communication SendEmail:contact from:current on:journey];
                    }
                }
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

+ (void)SendSMS:(PFObject *)contact from:(PFObject *)current on:(Journey *)journey {
    if (contact[@"cellPhone"] && current[@"name"] && contact[@"name"]){
        NSString *gender = current[@"gender"] ? current[@"gender"] : @"";
        [PFCloud callFunctionInBackground:@"SMS"
                           withParameters:@{
                                            @"phonenum": contact[@"cellPhone"],
                                            @"username": current[@"name"],
                                            @"friendname": contact[@"name"],
                                            @"gender":gender,
                                            @"destination": journey.destinationString,
                                            @"source": journey.sourceString,
                                            @"time": [NSNumber numberWithInt:journey.minutesCount],
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"ERROR: %@",error);
                                        } else {
                                            NSLog(@"%@ [%@]", result, contact[@"cellPhone"]);
                                        }
                                    }];
    } else {
        NSLog(@"ERROR: User missing parameters");
    }

}
+ (void)SendEmail:(PFObject *)contact from:(PFObject *) current on:(Journey *)journey {
    if (contact[@"email"] && current[@"name"] && contact[@"name"]){
        NSString *gender = current[@"gender"] ? current[@"gender"] : @"";
        [PFCloud callFunctionInBackground:@"Email"
                           withParameters:@{
                                            @"email": contact[@"email"],
                                            @"username": current[@"name"],
                                            @"friendname": contact[@"name"],
                                            @"gender":gender,
                                            @"destination": journey.destinationString,
                                            @"source": journey.sourceString,
                                            @"time": [NSNumber numberWithInt:journey.minutesCount],
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"ERROR: %@",error);
                                        } else {
                                            NSLog(@"%@ [%@]", result, contact[@"email"]);
                                        }
                                    }];
    } else {
        NSLog(@"ERROR: User missing parameters");
    }
}


@end

