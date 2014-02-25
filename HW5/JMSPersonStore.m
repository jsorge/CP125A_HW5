//
//  JMSPersonStore.m
//  HW5
//
//  Created by Jared Sorge on 2/14/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSPersonStore.h"
#import "Person.h"
#import "JMSPersonLoader.h"

@interface JMSPersonStore ()

@property (strong, nonatomic)NSDateFormatter *dateFormatter;

@end

@implementation JMSPersonStore
- (instancetype)init
{
    self = [super init];
    if (self) {
        _loader = [[JMSPersonLoader alloc] init];
    }
    return self;
}

#pragma mark - Properties
- (NSFetchedResultsController *)people
{
    if (!_people) {
        _people = [Person MR_fetchAllSortedBy:@"birthdate"
                                    ascending:YES
                                withPredicate:nil
                                      groupBy:nil
                                     delegate:nil];
        
        if ([_people.fetchedObjects count] == 0) {
            [self.loader start];
        }
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
    NSFetchRequest *fetchRequest = self.people.fetchRequest;
    NSSortDescriptor *newSort = [NSSortDescriptor sortDescriptorWithKey:@"daysUntilNextBirthday" ascending:YES];
    
    fetchRequest.sortDescriptors = @[newSort];
    
    NSError *error;
    [self.people performFetch:&error];
}

- (void)sortBirthdaysInDescendingDaysRemaing
{
    NSFetchRequest *fetchRequest = self.people.fetchRequest;
    NSSortDescriptor *newSort = [NSSortDescriptor sortDescriptorWithKey:@"daysUntilNextBirthday" ascending:NO];
    
    fetchRequest.sortDescriptors = @[newSort];
    
    NSError *error;
    [self.people performFetch:&error];
}

- (void)removePersonAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    Person *person = [self.people objectAtIndexPath:indexPath];
    [person MR_deleteEntity];
}

@end
