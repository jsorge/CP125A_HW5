//
//  JMSPersonStore.h
//  HW5
//
//  Created by Jared Sorge on 2/14/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSPersonStore : NSObject

@property (strong, nonatomic)NSMutableArray *people;

#pragma mark - API
/**
 *  Sorts the people array in ascending order of the remaining days until someone's birthday
 */
- (void)sortBirthdaysInAscendingDaysRemaing;

/**
 *  Sorts the people array in descending order of the remaining days until someone's birthday
 */
- (void)sortBirthdaysInDescendingDaysRemaing;

/**
 *  Removes the object from the people array at the given index
 *
 *  @param index The index of the object to be removed
 */
- (void)removePersonAtIndex:(NSInteger)index;

@end
