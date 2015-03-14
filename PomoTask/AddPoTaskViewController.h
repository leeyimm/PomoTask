//
//  AddPoTaskViewController.h
//  PomoTask
//
//  Created by Ying on 2/5/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomoTask.h"

@interface AddPoTaskViewController : UIViewController

@property (nonatomic,strong) PomoTask* taskToBeAdd;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;	

@end
