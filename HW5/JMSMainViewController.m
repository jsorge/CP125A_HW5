//
//  JMSMainViewController.m
//  HW5
//
//  Created by Jared Sorge on 2/11/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSMainViewController.h"
#import "JMSPersonBirthday.h"
#import "JMSPersonStore.h"
#import "JMSBirthdayTableViewCell.h"
#import "JMSEditPersonTableViewController.h"

NSString *const ADD_NEW_SEGUE = @"addNewSegue";

@interface JMSMainViewController () <UITableViewDataSource, UITableViewDelegate, JMSEditPersonDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic)JMSPersonStore *store;
@property (strong, nonatomic)NSDateFormatter *dateFormatter;
@property (strong, nonatomic)JMSPersonBirthday *personBeingEdited;
@end

@implementation JMSMainViewController

#pragma mark - Properties
- (JMSPersonStore *)store
{
    if (!_store) {
        _store = [[JMSPersonStore alloc] init];
    }
    return _store;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    return _dateFormatter;
}

#pragma mark - View Lifecycle
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_NEW_SEGUE]) {
        UINavigationController *navController = segue.destinationViewController;
        JMSEditPersonTableViewController *editPersonVC = (JMSEditPersonTableViewController *)navController.topViewController;
        editPersonVC.delegate = self;
        
        if (self.personBeingEdited) {
            editPersonVC.personBirthday = self.personBeingEdited;
        }
    }
}

#pragma mark - JMSEditPersonDelegate
- (void)editPersonViewControllerdidCancel:(JMSEditPersonTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.personBeingEdited = nil;
}

- (void)editPersonViewControllerdidSaveNew:(JMSEditPersonTableViewController *)controller
{
    [self.store.people addObject:controller.personBirthday];
    [self.store sortBirthdaysInOrder:self.store.currentSortDirection];
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *newRow = [NSIndexPath indexPathForRow:[self.store.people indexOfObject:controller.personBirthday] inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[newRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)editPersonViewControllerDidUpdateExisting:(JMSEditPersonTableViewController *)controller
{
    NSArray *originalList = [self.store.people copy];
    
    NSIndexPath *editedRow = [NSIndexPath indexPathForRow:[self.store.people indexOfObject:self.personBeingEdited] inSection:0];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[editedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.store sortBirthdaysInOrder:self.store.currentSortDirection];
        [self sortTableViewWithOriginalArray:originalList];
    }];
    self.personBeingEdited = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.store.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSBirthdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birthdayCell"];
    if (!cell) {
        cell = [[JMSBirthdayTableViewCell alloc] init];
    }
    
    JMSPersonBirthday *person = self.store.people[indexPath.row];
    
    cell.nameLabel.text = person.name;
    cell.birthdayLabel.text = [self.dateFormatter stringFromDate:person.birthdate];
    cell.countdownLabel.text = [NSString stringWithFormat:@"%ld", (long)person.daysUntilBirthday];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.store removePersonAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.personBeingEdited = self.store.people[indexPath.row];
    [self performSegueWithIdentifier:ADD_NEW_SEGUE sender:nil];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    [self updateEditButtonLabel];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    [self updateEditButtonLabel];
}

#pragma mark - IBActions
- (IBAction)sortButtonTapped:(id)sender
{
    UIActionSheet *sortSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By Days Remaining"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Ascending", @"Descending", nil];
    [sortSheet showFromToolbar:self.toolbar];
}

- (IBAction)editButtonTapped:(UIBarButtonItem *)sender
{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
    [self updateEditButtonLabel];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *originalList = [self.store.people copy];
    
    if (buttonIndex == JMSBirthdaySortAscending) {
        [self.store sortBirthdaysInAscendingDaysRemaing];
    } else if (buttonIndex == JMSBirthdaySortDescending) {
        [self.store sortBirthdaysInDescendingDaysRemaing];
    }
    
    [self sortTableViewWithOriginalArray:originalList];
}

#pragma mark - Private
- (void)sortTableViewWithOriginalArray:(NSArray *)originalList
{
    //Credit for this technique to http://blog.neuwert-media.com/2013/05/animated-sorting-in-uitableview/
    
    [self.tableView beginUpdates];
    
    NSInteger sourceRow = 0;
    for (JMSPersonBirthday *person in originalList) {
        NSInteger destinationRow = [self.store.people indexOfObject:person];
        
        if (sourceRow != destinationRow) {
            NSIndexPath *originalIndexPath = [NSIndexPath indexPathForItem:sourceRow inSection:0];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:destinationRow inSection:0];
            [self.tableView moveRowAtIndexPath:originalIndexPath toIndexPath:newIndexPath];
        }
        
        sourceRow++;
    }
    
    [self.tableView endUpdates];
    
}

- (void)updateEditButtonLabel
{
    if (self.tableView.editing) {
        [self.editButton setTitle:@"Done"];
    } else {
        [self.editButton setTitle:@"Edit"];
    }
}

@end
