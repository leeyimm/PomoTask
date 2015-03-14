//
//  PomoToDoListViewCell.h
//  PomoTask
//
//  Created by Ying on 2/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PomoToDoListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCreatedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumedPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *interruptedPomoLabel;

@end
