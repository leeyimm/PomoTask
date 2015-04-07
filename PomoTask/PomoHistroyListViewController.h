//
//  PomoHistroyListViewController.h
//  PomoTask
//
//  Created by Ying on 2/10/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSManagedObjectContext+LastModifyDate.h"

@interface PomoHistroyListViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;	

@end
