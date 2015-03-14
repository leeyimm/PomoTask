//
//  PomoCycle.m
//  PomoTask
//
//  Created by Ying on 2/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoCycle.h"


NSString *const PomoCycleReadyNotification = @"PomoCycleReady";
NSString *const PomoDoneNotification = @"PomoDone";
NSString *const RecessOverNotification = @"RecessOver";
NSString *const SecondTickNotification = @"SecondTick";


@interface PomoCycle ()



@end

@implementation PomoCycle

+(instancetype)sharedPomoCycle
{
    static PomoCycle *pomoCycle = nil;
    if (!pomoCycle) {
        pomoCycle = [[self alloc] initPrivate];
    }

    return pomoCycle;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton PomoCycle" reason:@"Use [PomoCycle sharedPomoCycle" userInfo:nil];
}

-(instancetype)initPrivate
{
    self = [super init];
    [self addObserver:self forKeyPath:@"pomoStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int oldValue = [[change valueForKey:NSKeyValueChangeOldKey] intValue];
    int newValue = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
    
    //if (oldValue == newValue) return;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSInteger foucsTimeInterval = [userDefaultes integerForKey:@"FocusTimeInterval"];
    NSInteger recessTimeInterval = [userDefaultes integerForKey:@"RecessTimeInterval"];
    
    switch (newValue) {
        case READY:
            self.durationTimeInSecond = foucsTimeInterval*60;
            self.pomoLeftTimeInSecond = foucsTimeInterval*60;
            [[NSNotificationCenter defaultCenter] postNotificationName:PomoCycleReadyNotification object:self];
            break;
        case FOCUS:
            _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
            break;
        case DONE:
            if (oldValue == FOCUS){
                self.durationTimeInSecond = recessTimeInterval*60;
                self.pomoLeftTimeInSecond = recessTimeInterval*60;
                [[NSNotificationCenter defaultCenter] postNotificationName:PomoDoneNotification object:self];
            }
            else if (oldValue == RECESS)
            {
                self.pomoStatus = READY;
                [[NSNotificationCenter defaultCenter] postNotificationName:RecessOverNotification object:self];               
            }
            [_pomodoroTimer invalidate];
            _pomodoroTimer=nil;
            break;
        case RECESS:
            _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
            break;
        case BREAK:
            [_pomodoroTimer invalidate];
            _pomodoroTimer=nil;
            self.pomoStatus = READY;
    }

}

- (void)timeGoes:(NSTimer *)timer
{
    if (_pomoLeftTimeInSecond > 0){
        _pomoLeftTimeInSecond--;
        [[NSNotificationCenter defaultCenter] postNotificationName:SecondTickNotification object:self];
    } else {
        if (self.pomoStatus==FOCUS) {
            self.pomoStatus = DONE;
        }else if(self.pomoStatus == RECESS)
        {
            self.pomoStatus = DONE;
        }
    }
}

@end
