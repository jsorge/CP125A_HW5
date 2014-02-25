//
//  Person.m
//  HW5
//
//  Created by Jared Sorge on 2/22/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "Person.h"
#import "NSDate+UWDateMath.h"


@implementation Person

@dynamic birthdate;
@dynamic name;
@dynamic daysUntilNextBirthday;

- (NSNumber *)daysUntilNextBirthday
{
    return @([self.birthdate daysUntilNextOccurrence]);
}

@end
