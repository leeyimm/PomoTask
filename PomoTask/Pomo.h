//
//  Pomo.h
//  PomoTask
//
//  Created by Ying on 3/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@class PomoTask;

@interface Pomo : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic) BOOL  isPartial;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) PomoTask *pomoTask;

@end
