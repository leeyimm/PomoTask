//
//  PomoInPomosOfDayViewCell.h
//  PomoTask
//
//  Created by Ying on 3/3/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PomoInPomosOfDayViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pomoImage;

@property (weak, nonatomic) IBOutlet UILabel *pomoTaskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pomoTimeDetailLabel;

@end
