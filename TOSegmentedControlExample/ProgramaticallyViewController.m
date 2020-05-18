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
@property (nonatomic, strong) UIButton *selectIndexButton;

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
  [self setupSelectIndexButton];
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

#pragma mark - selectIndexButton

        NSLayoutConstraint *selectIndexButtonLeadingConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.selectIndexButton
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:0.f];
        [self.view addConstraint:selectIndexButtonLeadingConstraint];


        NSLayoutConstraint *selectIndexButtonTrailingConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.selectIndexButton
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0.f];
        [self.view addConstraint:selectIndexButtonTrailingConstraint];

        NSLayoutConstraint *selectIndexButtonTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.selectIndexButton
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.secondSegmentedControl
                                                   attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0
                                                   constant:16.0];
        [self.view addConstraint:selectIndexButtonTopConstraint];

        NSLayoutConstraint *selectIndexButtonHeightConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.selectIndexButton
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:0
                                                   toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1
                                                   constant:50];
        [self.view addConstraint:selectIndexButtonHeightConstraint];

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

- (void)setupSelectIndexButton {
    self.selectIndexButton = [[UIButton alloc] init];
    self.selectIndexButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectIndexButton.backgroundColor = UIColor.darkGrayColor;
    [self.selectIndexButton setTitle:@"Select second index animated" forState: UIControlStateNormal];
    [self.view addSubview:self.selectIndexButton];
    [self.selectIndexButton addTarget:self action:@selector(selectIndexButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) selectIndexButtonTouchUpInside:(id) obj {
  [self.firstSegmentedControl setSelectedSegmentIndex:1 animated:true];
}

@end
