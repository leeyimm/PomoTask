//
//  PomoCycleViewController.h
//  PomoTask
//
//  Created by Ying on 2/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomoTask.h"

@interface PomoCycleViewController : UIViewController

@property (nonatomic, strong) PomoTask* task;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)unwindFromSetting:(UIStoryboardSegue *)segue;

@end
