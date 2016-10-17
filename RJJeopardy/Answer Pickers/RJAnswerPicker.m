//
//  RJAnswerPicker.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/12/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import "RJAnswerPicker.h"

@implementation RJAnswerPicker

- (UIBarPosition)positionForBar:(UINavigationBar<UIBarPositioning> *)bar
{
    bar.barTintColor = [UIColor colorWithRed:(33/255.0) green:(180/255.0) blue:(15/255.0) alpha:1.0];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    bar.topItem.title = @"Question";
    // Attaches the navbar to the top
    return UIBarPositionTopAttached;
}
@end
