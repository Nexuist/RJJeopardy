//
//  RJTrueFalseView.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/18/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAnswerPicker.h"

@interface RJTrueFalsePicker : RJAnswerPicker
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *trueButton;
@property (weak, nonatomic) IBOutlet UIButton *falseButton;
@end

@implementation RJTrueFalsePicker
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question[1];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points", self.question[0]];
    self.trueButton.layer.cornerRadius = self.trueButton.bounds.size.width / 2.0;
    self.falseButton.layer.cornerRadius = self.falseButton.bounds.size.width / 2.0;
}

- (IBAction)choicePicked:(UIButton *)sender {
    int realAnswer = [self.question[3] intValue];
    int chosenAnswer = (int)sender.tag;
    BOOL correct = NO;
    if (chosenAnswer == realAnswer)
        correct = YES;
    // Animate the button
    [UIView animateWithDuration:0.4 animations:^{
        sender.backgroundColor = (correct ? [UIColor greenColor] : [UIColor redColor]);
    } completion:^(BOOL finished) {
        [self.delegate answerPicker:self didFinishWithCorrectAnswer:correct];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}
@end
