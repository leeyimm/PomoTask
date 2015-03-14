//
//  PomoToDoListViewController.m
//  PomoTask
//
//  Created by Ying on 2/5/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PomoToDoListViewController.h"
#import "PomoTask.h"
#import "AddPoTaskViewController.h"
#import "PomoToDoListViewCell.h"
#import "PomoCycleViewController.h"
#import "PomoCycle.h"
#import "Utility.h"

@interface PomoToDoListViewController () <UIActionSheetDelegate>

@property  (nonatomic) NSMutableArray* toDoTasks;

@property  (nonatomic) NSMutableArray* toDoTodayTasks;
@property  (nonatomic) NSMutableArray* pendingTasks;
@property  (nonatomic) NSMutableArray* completedTodayTasks;
@property  (nonatomic) NSDate* viewLastLoadedDate;


@end

@implementation PomoToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self retrieveToDoTask];
    
    self.viewLastLoadedDate = [NSDate date];
    
    //self.toDoTasks = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Utility checkCrossDay:self.viewLastLoadedDate]){
        [self retrieveToDoTask];
        self.viewLastLoadedDate = [NSDate date];
    }
    
    [self.tableView reloadData];
    [self.managedObjectContext setManagedObjectContextChanged:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView endEditing:YES];
    
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
        [self.managedObjectContext setManagedObjectContextChanged:YES];
    }
    //NSLog(@"ToDoList will disapper");
}


-(void)retrieveToDoTask
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PomoTask"];
    [request setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status != %@)||(completedDate>%@)", [NSNumber numberWithInt:STATUS_COMPLETED], [Utility beginningOfDay]];
    [request setPredicate:predicate];
    
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
    [self setToDoTasks:[fetchResults mutableCopy]];
    
    //todotoday tasks
    
    NSPredicate *toDoTodayPredicate = [NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:STATUS_TODOTODAY]];
    
    self.toDoTodayTasks = [[self.toDoTasks filteredArrayUsingPredicate:toDoTodayPredicate] mutableCopy];
    
    //pending tasks
    
    NSPredicate *pendingTaskPredicate = [NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:STATUS_PENDING]];
    
    self.pendingTasks = [[self.toDoTasks filteredArrayUsingPredicate:pendingTaskPredicate] mutableCopy];
    
    //completed tasks
    
    NSPredicate *completedTodayPredicate = [NSPredicate predicateWithFormat:@"status == %@", [NSNumber numberWithInt:STATUS_COMPLETED]];
    
    self.completedTodayTasks = [[self.toDoTasks filteredArrayUsingPredicate:completedTodayPredicate] mutableCopy];
    
    [self sortTasks];
    
}

