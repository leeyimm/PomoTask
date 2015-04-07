//
//  PomoOfDayViewController.m
//  PomoTask
//
//  Created by Ying on 3/3/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoOfDayViewController.h"
#import "PomoInPomosOfDayViewCell.h"
#import "Pomo.h"
#import "PomoTask.h"

@interface PomoOfDayViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *dateStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *partialPomoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFoucsTimeLabel;

@property (weak, nonatomic) IBOutlet UITableView *pomosOfDayTable;

@end

@implementation PomoOfDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateStringLabel.text = self.date;
    self.pomosOfDayTable.dataSource = self;
    int fullPomoCount = 0;
    int partialPomoCount =0;
    NSTimeInterval timeInterval = 0;
    for (Pomo *pomo in self.pomos) {
        timeInterval += [pomo.endTime timeIntervalSinceDate:pomo.startTime];
        
        if (pomo.isPartial == NO) {
            fullPomoCount+=1;
        }else{
            partialPomoCount+=1;
        }
    }
    
    self.totalFoucsTimeLabel.text = [NSString stringWithFormat:@"Total Foucs Time: %dh%dm",(int)timeInterval/60/60, (int)timeInterval/60%60];
    self.fullPomoLabel.text = [NSString stringWithFormat:@" %d", fullPomoCount];
    self.partialPomoLabel.text = [NSString stringWithFormat:@" %d", partialPomoCount];
    
    
    [self.pomosOfDayTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Pomo table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pomos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PomoInPomosOfDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pomo detail cell" forIndexPath:indexPath];
    
    Pomo *pomo = self.pomos[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *startTimeString = [dateFormatter stringFromDate:pomo.startTime];
    NSString *endTimeString = [dateFormatter stringFromDate:pomo.endTime];
    
    //[dateFormatter setDateFormat:@"MM-dd"];
    //NSString *dueDateString = [dateFormatter stringFromDate:task.dueDate];
    if (pomo.isPartial == YES) {
        cell.pomoImage.image = [UIImage imageNamed:@"Pomodoro_Interrupted.png"];
    }else
    {
        cell.pomoImage.image = [UIImage imageNamed:@"Pomodoro_Done.png"];
    }
    cell.pomoTaskNameLabel.text = pomo.pomoTask.taskName;
    cell.pomoTimeDetailLabel.text = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    
    
    // Configure the cell...
    
    return cell;
}



@end
