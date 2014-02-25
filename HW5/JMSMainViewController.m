//
//  JMSMainViewController.m
//  HW5
//
//  Created by Jared Sorge on 2/11/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSMainViewController.h"
#import "JMSPersonStore.h"
#import "JMSBirthdayTableViewCell.h"
#import "JMSEditPersonTableViewController.h"
#import "Person.h"
#import "JMSPersonLoader.h"

@interface JMSMainViewController () <UITableViewDataSource, UITableViewDelegate, JMSEditPersonDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate, JMSPersonLoaderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;

@property (strong, nonatomic)JMSPersonStore *store;
@property (strong, nonatomic)NSDateFormatter *dateFormatter;
@property (strong, nonatomic)Person *personBeingEdited;
@property (strong, nonatomic)UIProgressView *progressView;
@end

NSString *const ADD_NEW_SEGUE = @"addNewSegue";

typedef NS_ENUM(NSInteger, BirthdayListSortDirection){
    BirthdayListSortAscending,
    BirthdayListSortDescending
};

@implementation JMSMainViewController

#pragma mark - Properties
- (JMSPersonStore *)store
{
    if (!_store) {
        _store = [[JMSPersonStore alloc] init];
        _store.loader.delegate = self;
        _store.people.delegate = self;
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
    [self dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *newRow = [self.store.people indexPathForObject:controller.personBirthday];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[newRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
}

- (void)editPersonViewControllerDidUpdateExisting:(JMSEditPersonTableViewController *)controller
{
    NSIndexPath *editedRow = [self.store.people indexPathForObject:controller.personBirthday];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[editedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
    self.personBeingEdited = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.store.people fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSBirthdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birthdayCell"];
    if (!cell) {
        cell = [[JMSBirthdayTableViewCell alloc] init];
    }
    
    Person *person = [self.store.people objectAtIndexPath:indexPath];
    
    cell.nameLabel.text = person.name;
    cell.birthdayLabel.text = [self.dateFormatter stringFromDate:person.birthdate];
    cell.countdownLabel.text = [NSString stringWithFormat:@"%@", person.daysUntilNextBirthday];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.store removePersonAtIndex:indexPath.row];
    }
    [self.tableView endUpdates];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.personBeingEdited = [self.store.people objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:ADD_NEW_SEGUE sender:nil];
}

#pragma mark - IBActions
- (IBAction)sortButtonTapped:(id)sender
{
    UIActionSheet *sortSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Days Remaining"
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
        [self.editButton setTitle:@"Edit"];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == BirthdayListSortAscending) {
        [self.store sortBirthdaysInAscendingDaysRemaing];
    } else if (buttonIndex == BirthdayListSortDescending) {
        [self.store sortBirthdaysInDescendingDaysRemaing];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - JMSPersonLoaderDelegate
- (void)personLoaderDidBeginParsingData:(JMSPersonLoader *)loader withTotalRows:(NSInteger)totalRows;
{
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.toolbar addSubview:self.progressView];
}

- (void)personLoader:(JMSPersonLoader *)loader didParseDataWithProgress:(NSInteger)updatedProgress;
{
    [self.progressView setProgress:(self.progressView.progress + updatedProgress) animated:YES];
}

- (void)personLoaderDidEndParsingData:(JMSPersonLoader *)loader;
{
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}


@end
