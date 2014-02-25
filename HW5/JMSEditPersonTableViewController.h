//
//  JMSEditPersonTableViewController.h
//  HW5
//
//  Created by Jared Sorge on 2/15/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMSEditPersonDelegate;
@class Person;

@interface JMSEditPersonTableViewController : UITableViewController

@property (weak,nonatomic)id<JMSEditPersonDelegate>delegate;
@property (strong, nonatomic)Person *personBirthday;

@end

@protocol JMSEditPersonDelegate <NSObject>

- (void)editPersonViewControllerdidCancel:(JMSEditPersonTableViewController *)controller;
- (void)editPersonViewControllerdidSaveNew:(JMSEditPersonTableViewController *)controller;
- (void)editPersonViewControllerDidUpdateExisting:(JMSEditPersonTableViewController *)controller;

@end