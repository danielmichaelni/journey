//
//  FailureViewController.m
//  journey
//
//  Created by Daniel Ni on 3/1/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "FailureViewController.h"

@interface FailureViewController ()

@end

@implementation FailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.failureLabel.font = [UIFont fontWithName:@"Hero-Light" size:20];
    self.returnHomeOutlet.font = [UIFont fontWithName:@"Hero-Light" size:20];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
