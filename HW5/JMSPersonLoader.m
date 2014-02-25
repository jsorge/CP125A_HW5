//
//  JMSPersonLoader.m
//  HW5
//
//  Created by Jared Sorge on 2/23/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSPersonLoader.h"
#import "Person+Extension.h"

@implementation JMSPersonLoader

- (void)main
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"fakenames" ofType:@"json"];
    NSArray *names = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                                     options:kNilOptions
                                                       error:&error];
    
    __block NSInteger progressCount = 0;
    NSInteger totalCount = [names count];
    NSInteger progressGranularity = totalCount/100;
    [names enumerateObjectsUsingBlock:^(NSDictionary *person, NSUInteger idx, BOOL *stop) {
        progressCount++;
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", person[@"givenname"], person[@"surname"]];
        NSDate *birthdate = [dateFormatter dateFromString:person[@"birthday"]];
        Person *newPerson = [Person findOrCreatePersonWithName:name birthdate:birthdate];
        
        if (progressCount == 1) {
            [self.delegate personLoaderDidBeginParsingData:self withTotalRows:totalCount];
        } else if (progressCount == totalCount) {
            [self.delegate personLoaderDidEndParsingData:self];
        } else if (progressCount % progressGranularity == 0 && progressCount!= totalCount) {
            [self.delegate personLoader:self didParseDataWithProgress:(progressCount/progressGranularity)];
            [newPerson.managedObjectContext MR_saveOnlySelfAndWait];
        }
    }];
}

@end
