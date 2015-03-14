//
//  PomoToDoListViewController.h
//  PomoTask
//
//  Created by Ying on 2/5/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSManagedObjectContext+ChangeFlag.h"


#define SECTION_TODOTODAY 0
#define SECTION_PENDING 1
#define SECTION_COMPLETED  2

@interface PomoToDoListViewController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;	

- (IBAction)unwindFromAdd:(UIStoryboardSegue *)segue;
- (IBAction)unwindFromPomo:(UIStoryboardSegue *)segue;

@end
