//
//  NSManagedObjectContext+LastModifyDate.m
//  PomoTask
//
//  Created by Ying on 3/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "NSManagedObjectContext+LastModifyDate.h"

static NSDate *NSManagedObjectContextLastModifyDate;

@implementation NSManagedObjectContext (LastModifyDate)

-(void)setLastModifyDate: (NSDate*)lastModifyDate;
{
    NSManagedObjectContextLastModifyDate = lastModifyDate;
}
-(NSDate*)lastModifyDate
{
    return NSManagedObjectContextLastModifyDate;
}

@end
