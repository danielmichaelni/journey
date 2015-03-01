//
//  CountDownViewController.m
//  journey
//
//  Created by Daniel Ni on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "CountDownViewController.h"
#import "Communication.h"
#import <math.h>

@interface CountDownViewController ()

@end

@implementation CountDownViewController

static NSLock *cancelled_lock;
static BOOL is_cancelled;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.finishJourneyOutlet.font = [UIFont fontWithName:@"Hero-Light" size:20];
    
    self.secondsCount = self.journey.minutesCount * 60;
    
    int minutes = self.secondsCount / 60;
    int seconds = self.secondsCount % 60;
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
    self.timeLabel.text = timerOutput;
    self.timeLabel.font = [UIFont fontWithName:@"Hero-Light" size:80];
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerRun {
    self.secondsCount -= 1;
    int minutes = self.secondsCount / 60;
    int seconds = self.secondsCount % 60;
    
    // DON"T FORGET THIS PARRT!!!!!
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    [locationManager requestAlwaysAuthorization];
    
    
    CLLocation *loc_a = [[CLLocation alloc] initWithLatitude:self.journey.destination.latitude longitude:self.journey.destination.longitude];
    CLLocation *loc_b = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    
    
    double distance = [loc_a getDistanceFrom:loc_b];
    
    NSLog(@"%f", distance);
    
    
//    NSLog(@"Destination: %f %f\nCurrent: %f %f", self.journey.destination.latitude, self.journey.destination.longitude, locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    
    
    // CHECKING IF AT HOME
    if (!seconds) {
//        double distancex = pow((self.journey.destination.latitude - locationManager.location.coordinate.latitude), 2);
//        double distancey = pow((self.journey.destination.latitude - locationManager.location.coordinate.latitude), 2);
//        
//        double distance = sqrt((distancex + distancey));
        
        CLLocation *loc_a = [[CLLocation alloc] initWithLatitude:self.journey.destination.latitude longitude:self.journey.destination.longitude];
        CLLocation *loc_b = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        
        
        double distance = [loc_a getDistanceFrom:loc_b];
        
        if (distance < 550) {
            NSLog(@"You just got home!");
            if(self.countDownTimer) {
                [self.countDownTimer invalidate];
                self.countDownTimer = nil;
            }
            [self performSegueWithIdentifier:@"toSuccessViewControllerSegue" sender:self];
            [cancelled_lock lock];
            is_cancelled = NO;
            [cancelled_lock unlock];
            return;
        }
    }

    if(is_cancelled) {
        if(self.countDownTimer) {
            [self.countDownTimer invalidate];
            self.countDownTimer = nil;
            NSLog(@"timer actually cancelled");
            [self performSegueWithIdentifier:@"toSuccessViewControllerSegue" sender:self];
            [cancelled_lock lock];
            is_cancelled = NO;
            [cancelled_lock unlock];
            return;
        }
    }
    
    // CHECKING IF LOST
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
    self.timeLabel.text = timerOutput;
    
    if(self.secondsCount == 0) {
        if(self.countDownTimer) {
            [self.countDownTimer invalidate];
            self.countDownTimer = nil;
        }
        
//        double distancex = pow((self.journey.destination.latitude - locationManager.location.coordinate.latitude), 2);
//        double distancey = pow((self.journey.destination.longitude - locationManager.location.coordinate.longitude), 2);
//        
//        double distance = sqrt((distancex + distancey));
//
        
        CLLocation *loc_a = [[CLLocation alloc] initWithLatitude:self.journey.destination.latitude longitude:self.journey.destination.longitude];
        CLLocation *loc_b = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        
        
        double distance = [loc_a getDistanceFrom:loc_b];
        
        
        NSLog(@"Dist:%f", distance);
        
        if (distance > 550) {
            NSLog(@"Outside of radius.");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you still want to send the alert to your contacts?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] ;
            // optional - add more buttons:
            [alert addButtonWithTitle:@"Yes"];
            
            [alert show];
        } else {
            NSLog(@"Inside of radius.");
            [self performSegueWithIdentifier:@"toSuccessViewControllerSegue" sender:self];
        }
  
        NSLog(@"time expired");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // cancel button
        NSLog(@"Cancelled!");
        [self performSegueWithIdentifier:@"toSuccessViewControllerSegue" sender:self];
    } else if (buttonIndex == 1) {
        // Yes
        NSLog(@"send messages!");
        [Communication contactFriends:self.journey];
    }
}

- (IBAction)finishJourneyButton:(UIButton *)sender {
    [cancelled_lock lock];
    is_cancelled = YES;
    [cancelled_lock unlock];
//    if(self.countDownTimer) {
//        [self.countDownTimer invalidate];
//        self.countDownTimer = nil;
//        NSLog(@"cancelled timer %d");
//    }
}
@end
