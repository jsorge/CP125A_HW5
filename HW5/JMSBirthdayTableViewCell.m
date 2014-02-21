//
//  JMSBirthdayTableViewCell.m
//  HW5
//
//  Created by Jared Sorge on 2/11/14.
//  Copyright (c) 2014 JMS. All rights reserved.
//

#import "JMSBirthdayTableViewCell.h"

@interface JMSBirthdayTableViewCell ()
@property (strong, nonatomic)NSDictionary *viewsDictionary;
@property (strong, nonatomic)NSMutableArray *constraints;
@end

CGFloat const smallFontSize = 13.0f;
NSString *const fontName = @"Avenir";

@implementation JMSBirthdayTableViewCell
#pragma mark - Properties
- (NSDictionary *)viewsDictionary
{
    if (!_viewsDictionary) {
        _viewsDictionary = @{@"daysRemaining": self.countdownLabel, @"name": self.nameLabel, @"birthday": self.birthdayLabel};
    }
    return _viewsDictionary;
}

- (NSMutableArray *)constraints
{
    if (!_constraints) {
        _constraints = [NSMutableArray array];
    }
    return _constraints;
}

- (UILabel *)countdownLabel
{
    if (!_countdownLabel) {
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countdownLabel.font = [UIFont fontWithName:fontName size:30.0f];
    }
    return _countdownLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.font = [UIFont fontWithName:fontName size:smallFontSize];
    }
    return _nameLabel;
}

- (UILabel *)birthdayLabel
{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc] init];
        _birthdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _birthdayLabel.font = [UIFont fontWithName:fontName size:smallFontSize];
    }
    return _birthdayLabel;
}

#pragma mark - Init
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.contentView addSubview:self.countdownLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.birthdayLabel];
}

#pragma mark - Auto Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.constraints.count > 0) {
        [self.contentView removeConstraints:self.constraints];
    }
    [self.constraints removeAllObjects];
    
    NSDictionary *metrics = @{@"stackPadding": @6.0f, @"countdownPadding": @9.0f, @"nameBirthdayPadding": @10.0f, @"single": @1.0f};
    
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[daysRemaining]-(nameBirthdayPadding)-[name]"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:self.viewsDictionary]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[daysRemaining]-(nameBirthdayPadding)-[birthday]"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:self.viewsDictionary]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(countdownPadding)-[daysRemaining]-(single)-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:self.viewsDictionary]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(stackPadding)-[name]-(single)-[birthday]-(stackPadding)-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:self.viewsDictionary]];
    [self.contentView addConstraints:self.constraints];
}


@end
