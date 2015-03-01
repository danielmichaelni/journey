//
//  TimerViewController.h
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "Journey.h"

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) Journey *journey;

- (IBAction)startJourneyButton:(UIButton *)sender;

@end
