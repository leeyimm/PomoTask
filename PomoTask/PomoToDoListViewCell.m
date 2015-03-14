//
//  PomoToDoListViewCell.m
//  PomoTask
//
//  Created by Ying on 2/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoToDoListViewCell.h"

@interface PomoToDoListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *estimatedPomoImage;
@property (weak, nonatomic) IBOutlet UIImageView *consumedPomoImage;
@property (weak, nonatomic) IBOutlet UIImageView *interruptedPomoImage;

@end

@implementation PomoToDoListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.estimatedPomoImage.image = [UIImage imageNamed:@"Pomodoro_Estimated.png"];
    self.consumedPomoImage.image = [UIImage imageNamed:@"Pomodoro_Done.png"];
    self.interruptedPomoImage.image = [UIImage imageNamed:@"Pomodoro_Interrupted.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
