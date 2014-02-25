//
//  JMSPersonStore.h
//  HW5
//
//  Created by Jared Sorge on 2/14/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMSPersonLoader;

@interface JMSPersonStore : NSObject

@property (strong, nonatomic)NSFetchedResultsController *people;
@property (strong, nonatomic)JMSPersonLoader *loader;

#pragma mark - API
- (void)sortBirthdaysInAscendingDaysRemaing;
- (void)sortBirthdaysInDescendingDaysRemaing;
- (void)removePersonAtIndex:(NSInteger)index;

@end
