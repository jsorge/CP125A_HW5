//
//  Person+Extension.m
//  HW5
//
//  Created by Jared Sorge on 2/23/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "Person+Extension.h"

@implementation Person (Extension)

+ (Person *)findOrCreatePersonWithName:(NSString *)name birthdate:(NSDate *)birthdate
{
    Person *person = [Person MR_findFirstByAttribute:@"name" withValue:name];
    
    if (!person) {
        person = [Person MR_createEntity];
        person.name = name;
        person.birthdate = birthdate;
    }
    
    return person;
}

@end
