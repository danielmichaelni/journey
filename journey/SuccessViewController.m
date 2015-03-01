//
//  SuccessViewController.m
//  journey
//
//  Created by Daniel Ni on 3/1/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import "SuccessViewController.h"
#import "ViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successLabel.font = [UIFont fontWithName:@"Hero-Light" size:20];
    self.successLabel.numberOfLines = 0;
    self.returnHomeOutlet.font = [UIFont fontWithName:@"Hero-Light" size:20];
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

- (IBAction)returnHomeButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"returnHomeSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"returnHomeSegue"]) {
        ViewController *destinationViewController = segue.destinationViewController;
        UINavigationBar *navBar = [[UINavigationBar alloc] init];
        [destinationViewController.view addSubview:navBar];
        
    }
}

@end
