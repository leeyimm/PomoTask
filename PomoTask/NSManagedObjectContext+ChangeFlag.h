//
//  NSManagedObjectContext+ChangeFlag.h
//  PomoTask
//
//  Created by Ying on 3/7/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ChangeFlag)

-(void)setManagedObjectContextChanged:(BOOL)managedObjectContextChanged;
-(BOOL)managedObjectContextChanged;

@end
