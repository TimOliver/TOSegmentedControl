//
//  TOSegmentedControlItem.m
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOSegmentedControlItem.h"
#import "TOSegmentedControl.h"
#import <UIKit/UIKit.h>

// -------------------------------------------------
// Access to private properties in segmented control parent

@interface TOSegmentedControl ()
@property (nonatomic, readonly) UIImage *arrowImage;
@end

// -------------------------------------------------
// Private Interface

@interface TOSegmentedControlItem ()

// Weak reference to our parent segmented control
@property (nonatomic, weak) TOSegmentedControl *segmentedControl;

@end

@implementation TOSegmentedControlItem

#pragma mark - Object Creation -

- (instancetype)initWithTitle:(NSString *)title
          forSegmentedControl:(nonnull TOSegmentedControl *)segmentedControl
{
    if (self = [super init]) {
        _title = [title copy];
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
          forSegmentedControl:(nonnull TOSegmentedControl *)segmentedControl
{
    if (self = [super init]) {
        _image = image;
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   reversible:(BOOL)reversible
          forSegmentedControl:(nonnull TOSegmentedControl *)segmentedControl
{
    if (self = [super init]) {
        _title = [title copy];
        _isReversible = reversible;
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
                   reversible:(BOOL)reversible
          forSegmentedControl:(nonnull TOSegmentedControl *)segmentedControl
{
    if (self = [super init]) {
        _image = image;
        _isReversible = reversible;
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Comnvenience Initializers -

+ (NSArray *)itemsWithObjects:(NSArray *)objects forSegmentedControl:(nonnull TOSegmentedControl *)segmentedControl
{
    NSMutableArray *array = [NSMutableArray array];
    
    // Create an object for each item in the array.
    // Skip anything that isn't an image or a label
    for (id object in objects) {
        TOSegmentedControlItem *item = nil;
        if ([object isKindOfClass:UILabel.class]) {
            item = [[TOSegmentedControlItem alloc] initWithTitle:object
                                             forSegmentedControl:segmentedControl];
        }
        else if ([object isKindOfClass:UIImage.class]) {
            item = [[TOSegmentedControlItem alloc] initWithImage:object
                                             forSegmentedControl:segmentedControl];
        }

        if (item) { [array addObject:item]; }
    }
    
    return [NSArray arrayWithArray:array];
}

#pragma mark - Set-up -

- (void)commonInit
{
    
}

- (UILabel *)makeLabelForTitle:(NSString *)title
{
    if (title.length == 0) { return nil; }
    
    // Object is a string. Create a label
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.segmentedControl.itemColor;
    label.font = self.segmentedControl.textFont;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIImageView *)makeImageViewForImage:(UIImage *)image
{
    // Object is an image. Create an image view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tintColor = self.segmentedControl.itemColor;
    return imageView;
}

- (UIView *)itemView
{
    
}

@end
