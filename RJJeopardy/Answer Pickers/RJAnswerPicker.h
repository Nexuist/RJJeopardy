//
//  RJAnswerPicker.h
//  RJJeopardy
//
//  Created by Andi Andreas on 5/11/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJAnswerPickerDelegate <NSObject>
- (void)answerPicker:(id)answerPicker didFinishWithCorrectAnswer:(BOOL)correct;
@end

@interface RJAnswerPicker : UIViewController <UIBarPositioningDelegate>
@property NSArray *question;
@property id<RJAnswerPickerDelegate> delegate;
@end
