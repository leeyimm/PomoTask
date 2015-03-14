//
//  NSManagedObjectContext+ChangeFlag.m
//  PomoTask
//
//  Created by Ying on 3/7/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "NSManagedObjectContext+ChangeFlag.h"

static BOOL managedContextChanged;

@implementation NSManagedObjectContext (ChangeFlag)


-(void)setManagedObjectContextChanged:(BOOL)managedObjectContextChanged
{
    managedContextChanged=managedObjectContextChanged;
}

-(BOOL)managedObjectContextChanged
{
    return managedContextChanged;
}


@end
