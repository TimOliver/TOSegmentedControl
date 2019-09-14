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
@property (nonatomic, readonly) UIView *trackView;
@property (nonatomic, readonly) UIImage *arrowImage;
@end

// -------------------------------------------------
// Private Interface

@interface TOSegmentedControlItem ()

// Weak reference to our parent segmented control
@property (nonatomic, weak) TOSegmentedControl *segmentedControl;

// Read-write access to the item view
@property (nonatomic, strong, readwrite) UIView *itemView;

// When made reversible, the arrow image view to show
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation TOSegmentedControlItem

#pragma mark - Object Lifecyle -

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

- (void)dealloc
{
    [self.itemView removeFromSuperview];
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
    // Create the initial image / label view
    [self refreshItemView];
    
    // Refresh the reversible state
    [self refreshReversibleView];
}

#pragma mark - Reversible Management -

- (void)refreshReversibleView
{
    // Whether it's in memory or not, set the tint color
    self.arrowImageView.tintColor = self.segmentedControl.itemColor;
    
    // If we're no longer (Or never were) reversible,
    // hide and exit out
    if (!self.isReversible) {
        self.arrowImageView.hidden = YES;
        return;
    }
    
    // Create the arrow view if we haven't done so yet
    if (self.arrowImageView == nil) {
        UIImage *arrow = self.segmentedControl.arrowImage;
        self.arrowImageView = [[UIImageView alloc] initWithImage:arrow];
    }
    
    // Add the arrow to the item view
    self.itemView.clipsToBounds = NO;
    [self.itemView addSubview:self.arrowImageView];
    
    // Line up the item view vertically centered next to the item view
    self.arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                            UIViewAutoresizingFlexibleBottomMargin |
                                            UIViewAutoresizingFlexibleLeftMargin;
    
    CGRect itemFrame = self.itemView.frame;
    CGRect frame = self.arrowImageView.frame;
    frame.origin.x = CGRectGetMaxX(itemFrame) + 2.0f;
    frame.origin.y = (CGRectGetHeight(itemFrame) - CGRectGetHeight(frame)) * 0.5f;
    self.arrowImageView.frame = frame;
}

#pragma mark - View Management -

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

- (void)refreshItemView
{
    // Convenience check for whether the view is a label or image
    UIImageView *imageView = nil;
    if ([self.itemView isKindOfClass:UIImageView.class]) {
        imageView = (UIImageView *)self.itemView;
    }
    
    UILabel *label = nil;
    if ([self.itemView isKindOfClass:UILabel.class]) {
        label = (UILabel *)self.itemView;
    }

    // If we didn't change the type, just update the current
    // view with the new type
    if (imageView && self.image) {
        [(UIImageView *)self.itemView setImage:self.image];
    }
    
    // If it's already a label, refresh the text
    if (label && self.title) {
        [(UILabel *)self.itemView setText:self.title];
    }
    
    // If it's an image view, but the title text is set, swap them out
    if (imageView && self.title) {
        [imageView removeFromSuperview];
        imageView = nil;
        
        self.itemView = [self makeLabelForTitle:self.title];
        [self.segmentedControl.trackView addSubview:self.itemView];
        
        label = (UILabel *)self.itemView;
    }
    
    // If it's a label view, but the image is set, swap them out
    if (label && self.image) {
        [label removeFromSuperview];
        label = nil;
        
        self.itemView = [self makeImageViewForImage:self.image];
        [self.segmentedControl.trackView addSubview:self.itemView];
        
        imageView = (UIImageView *)self.itemView;
    }
    
    // Set the tint color of the component
    label.textColor = self.segmentedControl.itemColor;
    imageView.tintColor = self.segmentedControl.itemColor;
}

#pragma mark - Public Accessors -

- (void)setTitle:(NSString *)title
{
    // Copy text, and regenerate the view if need be
    _title = [title copy];
    _image = nil;
    [self refreshItemView];
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) { return; }
    _image = image;
    _title = nil;
    [self refreshItemView];
}

- (void)setIsReversible:(BOOL)isReversible
{
    if (_isReversible == isReversible) { return; }
    _isReversible = isReversible;
    [self refreshReversibleView];
}

@end
