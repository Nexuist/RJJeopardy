//
//  RJMainView.m
//  RJJeopardy
//
//  Created by Andi Andreas on 5/9/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAnswerPicker.h"
#import "RJCard.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "MBProgressHUD.h"

@interface RJMainViewController: UIViewController <UITableViewDataSource, UITableViewDelegate, RJAnswerPickerDelegate, UIBarPositioningDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UILabel *CapuletScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *MontagueScoreLabel;
@property (nonatomic) int currentTeamIndex;
@end

@interface RJMainViewController ()
@property NSDictionary *questions;
@property (nonatomic)  NSString *category;
@property NSMutableArray *points;
@property NSMutableDictionary *completedQuestions;
@end


@implementation RJMainViewController

#pragma mark UI methods
- (void)viewDidLoad
{
    self.questions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
    self.completedQuestions = [[NSMutableDictionary alloc] init];
    self.category = [self.questions allKeys][0];
    // 315 is the total number of possible points
    self.points = [NSMutableArray arrayWithObjects:@0, @0, @315, nil];
    [self updateLabels];
}

- (UIBarPosition)positionForBar:(UINavigationBar<UIBarPositioning> *)bar
{
    // Attaches the navbar to the top
    return UIBarPositionTopAttached;
}

- (IBAction)categorySelectorTapped:(id)sender
{
    [UIActionSheet showInView:self.view withTitle:@"Choose Category" cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil otherButtonTitles:[self.questions allKeys] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        // Make sure cancel button wasn't pressed
        if (buttonIndex < [[self.questions allKeys] count]) {
            self.category = [self.questions allKeys][buttonIndex];
            [self.tableView reloadData];
        }
    }];
}

- (void)updateLabels
{
    self.turnLabel.textAlignment = (self.currentTeamIndex ? NSTextAlignmentRight : NSTextAlignmentLeft);
    self.CapuletScoreLabel.text = [self.points[0] stringValue];
    self.MontagueScoreLabel.text = [self.points[1] stringValue];
}

- (void)showHUDWithTopText:(NSString *)topText bottomText:(NSString *)bottomText
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = topText;
    HUD.detailsLabelText = bottomText;
    [HUD hide:YES afterDelay:1];
}

- (void)setCategory:(NSString *)category
{
    _category = category;
    // Create holder for completed questions if it doesn't exist already
    if (![self.completedQuestions objectForKey:self.category])
        self.completedQuestions[self.category] = @[];
    self.navigationBar.topItem.title = category;
}

- (void)setCurrentTeamIndex:(int)currentTeamIndex
{
    _currentTeamIndex = currentTeamIndex;
    [self updateLabels];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray *)question
{
    RJAnswerPicker *picker = [segue destinationViewController];
    [picker setQuestion:question];
    [picker setDelegate:self];
}


#pragma mark - Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questions[self.category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RJCard *cell = [self.tableView dequeueReusableCellWithIdentifier:@"card" forIndexPath:indexPath];
    NSArray *question = self.questions[self.category][indexPath.row];
    cell.pointsLabel.text = [NSString stringWithFormat:@"%@", question[0]];
    cell.question = question;
    // Check to see if question has been completed before
    if ([self cellAnsweredPreviously:cell]) {
        cell.answeredBefore = YES;
    }
    else {
        cell.answeredBefore = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RJCard *cell = (RJCard *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([self cellAnsweredPreviously:cell]) {
        [UIAlertView showWithTitle:@"Error" message:@"This question was already answered." cancelButtonTitle:@"Okay" otherButtonTitles:nil tapBlock:nil];
    }
    else {
        [self promptQuestion:cell.question];
        
    }
}

#pragma mark Game logic

- (void)promptQuestion:(NSArray *)question
{
    NSString *segueIdentifier;
    switch ([question[2] intValue]) {
        case 0:
            segueIdentifier = @"multipleChoice";
            break;
        case 1:
            segueIdentifier = @"fillInTheBlank";
            break;
        case 2:
            segueIdentifier = @"trueFalse";
            break;
    }
    [self performSegueWithIdentifier:segueIdentifier sender:question];
}

- (void)answerPicker:(RJAnswerPicker *)answerPicker didFinishWithCorrectAnswer:(BOOL)correct
{
    int points = [[answerPicker question][0] intValue];
    [self registerQuestionCompletion:points];
    if (!correct)
        // Make points negative
        points = points * -1;
    [self endTurnWithPoints:points];
    NSString *correctOrNah = [NSString stringWithFormat:@"%@", correct ? @"Correct Answer" : @"Wrong Answer"];
    NSString *pointString = [NSString stringWithFormat:@"%@%d points", (correct ? @"+" : @""), points];
    [self showHUDWithTopText:pointString bottomText:correctOrNah];
    
}

- (void)registerQuestionCompletion:(int)points
{
    self.completedQuestions[self.category] = [self.completedQuestions[self.category] arrayByAddingObject:[NSNumber numberWithInt:points]];
}

- (BOOL)cellAnsweredPreviously:(RJCard *)cell
{
    NSNumber *points = cell.question[0];
    if ([self.completedQuestions[self.category] containsObject:points])
        return YES;
    return NO;
}

- (void)endTurnWithPoints:(int)points
{
    int currentTeamPoints = [self.points[self.currentTeamIndex] intValue];
    NSNumber *newPoints = @(currentTeamPoints + points);
    self.points[self.currentTeamIndex] = newPoints;
    [self checkEndGameCondition];
    // Switches teams
    // And updates labels
    self.currentTeamIndex = (self.currentTeamIndex + 1) % 2;
    [self.tableView reloadData];
}

- (void)checkEndGameCondition
{
    int currentPoints = 0;
    int totalPoints = [self.points[2] intValue];
    for (NSString *category in self.completedQuestions) {
        for (NSNumber *point in self.completedQuestions[category]) {
            currentPoints = currentPoints + [point intValue];
        }
    }
    NSLog(@"%d", currentPoints);
    if (currentPoints >= totalPoints) {
        // Sleep so the picker can animate out
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"end" sender:self.points];
        });
    }
}

@end
