//
//  Person.h
//  HW5
//
//  Created by Jared Sorge on 2/21/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthdate;

//Custom
@property (readonly, nonatomic)NSInteger daysUntilNextBirthday;

@end
