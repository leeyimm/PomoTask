//
//  PomoCycleViewController.m
//  PomoTask
//
//  Created by Ying on 2/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoCycleViewController.h"
#import "PomoCycle.h"
#import "Pomo.h"
#import <AudioToolbox/AudioServices.h>


@interface PomoCycleViewController ()

@property (nonatomic,strong) UIImageView *startPoint;
@property (nonatomic,strong) UIImageView *progressPoint;
@property (nonatomic,strong) UILabel *countDownLabel;
@property (nonatomic,strong) UILabel *taskNameLabel;
@property (nonatomic,strong) UILabel *consumedPomoLabel;
@property (nonatomic,strong) UILabel *estimatedPomoLabel;
@property (nonatomic,strong) UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToDoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goToSettingButton;
@property (nonatomic,strong) UIAlertView *confirmBreakAlertView;

@property (nonatomic, weak) PomoCycle *pomoCycle;

//@property (nonatomic,strong) Pomo *pomo;

@end

@implementation PomoCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewInitilize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForNotifications];
    
    self.pomoCycle = [PomoCycle  sharedPomoCycle];
    
    if (self.pomoCycle.bindTask ==nil){
        self.pomoCycle.bindTask = self.task;
        self.pomoCycle.pomoStatus = READY;
    }else if (self.task!= self.pomoCycle.bindTask){
        if(self.pomoCycle.pomoStatus==FOCUS||self.pomoCycle.pomoStatus==RECESS) {
            NSString *alertMessage = [NSString stringWithFormat:@"Already focus on task \"%@\", do you want to break it and start \"%@\"?", self.pomoCycle.bindTask.taskName, self.task.taskName];
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Pomo Exist"
                                                               message:alertMessage
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert addButtonWithTitle:@"No"];
            [theAlert show];
        }else{
            self.pomoCycle.bindTask = self.task;
            self.pomoCycle.pomoStatus = INVALID;
            self.pomoCycle.pomoStatus = READY;
        }
    }else if (self.pomoCycle.pomoStatus == READY){
        self.pomoCycle.pomoStatus = INVALID;
        self.pomoCycle.pomoStatus = READY;
    }
    [self updateCountDownLabel];
    [self updatePomoLabel];
    [self updateTitleAndBackground];
    [self updateButton];
    //self.view.backgroundColor = [UIColor greenColor];
}

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([theAlert.title  isEqual: @"Pomo Exist"]) {
        if (buttonIndex==0) {
            self.pomoCycle.bindTask = self.task;
            self.pomoCycle.pomoStatus = BREAK;
            
        }
        if (buttonIndex ==1) {
            self.task = self.pomoCycle.bindTask;
        }
        [self updateCountDownLabel];
        [self updatePomoLabel];
        [self updateTitleAndBackground];
    }
    else if([theAlert.title  isEqual: @"Break Confirm"]) {
        if (buttonIndex==1) {
            self.pomoCycle.pomo.endTime = [NSDate date];
            self.pomoCycle.bindTask.interruptedPomo+=1;
            self.pomoCycle.pomo.isPartial = YES;
            [self.pomoCycle.bindTask addPomosObject:self.pomoCycle.pomo];
            //[self enableBackAndSettingButton:YES];
            self.pomoCycle.pomo =nil;
            [self enableBackAndSettingButton:YES];
            self.pomoCycle.pomoStatus = BREAK;
            //[self updateCountDownLabel];
        }
    }
    else if([theAlert.title  isEqual: @"Pomo Done"]){
        [self.controlButton setTitle:@"break" forState:UIControlStateNormal];
        [self enableBackAndSettingButton:NO];
        self.pomoCycle.pomoStatus = RECESS;
        [self updateTitleAndBackground];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomoDone:) name:PomoDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCountDownLabel) name:SecondTickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextCycle:) name:RecessOverNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomoReady:) name:PomoCycleReadyNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewInitilize{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGPoint center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    
    _progressPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_red"]];
    _progressPoint.contentMode = UIViewContentModeScaleAspectFill;
    CGSize pointSize = _progressPoint.bounds.size;
    float height = (MIN(bounds.size.width, bounds.size.height))*3.0/7.0;
    float heightOffset =(MIN(bounds.size.width, bounds.size.height))*2.0/100.0;
    _progressPoint.frame = CGRectMake(center.x-pointSize.width/2.0, center.y-height+heightOffset, pointSize.width, height-heightOffset);
    _progressPoint.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _progressPoint.frame = CGRectMake(center.x-pointSize.width/2.0, center.y-height+heightOffset, pointSize.width, height-heightOffset);
   // _progressPoint.backgroundColor = [UIColor redColor];
    [self.view addSubview:_progressPoint];
    
    _startPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_black"]];
    _startPoint.contentMode = UIViewContentModeScaleAspectFill;
    _startPoint.frame = CGRectMake(center.x-pointSize.width/2.0, center.y-height+heightOffset, pointSize.width, height);
    //_startPoint.backgroundColor = [UIColor redColor];
    [self.view addSubview:_startPoint];
    
    _taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(center.x - height,(bounds.size.height- bounds.size.width)/3.0, height*2.0, 30)];
    _taskNameLabel.text=@"title";
    _taskNameLabel.textAlignment=NSTextAlignmentCenter;
    _taskNameLabel.font=[UIFont systemFontOfSize:30.0];
    [self.view addSubview:_taskNameLabel];
    
    _consumedPomoLabel = [[UILabel alloc] initWithFrame:CGRectMake(center.x/6.0, center.y + height+(bounds.size.height- bounds.size.width)/8.0, center.x*2.0/3.0, 25)];
    _consumedPomoLabel.text=@"Consumed: 0";
    _consumedPomoLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_consumedPomoLabel];
    
    _estimatedPomoLabel = [[UILabel alloc] initWithFrame:CGRectMake(center.x*7.0/6.0, center.y + height+(bounds.size.height- bounds.size.width)/8.0, center.x*2.0/3.0, 25)];
    _estimatedPomoLabel.text=@"Esitmated: 0";
    _estimatedPomoLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_estimatedPomoLabel];
    
    _controlButton = [[UIButton alloc] initWithFrame:CGRectMake(center.x*5.0/6.0,center.y + height+(bounds.size.height- bounds.size.width)/4.0, center.x/3.0, 25)];
    [_controlButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_controlButton addTarget:self action:@selector(pressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_controlButton];
    
    
    float timeLabelHeight = (MIN(bounds.size.width, bounds.size.height))*9.0/40;
    float timeLabelWidth = (MIN(bounds.size.width, bounds.size.height))*12.0/40;
    _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(center.x - timeLabelWidth, center.y - timeLabelHeight, timeLabelWidth*2.0, timeLabelHeight*2.0)];
    _countDownLabel.text=@"25:00";
    _countDownLabel.textAlignment=NSTextAlignmentCenter;
    _countDownLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _countDownLabel.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    _countDownLabel.font=[UIFont systemFontOfSize:80.0];
    [self.view addSubview:_countDownLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)pomoReady:(NSNotification *)notification
{
    [self updateCountDownLabel];
    [self updatePomoLabel];
    [self updateButton];
    [self updateTitleAndBackground];

}

