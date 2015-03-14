//
//  Pomo.h
//  PomoTask
//
//  Created by Ying on 3/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PomoTask;

@interface Pomo : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * isPartial;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) PomoTask *pomoTask;

@end
