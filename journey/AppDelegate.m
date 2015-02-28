//
//  AppDelegate.m
//  journey
//
//  Created by Charles Chamberlain on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Communication.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"ZpuXzvuAPi4SChpYQEMaMZGFo4VtF9eMZtvBoGzv"
                  clientKey:@"sUrEE1CCtcE6LVCqSni8nXBg69TYeOyt54Aqzn5F"];
    
    if (NO) { //Testing
        [Communication SendSMS:@"3012727051" withMessage:@"Good Morning"];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSString stringWithFormat:@"charlespippin@gmail.com"]];
        [array addObject:[NSString stringWithFormat:@"ikachan48@gmail.com"]];
        //[Communication SendBulkSMS:array withMessage:@"HELLO"];
        [Communication SendEmail:@"ikachan48@gmail.com" withSubject:@"NEW" withMessage:@"yehhlooh"];
        [Communication SendBulkEmail:array withSubject:@"Bulk Test" withMessage:@"not important"];
    }
    
    [PFFacebookUtils initializeFacebook];
    
    [GMSServices provideAPIKey:@"AIzaSyA967lZf-JIWj8xFX1YqOUQGtW8jqOQu0A"];
    
    /*
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
     */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[PFFacebookUtils session] close];
}

@end
