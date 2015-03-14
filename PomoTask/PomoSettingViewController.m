//
//  PomoSettingViewController.m
//  PomoTask
//
//  Created by Ying on 3/3/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoSettingViewController.h"

@interface PomoSettingViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UISlider *foucsTimeIntervalSlider;
@property (weak, nonatomic) IBOutlet UISlider *recessTimeIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *focusCurrentValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusNewValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *recessCurrentValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *recessNewValueLabel;

@end

@implementation PomoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSInteger foucsTimeInterval = [userDefaultes integerForKey:@"FocusTimeInterval"];
    NSInteger recessTimeInterval = [userDefaultes integerForKey:@"RecessTimeInterval"];
    self.focusCurrentValueLabel.text = [NSString stringWithFormat:@"Current: %ld mins", (long)foucsTimeInterval];
    self.recessCurrentValueLabel.text = [NSString stringWithFormat:@"Current: %ld mins", (long)recessTimeInterval];
    self.focusNewValueLabel.text = [NSString stringWithFormat:@"New: %ld mins", (long)foucsTimeInterval];
    self.recessNewValueLabel.text = [NSString stringWithFormat:@"New: %ld mins", (long)recessTimeInterval];
    self.foucsTimeIntervalSlider.value = foucsTimeInterval;
    self.recessTimeIntervalSlider.value = recessTimeInterval;
    [self.foucsTimeIntervalSlider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.recessTimeIntervalSlider addTarget:self
                                     action:@selector(sliderValueChanged:)
                           forControlEvents:UIControlEventValueChanged];

    
}



-(void)sliderValueChanged:(id)sender
{
    UISlider* control = (UISlider*)sender;
    if(control == self.foucsTimeIntervalSlider){
        self.focusNewValueLabel.text = [NSString stringWithFormat:@"New: %d mins", (int)control.value];
    }else if(control == self.recessTimeIntervalSlider){
        self.recessNewValueLabel.text = [NSString stringWithFormat:@"New: %d mins", (int)control.value];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int newValue = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
    
    if ([keyPath isEqualToString:@"foucsTimeIntervalSlider.value"]) {
        self.focusNewValueLabel.text = [NSString stringWithFormat:@"New: %d mins", newValue];
        NSLog(@"foucs time interval change");
    }else if([keyPath isEqualToString:@"recessTimeIntervalSlider.value"]){
        self.recessNewValueLabel.text = [NSString stringWithFormat:@"New: %d mins", newValue];
        NSLog(@"recess time interval change");        
    }
    [self.view setNeedsDisplay];
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
    if (sender !=self.saveButton) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(int)self.foucsTimeIntervalSlider.value forKey:@"FocusTimeInterval"];
    [userDefaults setInteger:(int)self.recessTimeIntervalSlider.value forKey:@"RecessTimeInterval"];
}


@end
