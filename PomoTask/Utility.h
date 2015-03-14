//
//  Utility.h
//  PomoTask
//
//  Created by Ying on 2/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSDate *)beginningOfDay;

+(NSDate*)nDaysBeforeToday: (int)days;

+(BOOL)checkCrossDay: (NSDate *)oldDate;

@end
