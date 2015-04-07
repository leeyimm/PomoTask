//
//  TaskDetailViewController.m
//  PomoTask
//
//  Created by Ying on 2/17/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "PomoInTaskDetailViewCell.h"
#import "Pomo.h"

@interface TaskDetailViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToHistoryButton;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeConsumedLabel;
@property (weak, nonatomic) IBOutlet UIView *estimatedPomoView;
@property (weak, nonatomic) IBOutlet UIView *consumedPomoView;
@property (weak, nonatomic) IBOutlet UIView *interruptedPomoView;
@property (weak, nonatomic) IBOutlet UITableView *pomoDetailTableView;
@property (weak, nonatomic) IBOutlet UILabel *estimatedPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumedPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *interruptedPomoLabel;

@property (strong,nonatomic) NSArray *sortedPomos;


@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = self.backToHistoryButton;
    self.taskNameLabel.text = self.task.taskName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *createdDateString = [dateFormatter stringFromDate:self.task.createdTime];
    NSString *completedDateString = [dateFormatter stringFromDate:self.task.completedDate];
    self.createdTimeLabel.text = [NSString stringWithFormat:@"created at %@", createdDateString];
    self.completedTimeLabel.text = [NSString stringWithFormat:@"completed  %@", completedDateString];
    
    self.estimatedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)self.task.estimatedPomo];
    
    
    self.pomoDetailTableView.dataSource = self;
    NSMutableArray *pomos = [[self.task.pomos allObjects] mutableCopy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.sortedPomos = [pomos sortedArrayUsingDescriptors:descriptors];
    
    int fullPomoCount = 0;
    int partialPomoCount =0;
    NSTimeInterval timeInterval = 0;
    for (Pomo *pomo in self.sortedPomos) {
        timeInterval += [pomo.endTime timeIntervalSinceDate:pomo.startTime];
        
        if (pomo.isPartial == NO) {
            fullPomoCount+=1;
        }else{
            partialPomoCount+=1;
        }
    }
    
    self.timeConsumedLabel.text = [NSString stringWithFormat:@"Total Time Consumed: %dh%dm",(int)timeInterval/60/60, (int)timeInterval/60%60];
    
    self.consumedPomoLabel.text = [NSString stringWithFormat:@"%d", fullPomoCount];
    self.interruptedPomoLabel.text = [NSString stringWithFormat:@"%d", partialPomoCount];
    
    [self.pomoDetailTableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Pomo table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortedPomos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PomoInTaskDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PomoInTaskDetailCell" forIndexPath:indexPath];
    
    Pomo *pomo = self.sortedPomos[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *startTimeString = [dateFormatter stringFromDate:pomo.startTime];
    NSString *endTimeString = [dateFormatter stringFromDate:pomo.endTime];
    
    //[dateFormatter setDateFormat:@"MM-dd"];
    //NSString *dueDateString = [dateFormatter stringFromDate:task.dueDate];
    if (pomo.isPartial == YES) {
        cell.PomoImage.image = [UIImage imageNamed:@"Pomodoro_Interrupted.png"];
    }else
    {
        cell.PomoImage.image = [UIImage imageNamed:@"Pomodoro_Done.png"];
    }
    cell.PomoDetailLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", pomo.date, startTimeString, endTimeString];
    
    
    // Configure the cell...
    
    return cell;
}


@end
