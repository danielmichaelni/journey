//
//  CountDownViewController.h
//  journey
//
//  Created by Daniel Ni on 2/28/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"
#import <UIKit/UIKit.h>

@interface CountDownViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) Journey *journey;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) int secondsCount;
@property (strong, nonatomic) IBOutlet UIButton *finishJourneyOutlet;

- (IBAction)finishJourneyButton:(UIButton *)sender;

@end
