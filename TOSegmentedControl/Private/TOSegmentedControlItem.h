//
//  TOSegmentedControlItem.h
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

#import <Foundation/Foundation.h>

@class UIView, UIImage, TOSegmentedControl;

NS_ASSUME_NONNULL_BEGIN

/**
 A private model object that holds all of the
 information and state for a single item in the
 segmented control.
 */
@interface TOSegmentedControlItem : NSObject

/** Item properties */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isReversible;
@property (nonatomic, assign) BOOL isReversed;
@property (nonatomic, strong) UIView *itemView;

// Create an array of objects given an array of strings and images
+ (NSArray *)itemsWithObjects:(NSArray *)objects;

// Create a non-reversible item from this class
- (instancetype)initWithTitle:(NSString *)title
          forSegmentedControl:(TOSegmentedControl *)segmentedControl;
- (instancetype)initWithImage:(UIImage *)image
          forSegmentedControl:(TOSegmentedControl *)segmentedControl;

// Create a potentially reversible item from this class
- (instancetype)initWithTitle:(NSString *)title
                   reversible:(BOOL)reversible
          forSegmentedControl:(TOSegmentedControl *)segmentedControl;
- (instancetype)initWithImage:(UIImage *)image
                   reversible:(BOOL)reversible
          forSegmentedControl:(TOSegmentedControl *)segmentedControl ;

// If the item is reversible, flip the direction
- (void)toggleDirection;

@end

NS_ASSUME_NONNULL_END