-(void)sortTasks
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    self.toDoTodayTasks = [[self.toDoTodayTasks sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:YES];
    sortDescriptors = @[sortDescriptor];
    
    self.pendingTasks = [[self.pendingTasks sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completedDate" ascending:YES];
    sortDescriptors = @[sortDescriptor];
    
    self.completedTodayTasks = [[self.completedTodayTasks sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    switch (section) {
        case SECTION_TODOTODAY:
            sectionTitle = [NSString stringWithFormat:@"ToDoToday"];
            break;
        case SECTION_PENDING:
            sectionTitle = [NSString stringWithFormat:@"Pending Tasks"];
            break;
        case SECTION_COMPLETED:
            sectionTitle = [NSString stringWithFormat:@"Completed Today"];
            break;
            
        default:
            break;
    }
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger sectionCount = 0;
    switch (section) {
        case SECTION_TODOTODAY:
            sectionCount = [self.toDoTodayTasks count];
            break;
        case SECTION_PENDING:
            sectionCount = [self.pendingTasks count];
            break;
        case SECTION_COMPLETED:
            sectionCount = [self.completedTodayTasks count];
            break;
            
        default:
            break;
    }
    return sectionCount;
}

- (IBAction)unwindFromAdd:(UIStoryboardSegue *)segue
{
    
    AddPoTaskViewController *source = [segue sourceViewController];
    PomoTask *item = source.taskToBeAdd;
    if (item!=nil) {

        [self.pendingTasks addObject:item];
        [self.tableView reloadData];
    }

}

- (IBAction)unwindFromPomo:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PomoToDoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListViewCell" forIndexPath:indexPath];
    PomoTask* task;
    switch (indexPath.section) {
        case SECTION_TODOTODAY:
            task = self.toDoTodayTasks[indexPath.row];
            break;
        case SECTION_PENDING:
            task = self.pendingTasks[indexPath.row];
            break;
        case SECTION_COMPLETED:
            task = self.completedTodayTasks[indexPath.row];
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *createdDateString = [dateFormatter stringFromDate:task.createdTime];
    
    //[dateFormatter setDateFormat:@"MM-dd"];
    //NSString *dueDateString = [dateFormatter stringFromDate:task.dueDate];
    cell.taskNameLabel.text = task.taskName;
    cell.taskCreatedDateLabel.text = [NSString stringWithFormat:@"created at %@", createdDateString];
    cell.taskDueDateLabel.text = [NSString stringWithFormat:@"due %@", task.dueDate];
    
    
    
    cell.estimatedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.estimatedPomo];
    cell.consumedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.consumedPomo];
    cell.interruptedPomoLabel.text = [NSString stringWithFormat:@"%ld", (long)task.interruptedPomo];
    
    
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView endEditing:YES];
        
        PomoTask* task;
        switch (indexPath.section) {
            case SECTION_TODOTODAY:
                task = self.toDoTodayTasks[indexPath.row];
                [self.toDoTodayTasks removeObjectAtIndex:indexPath.row];
                break;
            case SECTION_PENDING:
                task = self.pendingTasks[indexPath.row];
                [self.pendingTasks removeObjectAtIndex:indexPath.row];
                break;
            case SECTION_COMPLETED:
                task = self.completedTodayTasks[indexPath.row];
                [self.completedTodayTasks removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        [self.managedObjectContext deleteObject:task];
        
        for (Pomo *pomo in task.pomos) {
            [self.managedObjectContext deleteObject:pomo];
        }

        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.managedObjectContext setManagedObjectContextChanged:YES];
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    PomoTask *task;
    if (fromIndexPath.section == toIndexPath.section) {
        if (fromIndexPath.section == SECTION_TODOTODAY) {
            task = self.toDoTodayTasks[fromIndexPath.row];
            [self.toDoTodayTasks removeObject:task];
            [self insertTaskInToDoToday:task AtIndex:toIndexPath.row];
        }
    }
    else
    {
        switch (fromIndexPath.section) {
            case SECTION_PENDING: //from pending
                task = self.pendingTasks[fromIndexPath.row];
                switch (toIndexPath.section) {
                    case SECTION_TODOTODAY: //to toDoToday
                        task.status = [NSNumber numberWithInt:STATUS_TODOTODAY];
                        [self insertTaskInToDoToday:task AtIndex:toIndexPath.row];
                        [self.pendingTasks removeObject:task];
                        break;
                        //case 2:
                        //    task.status = [NSNumber numberWithInt:2];
                        //    task.completedDate = [NSDate date];
                        //    [self.completedTodayTasks addObject:task];
                        //    [self.pendingTasks removeObject:task];
                        //   break;
                    default:
                        break;
                }
                break;
            case SECTION_TODOTODAY: //from toDoToday
                task = self.toDoTodayTasks[fromIndexPath.row];
                switch (toIndexPath.section) {
                    case SECTION_PENDING:  //to pending
                        task.status = [NSNumber numberWithInt:STATUS_PENDING];
                        [self.pendingTasks addObject:task];
                        [self.toDoTodayTasks removeObject:task];
                        break;
                    case SECTION_COMPLETED: //to complete
                        task.status = [NSNumber numberWithInt:STATUS_COMPLETED];
                        task.completedDate = [NSDate date];
                        [self.completedTodayTasks addObject:task];
                        [self.toDoTodayTasks removeObject:task];
                        break;
                    default:
                        break;
                }
                break;
            case SECTION_COMPLETED: //from completed
                task = self.completedTodayTasks[fromIndexPath.row];
                switch (toIndexPath.section) {
                    case SECTION_TODOTODAY: //toDoToday
                        task.status = [NSNumber numberWithInt:STATUS_TODOTODAY];
                        task.completedDate = nil;
                        [self insertTaskInToDoToday:task AtIndex:toIndexPath.row];
                        [self.completedTodayTasks removeObject:task];
                        break;
                    case SECTION_PENDING: //pending
                        task.status = [NSNumber numberWithInt:STATUS_PENDING];
                        task.completedDate = nil;
                        [self.pendingTasks addObject:task];
                        [self.completedTodayTasks removeObject:task];
                        break;
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    }
    [self sortTasks];
    [tableView reloadData];
}

-(void)insertTaskInToDoToday:(PomoTask*) task AtIndex:(NSInteger) atIndex{
    
    [self.toDoTodayTasks insertObject:task atIndex:atIndex];
    for (int index =0; index<[self.toDoTodayTasks count]; index++)
    {
        task = self.toDoTodayTasks[index];
        task.priority = index;
    }
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTask"])
    {
        UINavigationController *addNavViewController = (UINavigationController*)segue.destinationViewController;
        AddPoTaskViewController *addPoTaskViewController = (AddPoTaskViewController*)addNavViewController.topViewController;
        addPoTaskViewController.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.identifier isEqualToString:@"PomoCycle"]) {
        UINavigationController *pomoNavViewController = (UINavigationController*)segue.destinationViewController;
        PomoCycleViewController *pomoCycleViewController = (PomoCycleViewController*)pomoNavViewController.topViewController;
        pomoCycleViewController.task = self.toDoTasks[[self.tableView indexPathForSelectedRow].row];
        pomoCycleViewController.managedObjectContext = self.managedObjectContext;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==SECTION_PENDING ||indexPath.section ==SECTION_COMPLETED) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *pomoNavViewController = [storyboard instantiateViewControllerWithIdentifier:@"Pomo nav controller"];
    PomoCycleViewController *pomoCycleViewController = (PomoCycleViewController *)[pomoNavViewController topViewController];
    pomoCycleViewController.task = self.toDoTodayTasks[[self.tableView indexPathForSelectedRow].row];
    pomoCycleViewController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController presentViewController:pomoNavViewController animated:YES completion:nil];
}







@end
