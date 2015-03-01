//
//  CountDownViewController.m
//  journey
//
//  Created by Daniel Ni on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "CountDownViewController.h"
#import "Communication.h"

@interface CountDownViewController ()

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.secondsCount = self.journey.minutesCount * 60;
    
    int minutes = self.secondsCount / 60;
    int seconds = self.secondsCount % 60;
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
    self.timeLabel.text = timerOutput;
    self.timeLabel.font = [UIFont fontWithName:@"Hero-Light" size:50];
    
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
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
    self.timeLabel.text = timerOutput;
    
    if(self.secondsCount == 0) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
//        [Communication contactFriends:self.journey];
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

- (IBAction)finishJourneyButton:(UIButton *)sender {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [Communication contactFriends:self.journey];
    NSLog(@"cancelled timer");
}
@end
