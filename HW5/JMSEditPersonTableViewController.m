//
//  JMSEditPersonTableViewController.m
//  HW5
//
//  Created by Jared Sorge on 2/15/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSEditPersonTableViewController.h"
#import "JMSPersonBirthday.h"

@interface JMSEditPersonTableViewController () 

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;

@property (nonatomic)BOOL creatingNewPerson;
@property (strong, nonatomic)NSDateFormatter *dateFormatter;
@property (nonatomic)BOOL pickerEnabled;

@end

@implementation JMSEditPersonTableViewController

#pragma mark - Properites
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    return _dateFormatter;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.personBirthday) {
        self.personBirthday = [[JMSPersonBirthday alloc] init];
        self.creatingNewPerson = YES;
        self.birthdayLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    } else {
        self.birthdayLabel.text = [self.dateFormatter stringFromDate:self.personBirthday.birthdate];
        self.nameTextField.text = self.personBirthday.name;
        self.datePicker.date = self.personBirthday.birthdate;
    }
    
}

#pragma mark - IBActions
- (IBAction)cancelButtonTapped:(id)sender
{
    [self.delegate editPersonViewControllerdidCancel:self];
}

- (IBAction)saveButtonTapped:(id)sender
{
    self.personBirthday.name = self.nameTextField.text;
    self.personBirthday.birthdate = [self.dateFormatter dateFromString:self.birthdayLabel.text];
    
    if (self.creatingNewPerson) {
        [self.delegate editPersonViewControllerdidSaveNew:self];
    } else {
        [self.delegate editPersonViewControllerDidUpdateExisting:self];
    }
}

- (IBAction)updatebirthday:(id)sender
{
    self.personBirthday.birthdate = self.datePicker.date;
    self.birthdayLabel.text = [self.dateFormatter stringFromDate:self.personBirthday.birthdate];
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.nameTextField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    [self.nameTextField resignFirstResponder];
    
    //show the picker row
    NSIndexPath *pickerRow = [NSIndexPath indexPathForRow:1 inSection:1];
    [tableView beginUpdates];
    if (self.pickerEnabled) {
        [tableView deleteRowsAtIndexPaths:@[pickerRow] withRowAnimation:UITableViewRowAnimationFade];
        self.pickerEnabled = NO;
    } else {
        self.pickerEnabled = YES;
        [tableView insertRowsAtIndexPaths:@[pickerRow] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44.0f;
    
    if (indexPath.section == 1 && indexPath.row == 1 && self.pickerEnabled) {
        rowHeight = self.datePickerCell.frame.size.height;
    }
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if (section == 1 && self.pickerEnabled) {
        rows = 2;
    }
    
    return rows;
}

@end