- (void)pomoDone:(NSNotification *)notification {
    // self.pomoCycle.pomoStatus = DONE;
    if (self.confirmBreakAlertView) {
        [self.confirmBreakAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    //http://iphonedevwiki.net/index.php/AudioServices
    AudioServicesPlayAlertSound(1005);
    
    [self enableBackAndSettingButton:YES];
    
    self.pomoCycle.pomo.endTime = [[NSDate alloc] initWithTimeInterval:self.pomoCycle.durationTimeInSecond sinceDate:self.pomoCycle.pomo.startTime];
    self.pomoCycle.bindTask.consumedPomo+=1;
    self.pomoCycle.pomo.isPartial = NO;
    [self.task addPomosObject:self.pomoCycle.pomo];
    self.pomoCycle.pomo=nil;

    
    [self updateCountDownLabel];
    [self updatePomoLabel];
    [self updateButton];
    [self updateTitleAndBackground];
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Pomo Done"
                                                       message:@"time to take a break"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

- (void)nextCycle:(NSNotification *)notification {
    //self.pomoCycle.pomoStatus = READY;
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    //http://iphonedevwiki.net/index.php/AudioServices
    AudioServicesPlayAlertSound(1005);
    
    [self enableBackAndSettingButton:YES];
    
    [self updateCountDownLabel];
    [self updatePomoLabel];
    [self updateButton];
    [self updateTitleAndBackground];
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Recess Over"
                                                       message:@"please start next PomoCycle"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

- (void)updateCountDownLabel {
    
    NSInteger leftMinutes = self.pomoCycle.pomoLeftTimeInSecond/60;
    NSInteger leftSeconds = self.pomoCycle.pomoLeftTimeInSecond-leftMinutes*60;
    
    if (leftSeconds<10) {
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld:0%ld", (long)leftMinutes, (long)leftSeconds];
    }
    else {
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld:%ld", (long)leftMinutes, (long)leftSeconds];
    }
    
    float unitValue = (float)self.pomoCycle.pomoLeftTimeInSecond/(float)self.pomoCycle.durationTimeInSecond;
   
    float currentAngle = - unitValue * M_PI *2;
    CATransform3D rotationTransform = CATransform3DMakeRotation(currentAngle, 0.0, 0.0, 1.0);
    _progressPoint.layer.transform = rotationTransform;
}

-(void)updatePomoLabel{
    self.taskNameLabel.text = self.task.taskName;
    self.consumedPomoLabel.text = [NSString stringWithFormat:@"Consumed: %ld", (long)self.task.consumedPomo];
    self.estimatedPomoLabel.text = [NSString stringWithFormat:@"Estimated: %ld", (long)self.task.estimatedPomo];
}

- (void)updateButton {
    if (self.pomoCycle.pomoStatus==READY || self.pomoCycle.pomoStatus == DONE) {
        [self.controlButton setTitle:@"start" forState:UIControlStateNormal];
    }else{
        [self.controlButton setTitle:@"break" forState:UIControlStateNormal];
    }
    
}

-(void)updateTitleAndBackground{
    switch (self.pomoCycle.pomoStatus) {
        case READY:
            self.title = @"READY";
            self.view.backgroundColor = [UIColor greenColor];
            break;
        case FOCUS:
            self.title = @"FOCUS";
            self.view.backgroundColor = [UIColor blueColor];
            break;
        case DONE:
            self.title = @"DONE";
            self.view.backgroundColor = [UIColor greenColor];
            break;
        case RECESS:
            self.title = @"RECESS";
            self.view.backgroundColor = [UIColor grayColor];
            break;
        default:
            break;
    }
    [self.view setNeedsDisplay];
}


-(void)creatPomo{
    if (!self.pomoCycle.pomo) {
        self.pomoCycle.pomo = (Pomo *)[NSEntityDescription insertNewObjectForEntityForName:@"Pomo" inManagedObjectContext:self.managedObjectContext];
        NSLog(@"create a new Pomo");
    }
    //self.pomoCycle.pomo=self.pomo;
    self.pomoCycle.pomo.PomoTask=self.pomoCycle.bindTask;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    self.pomoCycle.pomo.date = [dateFormatter stringFromDate:[NSDate date]];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(IBAction)pressButtonAction:(id)sender
{
    switch (self.pomoCycle.pomoStatus) {
        case READY:
            [self.controlButton setTitle:@"break" forState:UIControlStateNormal];
            [self enableBackAndSettingButton:NO];
            [self creatPomo];
            self.pomoCycle.pomo.startTime = [NSDate date];
            self.pomoCycle.pomoStatus = FOCUS;
            break;
        case FOCUS:
            [self showConfirmBreakAlert];
            //self.pomoCycle.pomo.endTime = [NSDate date];
            //self.pomoCycle.bindTask.interruptedPomo+=1;
            //self.pomoCycle.pomo.isPartial = [NSNumber numberWithInt:1 ];
            //[self.pomoCycle.bindTask addPomosObject:self.pomoCycle.pomo];
            //[self enableBackAndSettingButton:YES];
            //self.pomoCycle.pomo =nil;
            break;
        case RECESS:
            [self.controlButton setTitle:@"start" forState:UIControlStateNormal];
            [self enableBackAndSettingButton:YES];
            self.pomoCycle.pomoStatus = BREAK;
            [self updateCountDownLabel];
            break;
        case DONE:
            [self.controlButton setTitle:@"break" forState:UIControlStateNormal];
            [self enableBackAndSettingButton:NO];
            self.pomoCycle.pomoStatus = RECESS;
            break;
            
        default:
            
            break;
    }
    [self updateTitleAndBackground];
}

-(void)enableBackAndSettingButton:(BOOL)setting{
    self.backToDoButton.enabled = setting;
    self.goToSettingButton.enabled = setting;
}


- (IBAction)unwindFromSetting:(UIStoryboardSegue *)segue{
    
}

-(void)showConfirmBreakAlert{
    NSString *alertMessage = [NSString stringWithFormat:@"Break current foucs pomo?"];
    self.confirmBreakAlertView = [[UIAlertView alloc] initWithTitle:@"Break Confirm"
                                                       message:alertMessage
                                                      delegate:self
                                             cancelButtonTitle:@"cancel"
                                             otherButtonTitles:nil];
    [self.confirmBreakAlertView addButtonWithTitle:@"YES"];
    [self.confirmBreakAlertView show];
}


@end
