//
//  JMSPersonStore.m
//  HW5
//
//  Created by Jared Sorge on 2/14/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSPersonStore.h"
#import "JMSPersonBirthday.h"

@interface JMSPersonStore ()

@property (strong, nonatomic)NSDateFormatter *dateFormatter;
@property (strong, nonatomic)NSString *currentSortDirection;

@end

@implementation JMSPersonStore
#pragma mark - Properties
- (NSMutableArray *)people
{
    if (!_people) {
        _people = [NSMutableArray array];
        
        JMSPersonBirthday *jared = [[JMSPersonBirthday alloc] initWithName:@"Jared" birthdate:[self.dateFormatter dateFromString:@"01/02/1983"]];
        JMSPersonBirthday *emily = [[JMSPersonBirthday alloc] initWithName:@"Emily" birthdate:[self.dateFormatter dateFromString:@"10/31/1978"]];
        JMSPersonBirthday *atticus = [[JMSPersonBirthday alloc] initWithName:@"Atticus" birthdate:[self.dateFormatter dateFromString:@"12/30/2013"]];
        [_people addObjectsFromArray:@[jared, emily, atticus]];
        
        [self sortBirthdaysInAscendingDaysRemaing];
    }
    return _people;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}

#pragma mark - API
- (void)sortBirthdaysInAscendingDaysRemaing
{
    self.currentSortDirection = @"ASC";
    [self.people sortUsingComparator:^NSComparisonResult(JMSPersonBirthday *person1, JMSPersonBirthday *person2) {
        if (person1.daysUntilBirthday < person2.daysUntilBirthday) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (person1.daysUntilBirthday > person2.daysUntilBirthday) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)sortBirthdaysInDescendingDaysRemaing
{
    self.currentSortDirection = @"DESC";
    [self.people sortUsingComparator:^NSComparisonResult(JMSPersonBirthday *person1, JMSPersonBirthday *person2) {
        if (person1.daysUntilBirthday > person2.daysUntilBirthday) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (person1.daysUntilBirthday < person2.daysUntilBirthday) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)removePersonAtIndex:(NSInteger)index
{
    [self.people removeObjectAtIndex:index];
}

- (void)sortBirthdaysInOrder:(NSString *)order
{
    NSAssert([order isEqualToString:@"ASC"] || [order isEqualToString:@"DESC"], @"The order must be ASC or DESC");
    
    if ([order isEqualToString:@"ASC"]) {
        [self sortBirthdaysInAscendingDaysRemaing];
    } else if ([order isEqualToString:@"DESC"]) {
        [self sortBirthdaysInDescendingDaysRemaing];
    }
}

@end
