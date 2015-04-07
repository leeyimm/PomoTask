//
//  AppDelegate.m
//  PomoTask
//
//  Created by Ying on 2/5/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "AppDelegate.h"
#import "PomoCycle.h"
#import "PomoHistroyListViewController.h"
#import "PomoToDoListViewController.h"
#import "PomoStatisticsViewController.h"
#import "NSManagedObjectContext+LastModifyDate.h"
#import "Utility.h"
#import "CreatTestTaskAndPomo.h"

static NSString *kEnterBackgroundDateKey = @"EnterBackgroundDate";

@interface AppDelegate ()

@property (nonatomic,strong) UILocalNotification* notification;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSDate *backgroundDate;
@property (weak, nonatomic) UITabBarController *tabBarController;
@property (weak, nonatomic) UINavigationController *historyNavController;
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController;
@synthesize historyNavController = _historyNavController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
    
    
    _historyNavController = [storyboard instantiateViewControllerWithIdentifier:@"History nav controller"];
    
    PomoHistroyListViewController *historyViewController =
    (PomoHistroyListViewController *)[_historyNavController topViewController];
    historyViewController.managedObjectContext = self.managedObjectContext;
    historyViewController.tabBarItem.image = [UIImage imageNamed:@"completed.png"];
    historyViewController.tabBarItem.title = @"Completed";
    //dataSource = [[ElementsSortedByNameDataSource alloc] init];
    //viewController.dataSource = dataSource;
    
    [viewControllers addObject:_historyNavController];
    
    UINavigationController *todayNavController = [storyboard instantiateViewControllerWithIdentifier:@"Today nav controller"];
    PomoToDoListViewController *todayViewController = (PomoToDoListViewController *)[todayNavController topViewController];
    //dataSource = [[ElementsSortedByNameDataSource alloc] init];
    //viewController.dataSource = dataSource;
    todayViewController.managedObjectContext = self.managedObjectContext;
    todayViewController.tabBarItem.image = [UIImage imageNamed:@"todo.png"];
    todayViewController.tabBarItem.title = @"Today";
    [viewControllers addObject:todayNavController];
    
    UINavigationController *statisticsNavController = [storyboard instantiateViewControllerWithIdentifier:@"Statistics nav controller"];
    PomoStatisticsViewController *statisticsViewController = (PomoStatisticsViewController *)[statisticsNavController topViewController];
    statisticsViewController.managedObjectContext = self.managedObjectContext;
    statisticsViewController.tabBarItem.image = [UIImage imageNamed:@"statistics.png"];
    statisticsViewController.tabBarItem.title = @"Statistics";
    
    [viewControllers addObject:statisticsNavController];
    
    
    _tabBarController.viewControllers = viewControllers;
    _tabBarController.selectedViewController = todayNavController;
    
    //time interval default value
    
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:25], @"FocusTimeInterval", [NSNumber numberWithInt:5], @"RecessTimeInterval", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    //add for test
    //[CreatTestTaskAndPomo createObjectForTest:self.managedObjectContext];
    //[self saveContext];
        
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *notifySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notifySettings];
    
    self.notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (self.notification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    self.backgroundDate = [NSDate date];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.backgroundDate = [NSDate date];
    
    PomoCycle *pomoCycle = [PomoCycle sharedPomoCycle];
    [pomoCycle.pomodoroTimer invalidate];
    pomoCycle.pomodoroTimer=nil;
    //NSLog(@"%ld seconds left when enter background", pomoCycle.pomoLeftTimeInSecond);
    if (pomoCycle.pomoStatus == FOCUS || pomoCycle.pomoStatus==RECESS) {
        
        
        self.notification = [[UILocalNotification alloc] init];
        self.notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:pomoCycle.pomoLeftTimeInSecond];
        self.notification.alertBody = [NSString stringWithFormat:@"Pomo time is over"];
        self.notification.soundName = UILocalNotificationDefaultSoundName;
        self.notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    PomoCycle *pomoCycle = [PomoCycle sharedPomoCycle];
    //NSLog(@"%ld seconds remain when back to foreground", pomoCycle.pomoLeftTimeInSecond);
    if (pomoCycle.pomoStatus == FOCUS || pomoCycle.pomoStatus==RECESS) {
        NSInteger timeGap = [[NSDate date] timeIntervalSinceDate:self.backgroundDate];
        if (timeGap<pomoCycle.pomoLeftTimeInSecond) {
            pomoCycle.pomoLeftTimeInSecond= pomoCycle.pomoLeftTimeInSecond-timeGap;
            pomoCycle.pomoStatus = pomoCycle.pomoStatus;
        }else
            pomoCycle.pomoStatus = DONE;
    }
    
    if ([Utility checkCrossDay:self.backgroundDate]) {
        _tabBarController.selectedViewController = _historyNavController;
    }
    
    if (self.notification) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        application.applicationIconBadgeNumber=0;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    PomoCycle *pomoCycle = [PomoCycle sharedPomoCycle];
    if (pomoCycle.pomoStatus == FOCUS) {
        pomoCycle.pomo.endTime = [NSDate date];
        pomoCycle.bindTask.interruptedPomo+=1;
        pomoCycle.pomo.isPartial = YES;
        [pomoCycle.bindTask addPomosObject:pomoCycle.pomo];
        pomoCycle.pomo =nil;
    }

    [self saveContext];
    
    [[UIApplication sharedApplication]  cancelAllLocalNotifications];
    application.applicationIconBadgeNumber=0;
    
    
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PomoModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppData.PomoModel"];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Allow inferred migration from the original version of the application.
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
