//
//  Utility.m
//  PomoTask
//
//  Created by Ying on 2/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSDate *)beginningOfDay
{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:date] / 3600;
    [components setHour:timeZoneOffset];
    [components setMinute:0];
    [components setSecond:0];
    
    //NSLog(@"beginningOfDay is %@", [cal dateFromComponents:components]);
    
    return [cal dateFromComponents:components];
    
}

+(NSDate*)nDaysBeforeToday: (int)days
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [[NSDate alloc]
                         initWithTimeIntervalSinceNow:(-secondsPerDay*days)];
    return yesterday;
}

+(BOOL)checkCrossDay: (NSDate *)oldDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString *oldDateString = [dateFormatter stringFromDate:oldDate];
    
    return ![oldDateString isEqualToString:[dateFormatter stringFromDate:[NSDate date]]];
}

@end
