//
//  PomoStatisticsViewController.m
//  PomoTask
//
//  Created by Ying on 2/10/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoStatisticsViewController.h"
#import "Pomo.h"
#import "PomoOfDayViewCell.h"
#import "PomoOfDayViewController.h"

@interface PomoStatisticsViewController ()

@property  (nonatomic) NSMutableArray *pomos;

@property (nonatomic) NSMutableArray *dates;
@property  (nonatomic) NSDate *lastRetrieveDate;

@end

@implementation PomoStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self retrivePomos];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[self.managedObjectContext lastModifyDate] isEqualToDate:self.lastRetrieveDate]||self.managedObjectContext.hasChanges)
    {
        [self.managedObjectContext save:nil];
        self.lastRetrieveDate = [NSDate date];
        [self.managedObjectContext setLastModifyDate:self.lastRetrieveDate];
        [self retrivePomos];
        [self.tableView reloadData];
    }
    //NSLog(@"view will appear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //NSLog(@"view will disappear");
}

- (void)retrivePomos{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Pomo"];
    [request setFetchBatchSize:20];
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completedDate<%@", [Utility beginningOfDay]];
    //    [request setPredicate:predicate];
    
    // Order the events by creation date, most recent first.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Execute the fetch.
    NSError *error;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Set self's events array to a mutable copy of the fetch results.
    [self setPomos:[fetchResults mutableCopy]];
    
    self.dates = [[NSMutableArray alloc] init];
    
    for (Pomo* pomo in self.pomos) {
        if (![self.dates containsObject:pomo.date]) {
            [self.dates addObject:pomo.date];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.dates count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PomoOfDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pomo of day cell" forIndexPath:indexPath];
    int fullPomoCount = 0;
    int partialPomoCount =0;
    for (Pomo *pomo in self.pomos) {
        if ([pomo.date isEqualToString:self.dates[indexPath.row]]) {
            if (pomo.isPartial == NO ) {
                fullPomoCount+=1;
            }else{
                partialPomoCount+=1;
            }
        }
    }
    
    cell.dateLabel.text  = self.dates[indexPath.row];
    cell.completedPomoLabel.text = [NSString stringWithFormat:@"Full: %d", fullPomoCount];
    cell.interruptedPomoLabel.text = [NSString stringWithFormat:@"Partial: %d", partialPomoCount];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Pomo table delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"show pomos of day" sender:indexPath];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show pomos of day"])
    {
        UINavigationController *pomosOfDayNavViewController = (UINavigationController*)segue.destinationViewController;
        PomoOfDayViewController *pomosOfDayViewController = (PomoOfDayViewController*)pomosOfDayNavViewController.topViewController;
       // NSMutableArray *filteredPomos = [self.pomos copy];
        
        // = self.pomos;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        pomosOfDayViewController.date = self.dates[indexPath.row];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date isEqualToString:%@",self.dates[indexPath.row]];
        NSArray *filteredPomos =[self.pomos filteredArrayUsingPredicate:predicate];
        pomosOfDayViewController.pomos = filteredPomos;
    }
}

- (IBAction)unwindFromPomosOfDay:(UIStoryboardSegue *)segue{
    [self.tableView reloadData];

}

@end
