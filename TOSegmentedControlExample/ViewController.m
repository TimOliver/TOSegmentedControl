//
//  ViewController.m
//  TOSegmentedControlExample
//
//  Created by Tim Oliver on 10/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "ViewController.h"
#import "TOSegmentedControl.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet TOSegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.segmentedControl.items = @[@"First", @"Second", @"Third"];
}

@end
