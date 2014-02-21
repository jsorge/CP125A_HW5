//
//  JMSPersonStore.h
//  HW5
//
//  Created by Jared Sorge on 2/14/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSPersonStore : NSObject

//@property (strong, nonatomic)NSMutableArray *people;
@property (strong, nonatomic)NSFetchedResultsController *people;

#pragma mark - API
- (void)sortBirthdaysInAscendingDaysRemaing;
- (void)sortBirthdaysInDescendingDaysRemaing;
- (void)removePersonAtIndex:(NSInteger)index;

@end
