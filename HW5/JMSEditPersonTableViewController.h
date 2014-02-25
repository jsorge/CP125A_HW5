//
//  JMSEditPersonTableViewController.h
//  HW5
//
//  Created by Jared Sorge on 2/15/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMSEditPersonDelegate;
@class JMSPersonBirthday;

@interface JMSEditPersonTableViewController : UITableViewController

@property (weak,nonatomic)id<JMSEditPersonDelegate>delegate;
@property (strong, nonatomic)JMSPersonBirthday *personBirthday;

@end

@protocol JMSEditPersonDelegate <NSObject>

/**
 *  The cancel button on the view controller was tapped.
 *
 *  @param controller self
 */
- (void)editPersonViewControllerdidCancel:(JMSEditPersonTableViewController *)controller;

/**
 *  The save button was tapped, and a new person object was created.
 *
 *  @param controller self
 */
- (void)editPersonViewControllerdidSaveNew:(JMSEditPersonTableViewController *)controller;

/**
 *  The save button was tapped, and an existing person was updated.
 *
 *  @param controller self
 */
- (void)editPersonViewControllerDidUpdateExisting:(JMSEditPersonTableViewController *)controller;

@end