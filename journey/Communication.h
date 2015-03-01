//
//  Communication.h
//  journey
//
//  Created by  Apple on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <Parse/Parse.h>

#ifndef journey_Communication_h
#define journey_Communication_h


#endif

@interface Communication : NSObject

+ (void)SendSMS:(PFObject *)contact from:(PFObject *)current;
+ (void)SendEmail:(PFObject *)contact from:(PFObject *)current;


@end