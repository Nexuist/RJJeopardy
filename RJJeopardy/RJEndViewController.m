//
//  RJEndViewController.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/23/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAnswerPicker.h"

// This inherits from RJAnswerPicker just so prepareForSegue: in RJMainViewController can handle it like a regular answer picker
@interface RJEndViewController : RJAnswerPicker
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *capuletPoints;
@property (weak, nonatomic) IBOutlet UILabel *montaguePoints;
@end

@implementation RJEndViewController

- (void)viewDidLoad
{
    NSString *winner = @"Capulet";
    if ([self.question[0] intValue] < [self.question[1] intValue]) {
        winner = @"Montague";
        self.winLabel.textColor = [UIColor colorWithRed:(124/255.0) green:(152/255.0) blue:(255/255.0) alpha:1.0];
    }
    self.winLabel.text = [NSString stringWithFormat:@"%@ wins!", winner];
    self.capuletPoints.text = [NSString stringWithFormat:@"%@", self.question[0]];
    self.montaguePoints.text = [NSString stringWithFormat:@"%@", self.question[1]];
}

- (UIBarPosition)positionForBar:(UINavigationBar<UIBarPositioning> *)bar
{
    bar.barTintColor = [UIColor colorWithRed:(236/255.0) green:(15/255.0) blue:(43/255.0) alpha:1.0];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    bar.topItem.title = @"Game Over";
    // Attaches the navbar to the top
    return UIBarPositionTopAttached;
}

@end
