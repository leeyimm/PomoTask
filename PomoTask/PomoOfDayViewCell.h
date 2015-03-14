//
//  PomoOfDayViewCell.h
//  PomoTask
//
//  Created by Ying on 2/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PomoOfDayViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *interruptedPomoLabel;

@end
