//
//  NSManagedObjectContext+LastModifyDate.h
//  PomoTask
//
//  Created by Ying on 3/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (LastModifyDate)

-(void)setLastModifyDate: (NSDate*)lastModifyDate;
-(NSDate*)lastModifyDate;

@end
