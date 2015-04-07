//
//  PomoHistroyListViewController.m
//  PomoTask
//
//  Created by Ying on 2/10/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoHistroyListViewController.h"
#import "PomoTask.h"
#import "PomoToDoListViewCell.h"
#import "TaskDetailViewController.h"
#import "Utility.h"

@interface PomoHistroyListViewController ()

@property  (nonatomic) NSMutableArray* completedTasks;
@property (nonatomic) NSDate *lastRetrieveDate;

@end

@implementation PomoHistroyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retriveCompletedTasks];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[self.managedObjectContext lastModifyDate] isEqualToDate:self.lastRetrieveDate]||self.managedObjectContext.hasChanges)
    {
        [self.managedObjectContext save:nil];
        self.lastRetrieveDate = [NSDate date];
        [self.managedObjectContext setLastModifyDate:self.lastRetrieveDate];
        [self retriveCompletedTasks];
        [self.tableView reloadData];
    }
   // NSLog(@"view will appear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //NSLog(@"view will disappear");
}

-(void)retriveCompletedTasks{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PomoTask"];
    [request setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.completedDate!=%@", nil];
    [request setPredicate:predicate];
    
    // Order the events by creation date, most recent first.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:NO];
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
    [self setCompletedTasks:[fetchResults mutableCopy]];
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
    return [self.completedTasks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PomoToDoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListViewCell" forIndexPath:indexPath];
    
    PomoTask *task = self.completedTasks[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *createdDateString = [dateFormatter stringFromDate:task.createdTime];
    NSString *completedDateString = [dateFormatter stringFromDate:task.completedDate];
    
    //[dateFormatter setDateFormat:@"MM-dd"];
    //NSString *dueDateString = [dateFormatter stringFromDate:task.dueDate];
    cell.taskNameLabel.text = task.taskName;
    cell.taskCreatedDateLabel.text = [NSString stringWithFormat:@"%@ >>>> %@", createdDateString, completedDateString];
    cell.taskDueDateLabel.text = [NSString stringWithFormat:@""];
    
    
    
    cell.estimatedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.estimatedPomo];
    cell.consumedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.consumedPomo];
    cell.interruptedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.interruptedPomo];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (IBAction)unwindFromDetail:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Show Task Detail"])
    {
        UINavigationController *taskDetailNavViewController = (UINavigationController*)segue.destinationViewController;
        TaskDetailViewController *taskDetailViewController = (TaskDetailViewController*)taskDetailNavViewController.topViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        taskDetailViewController.task = self.completedTasks[indexPath.row];
        
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"Show Task Detail" sender:indexPath];
}


@end
