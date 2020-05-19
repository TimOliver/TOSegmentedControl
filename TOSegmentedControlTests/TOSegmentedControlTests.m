//
//  TOSegmentedControlTests.m
//  TOSegmentedControlTests
//
//  Created by Tim Oliver on 10/9/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "TOSegmentedControl.h"

@interface TOSegmentedControlTests : XCTestCase

/// A container view for hosting our segmented control.
@property (nonatomic, strong) UIView *view;

/// A standard segmented control we can run our tests on each time.
@property (nonatomic, strong) TOSegmentedControl *segmentedControl;

@end

@implementation TOSegmentedControlTests


/// Basic litmus test to ensure the control can be
/// created with different constructors with no crashes
- (void)testViewInit
{
    // Test the global segmented control we made (With item strings)
    XCTAssertNotNil(self.segmentedControl);

    // Test creating one with no items
    TOSegmentedControl *emptyControl = [[TOSegmentedControl alloc] init];
    XCTAssertNotNil(emptyControl);

    // Test creating with image items
    UIImage *testImage = [self.class testImage];
    NSArray *imageItems = @[testImage, testImage, testImage];
    TOSegmentedControl *imagesControl = [[TOSegmentedControl alloc] initWithItems:imageItems];
    XCTAssertNotNil(imagesControl);

    // Test creating with a frame
    TOSegmentedControl *frameControl = [[TOSegmentedControl alloc] initWithFrame:(CGRect){0,0,200,44}];
    XCTAssertNotNil(frameControl);
}

/// Test setting a segmented control presently with items to have `nil` items
- (void)testNilItems
{
    self.segmentedControl.items = nil;
    XCTAssertNotNil(self.segmentedControl);
}

/// Test a crash fix for cycling items in a control
/// (Credit to Pedro Paulo de Amorim)
- (void)testCyclingItems
{
    TOSegmentedControl *segmentedControl = [[TOSegmentedControl alloc] initWithItems:@[@"Crash"]];
    [self.view addSubview:segmentedControl];

    segmentedControl.items = @[@"First", @"Second"];
    segmentedControl.itemColor = UIColor.whiteColor;
    segmentedControl.backgroundColor = UIColor.blackColor;

    [segmentedControl removeAllSegments];

    [segmentedControl addSegmentWithTitle:@"First"];
    [segmentedControl addSegmentWithTitle:@"Second"];

    [UIView performWithoutAnimation:^{
        [segmentedControl addSegmentWithTitle:@"Third"];
    }];

    [segmentedControl insertSegmentWithTitle:@"Max" atIndex:INT_MAX];

    // Check to make sure the final list of items is consistent
    NSArray *items = @[@"First", @"Second", @"Third", @"Max"];
    XCTAssertTrue([segmentedControl.items isEqual:items]);
}

#pragma mark - Test Lifecycle -

- (void)setUp
{
    // Create the segmented control with some default titles
    NSArray *items = @[@"First", @"Second", @"Third"];
    self.segmentedControl = [[TOSegmentedControl alloc] initWithItems:items];

    // Create the container view and add it
    self.view = [[UIView alloc] initWithFrame:(CGRect){0,0,320,480}];
    [self.view addSubview:self.segmentedControl];
}

- (void)tearDown
{
    // Completely tear down the views to guarantee no cross-test pollution
    [self.segmentedControl removeFromSuperview];
    self.segmentedControl = nil;
    self.view = nil;
}

#pragma mark - Asset Generation -

// Create a basic image we can use to test image segments
+ (UIImage *)testImage
{
    CGSize size = (CGSize){30,30};
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        [[UIColor blackColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:(CGRect){CGPointZero, size}] fill];
    }];
}

@end
