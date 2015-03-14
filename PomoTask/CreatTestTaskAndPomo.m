//
//  CreatTestTaskAndPomo.m
//  PomoTask
//
//  Created by Ying on 2/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "CreatTestTaskAndPomo.h"
#import "PomoTask.h"
#import "Pomo.h"
#import "Utility.h"

@implementation CreatTestTaskAndPomo

+(void)createObjectForTest: (NSManagedObjectContext *) managedObjectContext
{
    for (int i =0; i<12; i++) {
        PomoTask *task = (PomoTask *)[NSEntityDescription insertNewObjectForEntityForName:@"PomoTask" inManagedObjectContext:managedObjectContext];
        task.taskName = [NSString stringWithFormat:@"task%d",i];
        task.estimatedPomo=5;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        task.dueDate = [dateFormatter stringFromDate:[NSDate date]];
        task.createdTime = [NSDate date];
        task.status = [NSNumber numberWithInt:(i%3)]; // 0 is pending
        if (i%3==2) {
            task.completedDate = [Utility nDaysBeforeToday:i];
        }
        
        for (int j=0; j<4; j++) {
            Pomo *pomo = (Pomo *)[NSEntityDescription insertNewObjectForEntityForName:@"Pomo" inManagedObjectContext:managedObjectContext];
            pomo.pomoTask = task;
            pomo.startTime = [[NSDate alloc] initWithTimeIntervalSinceNow:(-i*12-j)];
            pomo.endTime = [NSDate date];
            if (j%2 ==0) {
                pomo.isPartial = [NSNumber numberWithInt:0];
            }else{
                pomo.isPartial = [NSNumber numberWithInt:1];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            pomo.date = [dateFormatter stringFromDate:[Utility nDaysBeforeToday:i]];
            [task addPomosObject:pomo];
        }
    }
    
    
}

@end
