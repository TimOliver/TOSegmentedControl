//
//  CodeViewController.m
//  TOSegmentedControlExample
//
//  Created by Pedro Paulo de Amorim on 17/05/2020.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import "CodeViewController.h"
#import "TOSegmentedControl.h"

@interface CodeViewController ()

@property (nonatomic, strong) TOSegmentedControl *firstSegmentedControl;
@property (nonatomic, strong) TOSegmentedControl *secondSegmentedControl;
@property (nonatomic, strong) UIButton *selectIndexButton;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CodeViewController

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

        [self setConstraints:self.firstSegmentedControl];

        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.firstSegmentedControl
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                   attribute:NSLayoutAttributeCenterY
                                                   multiplier:1.0
                                                   constant:0];
        [self.view addConstraint:centerYConstraint];

#pragma mark - secondSegmentedControl

        [self setConstraints:self.secondSegmentedControl];
        [self setTopConstraint:self.secondSegmentedControl below:self.firstSegmentedControl];

#pragma mark - selectIndexButton

        [self setConstraints:self.selectIndexButton];
        [self setTopConstraint:self.selectIndexButton below:self.secondSegmentedControl];

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

    [self.firstSegmentedControl insertSegmentWithTitle:@"Max" atIndex: INT_MAX];

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

- (void)setConstraints:(UIView *)view {

  NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint
                                            constraintWithItem:view
                                            attribute:NSLayoutAttributeLeading
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeLeading
                                            multiplier:1.0f
                                            constant:0.f];
  [self.view addConstraint:leadingConstraint];

  NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint
                                             constraintWithItem:view
                                             attribute:NSLayoutAttributeTrailing
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                             attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0
                                             constant:0];
  [self.view addConstraint:trailingConstraint];

  NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:view
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:0
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1
                                            constant:50];
  [self.view addConstraint:heightConstraint];

}

- (void)setTopConstraint:(UIView *)view below:(UIView *)topView {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                                             constraintWithItem:view
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:topView
                                             attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                             constant:16.0];
    [self.view addConstraint:topConstraint];
}

@end
