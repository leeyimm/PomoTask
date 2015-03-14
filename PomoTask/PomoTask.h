//
//  PomoTask.h
//  PomoTask
//
//  Created by Ying on 3/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define STATUS_PENDING 0
#define STATUS_TODOTODAY 1
#define STATUS_COMPLETED 2

@class Pomo;

@interface PomoTask : NSManagedObject

@property (nonatomic, retain) NSDate * completedDate;
@property (nonatomic) NSInteger consumedPomo;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSString * dueDate;
@property (nonatomic) NSInteger estimatedPomo;
@property (nonatomic) NSInteger interruptedPomo;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * taskName;
@property (nonatomic) NSInteger priority;
@property (nonatomic, retain) NSSet *pomos;
@end

@interface PomoTask (CoreDataGeneratedAccessors)

- (void)addPomosObject:(Pomo *)value;
- (void)removePomosObject:(Pomo *)value;
- (void)addPomos:(NSSet *)values;
- (void)removePomos:(NSSet *)values;

@end
