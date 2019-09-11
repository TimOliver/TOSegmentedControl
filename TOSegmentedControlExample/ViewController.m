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

@property (weak, nonatomic) IBOutlet UISegmentedControl *classicSegmentedControl;
@property (weak, nonatomic) IBOutlet TOSegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *classicSegmentedLabel;
@property (weak, nonatomic) IBOutlet UILabel *segmentedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.classicSegmentedLabel.alpha = 0.0f;
    self.segmentedLabel.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.items = @[@"First", @"Second", @"Third"];
    self.segmentedControl.segmentTappedHandler = ^(NSInteger index, BOOL reversed) {
        NSString *title = [self nameForIndex:index];
        [weakSelf animateLabel:weakSelf.segmentedLabel title:title];
    };
}

- (IBAction)segmentedControlUpdated:(id)sender
{
    NSString *title = [self nameForIndex:self.classicSegmentedControl.selectedSegmentIndex];
    [self animateLabel:self.classicSegmentedLabel title:title];
}

- (void)animateLabel:(UILabel *)label title:(NSString *)title
{
    label.text = title;
    label.alpha = 1.0f;
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.3f
          initialSpringVelocity:50.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ label.transform = CGAffineTransformIdentity; }
                     completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.4f animations:^{
            label.alpha = 0.0f;
        }];
    }];
}

- (NSString *)nameForIndex:(NSInteger)index
{
    switch (index) {
        case 0: return @"First Selected";
        case 1: return @"Second Selected";
        case 2: return @"Third Selected";
    }
    
    return nil;
}

@end
