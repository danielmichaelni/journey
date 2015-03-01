//
//  SuccessViewController.h
//  journey
//
//  Created by Daniel Ni on 3/1/15.
//  Copyright (c) 2015 charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *successLabel;
@property (strong, nonatomic) IBOutlet UIButton *returnHomeOutlet;

- (IBAction)returnHomeButton:(UIButton *)sender;

@end
