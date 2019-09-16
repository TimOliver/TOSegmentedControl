//
//  TOSegmentedControl.h
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
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A UI control that presents several
 options to the user in a horizontal, segmented layout.
 
 Only one segment may be selected at a time and, if desired,
 may be designated as 'reversible' with an arrow icon indicating
 its direction.
 */

NS_SWIFT_NAME(SegmentedControl)
IB_DESIGNABLE @interface TOSegmentedControl : UIControl

/** The items currently assigned to this segmented control. (Can be a combination of strings and images) */
@property (nonatomic, copy, nullable) NSArray *items;

/** A set of number values dictating which items are reversible. */
@property (nonatomic, strong) NSMutableSet<NSNumber *> *reversibleItems;

/** A store tracking the current direction of reversible items */
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *reversedItems;

/** A block that is called whenever a segment is tapped. */
@property (nonatomic, copy) void (^segmentTappedHandler)(NSInteger segmentIndex, BOOL reversed);

/** The number of segments this segmented control has. */
@property (nonatomic, readonly) NSInteger numberOfSegments;

/** The index of the currently segment. (May be manually set) */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/** Whether the selected segment is reversed or not. */
@property (nonatomic, assign) BOOL selectedSegmentReversed;

/** The amount of rounding in the corners (Default is 9.0f) */
@property (nonatomic, assign) CGFloat cornerRadius;

/** Set the background color of the track in the segmented control (Default is light grey) */
@property (nonatomic, strong, null_resettable) UIColor *backgroundColor;

/** Set the color of the thumb view. (Default is white) */
@property (nonatomic, strong, null_resettable) UIColor *thumbColor;

/** Set the color of the separator lines between each item. (Default is dark grey) */
@property (nonatomic, strong, null_resettable) UIColor *separatorColor;

/** The color of the text labels / images (Default is black) */
@property (nonatomic, strong, null_resettable) UIColor *itemColor;

/** The font of the text items (Default is system default at 10 points) */
@property (nonatomic, strong, null_resettable) UIFont *textFont;

/** The font of the text item when it's been selected (Default is bold system default 10) */
@property (nonatomic, strong, null_resettable) UIFont *selectedTextFont;

/** The amount of insetting the thumb view is from the edge of the track (Default is 2.0f) */
@property (nonatomic, assign) CGFloat thumbInset;

/** The opacity of the shadow surrounding the thumb view*/
@property (nonatomic, assign) CGFloat thumbShadowOpacity;

/** The vertical offset of the shadow */
@property (nonatomic, assign) CGFloat thumbShadowOffset;

/** The radius of the shadow */
@property (nonatomic, assign) CGFloat thumbShadowRadius;

/**
 Creates a new segmented control with the provided items

 @param items An array of either images, or strings to display
 */
- (instancetype)initWithItems:(nullable NSArray *)items NS_SWIFT_NAME(init(items:));

/**
 Replaces the content of an existing segment with a new image.

 @param image The image to set.
 @param index The index of the segment to set.
 */
- (void)setImage:(UIImage *)image forItemAtIndex:(NSInteger)index NS_SWIFT_NAME(set(_:for:));

/**
 Returns the image that was assigned to a specific segment.
 Will return nil if the content at that segment is not an image.

 @param index The index at which the image is located.
 */
- (nullable UIImage *)imageForItemAtIndex:(NSInteger)index NS_SWIFT_NAME(image(for:));

/**
 Sets the content of a given segment to a text label.

 @param title The text to display at the segment
 @param index The index of the segment to set.
 */
- (void)setTitle:(NSString *)title forItemAtIndex:(NSInteger)index NS_SWIFT_NAME(set(_:for:));

/**
Returns the string of the title that was assigned to a specific segment.
Will return nil if the content at that segment is not a string.

@param index The index at which the image is located.
*/
- (nullable NSString *)titleForItemAtIndex:(NSInteger)index NS_SWIFT_NAME(title(for:));

/**
 Adds a new text item to the end of the list.
 
 @param title The title of the new item.
 */
- (void)addNewItemWithTitle:(NSString *)title NS_SWIFT_NAME(addItem(with:));

/**
 Adds a new image item to the end of the list.
 
 @param image The image of the new item.
 */
- (void)addNewItemWithImage:(UIImage *)image NS_SWIFT_NAME(addItem(with:));

/**
 Inserts a new image item at the specified segment index.

 @param image The image to set.
 @param index The index of the segment to which the image will be set.
 */
- (void)insertItemWithImage:(UIImage *)image atIndex:(NSInteger)index NS_SWIFT_NAME(insertItem(_:at:));

/**
Inserts a new image title at the specified segment index.

@param title The title to set.
@param index The index of the segment to which the image will be set.
*/
- (void)insertItemWithTitle:(NSString *)title atIndex:(NSInteger)index NS_SWIFT_NAME(insertItem(_:at:));

/**
 Remove the last item in the list
 */
- (void)removeLastItem NS_SWIFT_NAME(removeLastItem());

/**
Removes the item at the specified index.

@param index The index of the segment to remove.
*/
- (void)removeItemAtIndex:(NSInteger)index NS_SWIFT_NAME(removeItem(at:));

/**
 Removes all of the items from this control.
 */
- (void)removeAllItems NS_SWIFT_NAME(removeAllItems());

/**
 Enables or disables the item at the specified index.

 @param enabled Whether the item is enabled or not.
 @param index The specific index to enable/disable.
 */
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSInteger)index NS_SWIFT_NAME(setEnabled(_:at:));

/**
 Returns whether the item at the specified index is currently enabled or not.

 @param index The index to check.
 */
- (BOOL)isEnabledForSegmentAtIndex:(NSInteger)index NS_SWIFT_NAME(isEnabled(at:));

@end

NS_ASSUME_NONNULL_END

FOUNDATION_EXPORT double TOSegmentedControlFrameworkVersionNumber;
FOUNDATION_EXPORT const unsigned char TOSegmentedControlFrameworkVersionString[];
