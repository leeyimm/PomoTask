//
//  AddPoTaskViewController.m
//  PomoTask
//
//  Created by Ying on 2/5/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "AddPoTaskViewController.h"

@interface AddPoTaskViewController () <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *estimatedTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

@property NSInteger valueInEstimatedTimePicker;

@end

@implementation AddPoTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.valueInEstimatedTimePicker = 5;
    
    [self.estimatedTimePicker selectRow:self.valueInEstimatedTimePicker-1 inComponent:0 animated:NO];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender !=self.saveButton) {
        return;
    }
    NSDate *dueDate = self.dueDatePicker.date;
    if (self.taskNameTextField.text.length>0) {
        self.taskToBeAdd = (PomoTask *)[NSEntityDescription insertNewObjectForEntityForName:@"PomoTask" inManagedObjectContext:self.managedObjectContext];
        self.taskToBeAdd.taskName = self.taskNameTextField.text;
        self.taskToBeAdd.estimatedPomo=self.valueInEstimatedTimePicker;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        self.taskToBeAdd.dueDate = [dateFormatter stringFromDate:dueDate];
        self.taskToBeAdd.createdTime = [NSDate date];
        self.taskToBeAdd.status = [NSNumber numberWithInt:STATUS_PENDING]; 
        self.taskToBeAdd.priority = 0;//default priority
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 12;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)row+1]] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.valueInEstimatedTimePicker = row+1;
}
@end
