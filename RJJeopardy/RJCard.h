//
//  RJCard.h
//  RJJeopardy
//
//  Created by Andi Andreas on 5/9/14.
//  Copyright (c) 2014 Deplex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJCard : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property NSArray *question;
@property BOOL answeredBefore;
@end

@implementation RJCard
- (void)layoutSubviews
{
    if (self.answeredBefore) {
        [self setHighlighted:YES animated:YES];
    }
    else {
        [self setHighlighted:NO animated:YES];
    }
}
@end