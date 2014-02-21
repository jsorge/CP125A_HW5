//
//  NSDate+UWDateMath.m
//  UW-iOS-HW5
//
//  Created by Jake Carter on 2/12/14.
//  Copyright (c) 2014 Carter Made. All rights reserved.
//

#import "NSDate+UWDateMath.h"

@implementation NSDate (UWDateMath)

- (NSInteger)daysUntilNextOccurrence;
{
    // Credit: http://stackoverflow.com/questions/6246727/iphone-method-to-calculate-days-till-next-birthday-not-accurate
    NSDate *now = [NSDate date];
    
    NSDateComponents *year = [[NSDateComponents alloc] init];
    NSInteger yearDiff = 1;
    NSDate *newBirthday = self;
    while([newBirthday earlierDate:now] == newBirthday) {
        [year setYear:yearDiff++];
        newBirthday = [[NSCalendar currentCalendar] dateByAddingComponents:year toDate:self options:0];
    }
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:now toDate:newBirthday options:0];
    
    NSInteger difference = [dateComponents day];
    return difference;
}

@end
