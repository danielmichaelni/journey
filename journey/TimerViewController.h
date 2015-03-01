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
@property (strong, nonatomic) IBOutlet UILabel *timeInstructionLabel;
@property (strong, nonatomic) IBOutlet UIButton *startJourneyOutlet;

@property (strong, nonatomic) Journey *journey;


@end
