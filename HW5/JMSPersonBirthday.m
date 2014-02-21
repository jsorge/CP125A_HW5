//
//  JMSPersonBirthday.m
//  HW5
//
//  Created by Jared Sorge on 2/11/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSPersonBirthday.h"
#import "NSDate+UWDateMath.h"

@interface JMSPersonBirthday ()

@end

@implementation JMSPersonBirthday

#pragma mark - Properties
- (NSInteger)daysUntilBirthday
{
    return [self.birthdate daysUntilNextOccurrence];
}

#pragma mark - API
- (instancetype)initWithName:(NSString *)name birthdate:(NSDate *)birthdate;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.birthdate = birthdate;
    }
    return self;
}

@end
