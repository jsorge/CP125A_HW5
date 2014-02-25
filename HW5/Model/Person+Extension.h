//
//  Person+Extension.h
//  HW5
//
//  Created by Jared Sorge on 2/23/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "Person.h"

@interface Person (Extension)

+ (Person *)findOrCreatePersonWithName:(NSString *)name birthdate:(NSDate *)birthdate;

@end
