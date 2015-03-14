//
//  PomoCycle.h
//  PomoTask
//
//  Created by Ying on 2/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PomoTask.h"
#import "Pomo.h"

#define     INVALID 0
#define     READY  1
#define     FOCUS 2
#define     DONE 3
#define     RECESS 4
#define     BREAK 5

#define POMODORO_TIME 20
#define RECESS_TIME 10

extern NSString *const PomoDoneNotification;
extern NSString *const RecessOverNotification;
extern NSString *const SecondTickNotification;
extern NSString *const PomoCycleReadyNotification;

@interface PomoCycle : NSObject

@property (nonatomic, strong) PomoTask* bindTask;
@property (nonatomic,strong) Pomo *pomo;
@property int pomoStatus;
@property NSInteger durationTimeInSecond;
@property NSInteger pomoLeftTimeInSecond;

@property (nonatomic) NSTimer *pomodoroTimer;
+(instancetype)sharedPomoCycle;


@end
