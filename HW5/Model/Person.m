//
//  Person.m
//  HW5
//
//  Created by Jared Sorge on 2/21/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "Person.h"
#import "NSDate+UWDateMath.h"

@implementation Person

@dynamic name;
@dynamic birthdate;

//Custom
- (NSInteger)daysUntilNextBirthday
{
    return [self.birthdate daysUntilNextOccurrence];
}

@end
