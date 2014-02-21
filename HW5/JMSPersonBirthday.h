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

- (instancetype)initWithName:(NSString *)name birthdate:(NSDate *)birthdate;

@end
