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

@property (nonatomic, strong) TOSegmentedControl *thirdSegmentedControl;
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
  [self setupThirdSegmentedControl];
  [self.view setNeedsUpdateConstraints];

}

- (void)updateViewConstraints {

    if (!self.didSetupConstraints) {

        self.didSetupConstraints = YES;

        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.thirdSegmentedControl
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:0.f];
        [self.view addConstraint:leadingConstraint];


        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.thirdSegmentedControl
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0];
        [self.view addConstraint:trailingConstraint];

        NSLayoutConstraint *con4 = [NSLayoutConstraint
                                    constraintWithItem:self.thirdSegmentedControl
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:0
                                    toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                    constant:50];
        [self.view addConstraint:con4];

    }

    [super updateViewConstraints];
}

- (void)setupThirdSegmentedControl {
    self.thirdSegmentedControl = [[TOSegmentedControl alloc] initWithItems:@[@"Crash"]];
    self.thirdSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.thirdSegmentedControl];
    self.thirdSegmentedControl.items = @[@"First", @"Second"];
    self.thirdSegmentedControl.itemColor = UIColor.whiteColor;
    self.thirdSegmentedControl.backgroundColor = UIColor.blackColor;

    [self.thirdSegmentedControl removeAllSegments];

    [self.thirdSegmentedControl addNewSegmentWithTitle:@"First"];
    [self.thirdSegmentedControl addNewSegmentWithTitle:@"Second"];

    [UIView performWithoutAnimation:^{
      [self.thirdSegmentedControl addNewSegmentWithTitle:@"Third"];
    }];

}

@end
