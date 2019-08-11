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

/** The amount of rounding in the corners (Default is 9.0f) */
@property (nonatomic, assign) CGFloat cornerRadius;

/** Set the background color of the track in the segmented control (Default is light grey) */
@property (nonatomic, strong, null_resettable) UIColor *backgroundColor;

/** Set the color of the thumb view. (Default is white) */
@property (nonatomic, strong, null_resettable) UIColor *thumbColor;

/** The amount of insetting the thumb view is from the edge of the track (Default is 2.0f) */
@property (nonatomic, assign) CGFloat thumbInset;

/** The opacity of the shadow surrounding the thumb view*/
@property (nonatomic, assign) CGFloat thumbShadowOpacity;

/** The vertical offset of the shadow */
@property (nonatomic, assign) CGFloat thumbShadowOffset;

/** The radius of the shadow */
@property (nonatomic, assign) CGFloat thumbShadowRadius;

- (instancetype)initWithItems:(nullable NSString *)items;

@end

NS_ASSUME_NONNULL_END
