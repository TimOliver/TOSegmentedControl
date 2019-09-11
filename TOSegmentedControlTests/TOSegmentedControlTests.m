//
//  TOSegmentedControlTests.m
//  TOSegmentedControlTests
//
//  Created by Tim Oliver on 10/9/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOSegmentedControl.h"

@interface TOSegmentedControlTests : XCTestCase

@end

@implementation TOSegmentedControlTests

- (void)testCreation
{
    TOSegmentedControl *segmentedControl = [[TOSegmentedControl alloc] init];
    XCTAssert(segmentedControl != nil);
}

@end
