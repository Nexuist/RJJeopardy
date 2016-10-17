//
//  RJFillInTheBlankView.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/21/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAnswerPicker.h"

@interface RJFillInTheBlankPicker : RJAnswerPicker
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerBox;

@end

@interface NSString (RJExtensions)
- (NSString *)formatString;
@end

@implementation NSString (RJExtensions)
- (NSString *)formatString
{
    NSString *stringToReturn = [self lowercaseString];
    stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@" " withString:@""];
    return stringToReturn;
}
@end

@implementation RJFillInTheBlankPicker
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question[1];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points", self.question[0]];
    [self.answerBox becomeFirstResponder];
}

- (IBAction)submit {
    NSString *realAnswer = [self.question[3] formatString];
    NSString *chosenAnswer = [self.answerBox.text formatString];
    BOOL correct = NO;
    if ([chosenAnswer isEqualToString:realAnswer])
        correct = YES;
    [self.delegate answerPicker:self didFinishWithCorrectAnswer:correct];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
