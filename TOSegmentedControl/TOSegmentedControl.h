//
//  TOSegmentedControl.h
//  TOSegmentedControlExample
//
//  Created by Tim Oliver on 11/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SegmentedControl)
IB_DESIGNABLE @interface TOSegmentedControl : UIControl

/** The items currently assigned to this segmented control. (Can be a combination of strings and images) */
@property (nonatomic, copy) NSArray *items;

/** An array of BOOL values dictating which items are reversible. */
@property (nonatomic, copy) NSArray<NSNumber *> *reversibleItems;

/** A block that is called whenever a segment is tapped. */
@property (nonatomic, copy) void (^segmentTappedHandler)(NSInteger index, BOOL reversed);

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

/** The color of the text labels (Default is black) */
@property (nonatomic, strong, null_resettable) UIColor *textColor;

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
- (instancetype)initWithItems:(nullable NSArray *)items;

/**
 Sets the content of a given segment to an image.

 @param image The image to set.
 @param index The index of the segment to set.
 */
- (void)setImage:(UIImage *)image forItemAtIndex:(NSInteger)index;

/**
 Sets the content of a given segment to an image and optionally makes
 it reversible.

 @param image The image to set.
 @param reversible Whether the item can be tapped again to indicate changing order.
 @param index The index of the segment to set.
 */
- (void)setImage:(UIImage *)image reversible:(BOOL)reversible forItemAtIndex:(NSInteger)index;

/**
 Returns the image that was assigned to a specific segment.
 Will return nil if the content at that segment is not an image.

 @param index The index at which the image is located.
 */
- (nullable UIImage *)imageForItemAtIndex:(NSInteger)index;

/**
 Sets the content of a given segment to a text label.

 @param title The text to display at the segment
 @param index The index of the segment to set.
 */
- (void)setTitle:(NSString *)title forItemAtIndex:(NSInteger)index;

/**
 Sets the content of a given segment to a text label and optionally makes
 it reversible.

 @param title The text to display at the segment.
  @param reversible Whether the item can be tapped again to indicate changing order.
 @param index The index of the segment to set.
 */
- (void)setTitle:(NSString *)title reversible:(BOOL)reversible forItemAtIndex:(NSInteger)index;

/**
Returns the string of the title that was assigned to a specific segment.
Will return nil if the content at that segment is not a string.

@param index The index at which the image is located.
*/
- (nullable NSString *)titleForItemAtIndex:(NSInteger)index;

/**
 Sets whether a specific segment is reverisble.
 This will display a small arrow icon next to it.

 @param reversible Whether the item is reversible or not.
 @param index The index of the segment we are targeting.
 */
- (void)setReversible:(BOOL)reversible forItemAtIndex:(NSInteger)index;

/**
Returns whether a given segment is reversible.

@param index The index to check.
*/
- (BOOL)isReversibleForItemAtIndex:(NSInteger)index;

/**
 Sets whether a specific segment is currently reversed or not.

 @param reversed Whether the item is currently reversed or not.
 @param index The index of the segment we are targeting.
 */
- (void)setReversed:(BOOL)reversed forSegmentAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
Returns whether a given segment is currently reveresed

@param index The index to check.
*/
- (BOOL)isReversedForItemAtIndex:(NSInteger)index;

/**
 Inserts a new image item at the specified segment index.

 @param image The image to set.
 @param index The index of the segment to which the image will be set.
 */
- (void)insertItemWithImage:(UIImage *)image atIndex:(NSInteger)index;

/**
 Inserts a new image item at the specified segment index, and optionally
 may be made reversible.

 @param image The image to set.
 @param reversible Whether the item can be tapped again to toggle ordering.
 @param index The index of the segment to which the image will be set.
 */
- (void)insertItemWithImage:(UIImage *)image reversible:(BOOL)reversible atIndex:(NSInteger)index;

/**
Inserts a new image title at the specified segment index.

@param title The title to set.
@param index The index of the segment to which the image will be set.
*/
- (void)insertItemWithTitle:(NSString *)title atIndex:(NSInteger)index;

/**
Inserts a new image title at the specified segment index, and optionally
may be made reversible.

@param title The title to set.
@param reversible Whether the item can be tapped again to toggle ordering.
@param index The index of the segment to which the image will be set.
*/
- (void)insertItemWithTitle:(NSString *)title reversible:(BOOL)reversible atIndex:(NSInteger)index;

/**
Removes the item at the specified index.

@param index The index of the segment to remove.
*/
- (void)removeItemAtIndex:(NSInteger)index;

/**
 Removes all of the items from this control.
 */
- (void)removeAllItems;

/**
 Enables or disables the item at the specified index.

 @param enabled Whether the item is enabled or not.
 @param index The specific index to enable/disable.
 */
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSInteger)index;

/**
 Returns whether the item at the specified index is currently enabled or not.

 @param index The index to check.
 */
- (BOOL)isEnabledForSegmentAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
