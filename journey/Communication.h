//
//  Communication.h
//  journey
//
//  Created by  Apple on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#ifndef journey_Communication_h
#define journey_Communication_h


#endif

@interface Communication : NSObject

+ (void)SendSMS:(NSString *)phone withMessage:(NSString *)message;
+ (void)SendBulkSMS: (NSMutableArray *)phones withMessage:(NSString *)message;
+ (void)SendEmail:(NSString *)email withSubject:(NSString *)subject withMessage:(NSString *)message;
+ (void)SendBulkEmail:(NSMutableArray *)emails withSubject:(NSString *)subject withMessage:(NSString *)message;



@end