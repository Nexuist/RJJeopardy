//
//  RJMultipleChoiceView.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/11/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAnswerPicker.h"

@interface RJMultipleChoicePicker : RJAnswerPicker
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *choiceA;
@property (weak, nonatomic) IBOutlet UIView *choiceB;
@property (weak, nonatomic) IBOutlet UIView *choiceC;
@property (weak, nonatomic) IBOutlet UIView *choiceD;
@end

@implementation RJMultipleChoicePicker

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question[1];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points", self.question[0]];
    NSArray *choiceViews = @[self.choiceA, self.choiceB, self.choiceC, self.choiceD];
    int index = 0;
    for (UIView *choiceView in choiceViews) {
        choiceView.layer.cornerRadius = 5;
        choiceView.clipsToBounds = YES;
        [(UILabel *)choiceView.subviews[0] setText:self.question[3][index]];
        index++;
    }
    
}

- (IBAction)choicePicked:(UIButton *)sender
{
    int realAnswer = [self.question[4] intValue];
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
