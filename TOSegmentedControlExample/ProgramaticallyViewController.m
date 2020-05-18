//
//  ProgramaticallyViewController.m
//  TOSegmentedControlExample
//
//  Created by Pedro Paulo de Amorim on 17/05/2020.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import "ProgramaticallyViewController.h"
#import "TOSegmentedControl.h"

@interface ProgramaticallyViewController ()

@property (nonatomic, strong) TOSegmentedControl *firstSegmentedControl;
@property (nonatomic, strong) TOSegmentedControl *secondSegmentedControl;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ProgramaticallyViewController

- (void)loadView {
  [super loadView];

  if (@available(iOS 13.0, *)) {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
  } else {
    self.view.backgroundColor = UIColor.whiteColor;
  }
  [self setupFirstSegmentedControl];
  [self setupSecondSegmentedControl];
  [self.view setNeedsUpdateConstraints];

}

- (void)updateViewConstraints {

    if (!self.didSetupConstraints) {

        self.didSetupConstraints = YES;

#pragma mark - firstSegmentedControl

        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.firstSegmentedControl
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:0.f];
        [self.view addConstraint:leadingConstraint];

        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.firstSegmentedControl
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0];
        [self.view addConstraint:trailingConstraint];

        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.firstSegmentedControl
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeCenterY
                                                   multiplier:1.0
                                                   constant:0];
        [self.view addConstraint:centerYConstraint];

        NSLayoutConstraint *firstHeightConstraint = [NSLayoutConstraint
                                    constraintWithItem:self.firstSegmentedControl
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:0
                                    toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                    constant:50];
        [self.view addConstraint:firstHeightConstraint];

#pragma mark - secondSegmentedControl

        NSLayoutConstraint *secondLeadingConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.secondSegmentedControl
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:0.f];
        [self.view addConstraint:secondLeadingConstraint];


        NSLayoutConstraint *secondTrailingConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.secondSegmentedControl
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0.f];
        [self.view addConstraint:secondTrailingConstraint];

        NSLayoutConstraint *secondTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.secondSegmentedControl
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.firstSegmentedControl
                                                   attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0
                                                   constant:16.0];
        [self.view addConstraint:secondTopConstraint];

        NSLayoutConstraint *secondHeightConstraint = [NSLayoutConstraint
                                    constraintWithItem:self.secondSegmentedControl
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:0
                                    toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                    constant:50];
        [self.view addConstraint:secondHeightConstraint];

    }

    [super updateViewConstraints];
}

- (void)setupFirstSegmentedControl {

    self.firstSegmentedControl = [[TOSegmentedControl alloc] initWithItems:@[@"Crash"]];
    self.firstSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.firstSegmentedControl];
    self.firstSegmentedControl.items = @[@"First", @"Second"];
    self.firstSegmentedControl.itemColor = UIColor.whiteColor;
    self.firstSegmentedControl.backgroundColor = UIColor.blackColor;

    [self.firstSegmentedControl removeAllSegments];

    [self.firstSegmentedControl addNewSegmentWithTitle:@"First"];
    [self.firstSegmentedControl addNewSegmentWithTitle:@"Second"];

    [UIView performWithoutAnimation:^{
      [self.firstSegmentedControl addNewSegmentWithTitle:@"Third"];
    }];

    NSAssert(![self.firstSegmentedControl isEmpty], @"SegmentedControl is not empty");

    BOOL addedMax = [self.firstSegmentedControl insertSegmentWithTitle:@"Max" atIndex: INT_MAX];

    NSAssert(!addedMax, @"Could not add at a invalid index");

}

- (void)setupSecondSegmentedControl {
  self.secondSegmentedControl = [[TOSegmentedControl alloc] init];
  self.secondSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.secondSegmentedControl];
}

@end
