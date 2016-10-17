//
//  RJStartView.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/10/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>

@interface RJMainViewController : UIViewController
@property int currentTeamIndex;
@end

@interface RJStartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *teamSelector;
@end

@implementation RJStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.startButton.layer.cornerRadius = 5;
    self.startButton.clipsToBounds = YES;
    self.startButton.layer.borderWidth = 1.0f;
    self.startButton.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setCurrentTeamIndex:(int)self.teamSelector.selectedSegmentIndex];
}
@end
