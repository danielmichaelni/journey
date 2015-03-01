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

+ (void)SendSMS:(PFObject *)contact from:(PFObject *)current {
    
    NSString *name = contact[@"name"];
    NSString *phone = contact[@"cellPhone"];
    NSString *email = contact[@"email"];
    NSLog(@"%@ %@ %@", name, phone, email);
    if (contact[@"cellPhone"] && current[@"name"] && contact[@"name"]){
        [PFCloud callFunctionInBackground:@"SMS"
                           withParameters:@{
                                            @"phonenum": contact[@"cellPhone"],
                                            @"username": current[@"name"],
                                            @"friendname": contact[@"name"],
                                            @"destination": @"",
                                            @"source": @"",
                                            @"time": @"",
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
+ (void)SendEmail:(PFObject *)contact from:(PFObject *)current {
    if (contact[@"email"] && current[@"name"] && contact[@"name"]){
        [PFCloud callFunctionInBackground:@"Email"
                           withParameters:@{
                                            @"email": contact[@"email"],
                                            @"username": current[@"name"],
                                            @"friendname": contact[@"name"],
                                            @"destination": @"",
                                            @"source": @"",
                                            @"time": @"",
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

