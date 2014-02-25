//
//  JMSPersonBirthday.h
//  HW5
//
//  Created by Jared Sorge on 2/11/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSPersonBirthday : NSObject

@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSDate *birthdate;
@property (readonly, nonatomic)NSInteger daysUntilBirthday;

/**
 *  Creates a new instance.
 *
 *  @param name      The person's name
 *  @param birthdate The person's birth date
 *
 *  @return The new instance populated with the person's name and birthdate.
 */
- (instancetype)initWithName:(NSString *)name birthdate:(NSDate *)birthdate;

@end
