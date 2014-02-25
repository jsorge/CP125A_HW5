//
//  JMSPersonLoader.h
//  HW5
//
//  Created by Jared Sorge on 2/23/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JMSPersonLoaderDelegate;

@interface JMSPersonLoader : NSOperation

@property (weak, nonatomic)id<JMSPersonLoaderDelegate>delegate;

@end

@protocol JMSPersonLoaderDelegate <NSObject>

- (void)personLoaderDidBeginParsingData:(JMSPersonLoader *)loader withTotalRows:(NSInteger)totalRows;
- (void)personLoader:(JMSPersonLoader *)loader didParseDataWithProgress:(NSInteger)updatedProgress;
- (void)personLoaderDidEndParsingData:(JMSPersonLoader *)loader;

@end