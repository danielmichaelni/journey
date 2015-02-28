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

+ (void)SendSMS:(NSString *)phone withMessage:(NSString *)message {
    [PFCloud callFunctionInBackground:@"SMS"
                       withParameters:@{
                                        @"phonenum": phone,
                                        @"message": message
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"ERROR: %@",error);
                                    } else {
                                        NSLog(@"%@ [%@]", result, phone);
                                    }
                                }];
}
+ (void)SendBulkSMS: (NSMutableArray *)phones withMessage:(NSString *)message {
    for(NSString *phone in phones) {
        [self SendSMS:phone withMessage:message];
    }
}
+ (void)SendEmail:(NSString *)email withSubject:(NSString *)subject withMessage:(NSString *)message {
    [PFCloud callFunctionInBackground:@"Email"
                       withParameters:@{
                                        @"email": email,
                                        @"message": message,
                                        @"subject": subject
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"ERROR: %@",error);
                                    } else {
                                        NSLog(@"%@ [%@]", result, email);
                                    }
                                }];
}
+ (void)SendBulkEmail: (NSMutableArray *)emails withSubject:(NSString *)subject withMessage:(NSString *)message {
    for(NSString *email in emails) {
        [self SendEmail:email withSubject:subject withMessage:message];
    }
}


@end

