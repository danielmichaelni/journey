//
//  TimerViewController.m
//  journey
//
//  Created by Daniel Ni on 2/27/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "TimerViewController.h"
#import "CountDownViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface TimerViewController ()
{
    NSMutableArray *_pickerData;
}
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"source: <%f, %f>", self.journey.source.latitude, self.journey.source.longitude);
    NSLog(@"destination: <%f, %f>", self.journey.destination.latitude, self.journey.destination.longitude);

    self.timeInstructionLabel.font = [UIFont fontWithName:@"Hero-Light" size:20];
    self.startJourneyOutlet.font = [UIFont fontWithName:@"Hero-Light" size:20];
    
    _pickerData = [NSMutableArray array];
    for(int i = 1; i < 61; i++) {
        [_pickerData addObject:[NSString stringWithFormat:@"%d",i]];
    }

    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self.picker selectRow:14 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeExpired:) userInfo:nil repeats:NO];


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toCountDownViewControllerSegue"]) {
        CountDownViewController *destinationViewController = segue.destinationViewController;
        /*
        NSInteger row = [self.picker selectedRowInComponent:0];
        NSString *selected = [_pickerData objectAtIndex:row];
        int min = [selected intValue];
        
        self.journey.minutesCount = min;
        */
        destinationViewController.journey = self.journey;
    }
}

- (IBAction)startJourneyButtonPressed:(UIButton *)sender {
    NSLog(@"start journey button pressed");
    NSInteger row = [self.picker selectedRowInComponent:0];
    NSString *selected = [_pickerData objectAtIndex:row];
    int min = [selected intValue];
    
    self.journey.minutesCount = min;
    
    PFUser *user = [PFUser currentUser];

    [PFCloud callFunctionInBackground:@"newJourney"
                       withParameters:@{ @"user": user,
                                         @"duration": [NSNumber numberWithInt:min*60],
                                         @"start_location": self.journey.sourceString,
                                         @"destination": self.journey.destinationString }
                                block:^(id object, NSError *error) {
                                    if (error) {
                                        NSLog(@"ERROR calling newJourney: %@", error);
                                    } else {
                                        NSLog(@"succeeded in calling newJourney function");
                                    }
                                }];
}

@end
