//
//  TOSegmentedControl.m
//  TOSegmentedControlExample
//
//  Created by Tim Oliver on 11/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOSegmentedControl.h"

// A cache to hold images generated for this view that may be shared.
static NSMapTable *_imageTable = nil;

// Statically referenced key names for the images stored in the map table.
static NSString * const kTOSegmentedControlArrowImage = @"arrowIcon";
static NSString * const kTOSegmentedControlSeparatorImage = @"separatorImage";

@interface TOSegmentedControl ()

/** The background rounded "track" view */
@property (nonatomic, strong) UIView *trackView;

/** The view that shows which view is highlighted */
@property (nonatomic, strong) UIView *thumbView;

/** The separator views between each of the items */
@property (nonatomic, strong) NSMutableArray<UIView *> *separatorViews;

/** The views set up for each item. */
@property (nonatomic, strong) NSMutableArray<UIView *> *itemViews;

/** A weakly retained image table that holds cached images for us. */
@property (nonatomic, readonly) NSMapTable *imageTable;

/** An arrow icon used to denote when a view is reversible. */
@property (nonatomic, readonly) UIImage *arrowImage;

/** A rounded line used as the separator line. */
@property (nonatomic, readonly) UIImage *separatorImage;

@end

@implementation TOSegmentedControl

#pragma mark - Class Init -

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super initWithFrame:(CGRect){0.0f, 0.0f, 300.0f, 32.0f}]) {
        _items = [self sanitizedItemArrayWithItems:items];
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }

    return self;
}

- (instancetype)init
{
    if (self = [super initWithFrame:(CGRect){0.0f, 0.0f, 300.0f, 32.0f}]) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit
{
    // Create content view
    self.trackView = [[UIView alloc] initWithFrame:self.bounds];
    self.trackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.trackView.layer.masksToBounds = YES;
    #ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) { self.trackView.layer.cornerCurve = kCACornerCurveContinuous; }
    #endif
    [self addSubview:self.trackView];

    // Create thumb view
    self.thumbView = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 100.0f, 28.0f)];
    self.thumbView.layer.shadowColor = [UIColor blackColor].CGColor;
    #ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) { self.thumbView.layer.cornerCurve = kCACornerCurveContinuous; }
    #endif
    [self.trackView addSubview:self.thumbView];

    // Create containers for views
    self.itemViews = [NSMutableArray array];
    self.separatorViews = [NSMutableArray array];

    // Set default resettable values
    self.backgroundColor = nil;
    self.thumbColor = nil;
    self.separatorColor = nil;
    self.itemColor = nil;
    self.textFont = nil;
    self.selectedTextFont = nil;

    // Set default values
    self.cornerRadius = 8.0f;
    self.thumbInset = 2.0f;
    self.thumbShadowRadius = 3.0f;
    self.thumbShadowOffset = 2.0f;
    self.thumbShadowOpacity = 0.15f;
}

#pragma mark - Item Management -

- (NSMutableArray *)sanitizedItemArrayWithItems:(NSArray *)items
{
    // Filter the items to extract only strings and images
    NSMutableArray *sanitizedItems = [NSMutableArray array];
    for (id item in items) {
        if (![item isKindOfClass:[UIImage class]] && ![item isKindOfClass:[NSString class]]) {
            continue;
        }
        [sanitizedItems addObject:item];
    }

    return sanitizedItems;
}

- (void)addSubviewsForAllItems
{
    // This should only be called when the item views array is empty to ensure no mismatches
    NSAssert(self.itemViews.count == 0, @"TOSegmentedControl: Item view array should be empty");

    for (id object in self.items) {
        UIView *view = [self viewForItem:object];
        [self.itemViews addObject:view];
        [self.trackView addSubview:view];
    }
}

- (UIView *)viewForItem:(id)object
{
    // Object is an image. Create an image view
    if ([object isKindOfClass:[UIImage class]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:object];
        imageView.tintColor = self.itemColor;
        return imageView;
    }

    // Object is a string. Create a label
    UILabel *label = [[UILabel alloc] init];
    label.text = object;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.itemColor;
    label.font = self.textFont;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)updateSeparatorViewCount
{
    NSInteger numberOfSeparators = (self.items.count - 1);

    // Add as many separators as needed
    while (self.separatorViews.count < numberOfSeparators) {
        UIImageView *separator = [[UIImageView alloc] initWithImage:self.separatorImage];
        separator.tintColor = self.separatorColor;
        [self.trackView insertSubview:separator atIndex:0];
        [self.separatorViews addObject:separator];
    }

    // Substract as many separators as needed
    while (self.separatorViews.count > numberOfSeparators) {
        UIView *separator = self.separatorViews.lastObject;
        [self.separatorViews removeLastObject];
        [separator removeFromSuperview];
    }
}

- (void)removeAllItems
{
    // Remove all item views
    for (UIView *view in self.itemViews) {
        [view removeFromSuperview];
    }
    [self.itemViews removeAllObjects];

    // Remove all separators
    for (UIView *separator in self.separatorViews) {
        [separator removeFromSuperview];
    }
    [self.separatorViews removeAllObjects];

    // Delete the items array
    self.items = nil;
}

#pragma mark - Accessors -

// -----------------------------------------------
// Items

- (void)setItems:(NSArray *)items
{
    if (items == _items) { return; }

    // Remove all current items
    [self removeAllItems];

    // Set the new array
    _items = [self sanitizedItemArrayWithItems:items];

    // Update the number of separators
    [self updateSeparatorViewCount];

    // Add all content views
    [self addSubviewsForAllItems];

    // Trigger a layout update
    [self setNeedsLayout];
}

#pragma mark - View Layout -

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSInteger index = self.selectedSegmentIndex;
    CGSize size = self.bounds.size;

    // Work out how much width we have accounting for the inset
    CGFloat width = size.width - (_thumbInset * 2.0f);

    // Divide that to get the segment width
    CGFloat segmentWidth = floorf(width / self.numberOfSegments);

    // Lay out the thumb view
    CGRect frame = CGRectZero;
    frame.origin.x = _thumbInset + (segmentWidth * index);
    frame.origin.y = _thumbInset;
    frame.size.width = segmentWidth;
    frame.size.height = size.height - (_thumbInset * 2.0f);
    self.thumbView.frame = frame;

    // Match the shadow path to the size of the thumb view
    CGRect shadowFrame = (CGRect){CGPointZero, frame.size};
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowFrame cornerRadius:self.cornerRadius - self.thumbInset];
    self.thumbView.layer.shadowPath = shadowPath.CGPath;

    // Lay out the item views
    NSInteger i = 0;
    for (UIView *itemView in self.itemViews) {
        // Size to fit
        [itemView sizeToFit];

        // Lay out the frame
        CGFloat xOffset = _thumbInset + (i++ * segmentWidth);
        frame = itemView.frame;
        frame.origin.x = xOffset + ((segmentWidth - frame.size.width) * 0.5f);
        frame.origin.y = (size.height - frame.size.height) * 0.5f;
        itemView.frame = CGRectIntegral(frame);
    }

    // Layout the separators
    CGFloat xOffset = (_thumbInset + segmentWidth) - 1.0f;
    i = 0;
    for (UIView *separatorView in self.separatorViews) {
        frame = separatorView.frame;
        frame.size.width = 1.0f;
        frame.size.height = (size.height - (self.cornerRadius) * 2.0f) + 2.0f;
        frame.origin.x = xOffset + (segmentWidth * i++);
        frame.origin.y = (size.height - frame.size.height) * 0.5f;
        separatorView.frame = CGRectIntegral(frame);

        separatorView.alpha = (i == index || i == (index - 1)) ? 0.0f : 1.0f;
    }
}

// -----------------------------------------------
// Corner Radius

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.trackView.layer.cornerRadius = cornerRadius;
    self.thumbView.layer.cornerRadius = (cornerRadius - _thumbInset) + 0.5f;
}

- (CGFloat)cornerRadius { return self.trackView.layer.cornerRadius; }

// -----------------------------------------------
// Thumb Color

- (void)setThumbColor:(UIColor *)thumbColor
{
    self.thumbView.backgroundColor = thumbColor;
    if (self.thumbView.backgroundColor == nil) {
        self.thumbView.backgroundColor = [UIColor whiteColor];
    }
}
- (UIColor *)thumbColor { return self.thumbView.backgroundColor; }

// -----------------------------------------------
// Background Color

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.trackView.backgroundColor = backgroundColor;
    if (self.trackView.backgroundColor == nil) {
        self.trackView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.08f alpha:0.06666f];
    }
}
- (UIColor *)backgroundColor { return self.trackView.backgroundColor; }

// -----------------------------------------------
// Separator Color

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    if (_separatorColor == nil) {
        _separatorColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.08f alpha:0.1f];
    }

    for (UIView *separatorView in self.separatorViews) {
        separatorView.tintColor = _separatorColor;
    }
}

// -----------------------------------------------
// Item Color

- (void)setItemColor:(UIColor *)itemColor
{
    _itemColor = itemColor;
    if (_itemColor == nil) {
        _itemColor = [UIColor blackColor];
    }

    // Set each item to the color
    for (UIView *itemView in self.itemViews) {
        if ([itemView isKindOfClass:[UILabel class]]) {
            [(UILabel *)itemView setTextColor:_itemColor];
        }
        else {
            itemView.tintColor = _itemColor;
        }
    }
}

// -----------------------------------------------
// Text Font

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    if (_textFont == nil) {
        _textFont = [UIFont systemFontOfSize:13.0f weight:UIFontWeightMedium];
    }

    // Set each item to the font, if they are a label
    for (UIView *itemView in self.itemViews) {
        if (![itemView isKindOfClass:[UILabel class]]) { continue; }
        [(UILabel *)itemView setFont:_textFont];
    }
}

// -----------------------------------------------
// Selected Text Font

- (void)setSelectedTextFont:(UIFont *)selectedTextFont
{
    _selectedTextFont = selectedTextFont;
    if (_selectedTextFont == nil) {
        _selectedTextFont = [UIFont boldSystemFontOfSize:11.0f];
    }
}

// -----------------------------------------------
// Thumb Inset

- (void)setThumbInset:(CGFloat)thumbInset
{
    _thumbInset = thumbInset;
    self.thumbView.layer.cornerRadius = (self.cornerRadius - _thumbInset) + 0.5f;
}

// -----------------------------------------------
// Shadow Properties

- (void)setThumbShadowOffset:(CGFloat)thumbShadowOffset {self.thumbView.layer.shadowOffset = (CGSize){0.0f, thumbShadowOffset}; }
- (CGFloat)thumbShadowOffset { return self.thumbView.layer.shadowOffset.height; }

- (void)setThumbShadowOpacity:(CGFloat)thumbShadowOpacity { self.thumbView.layer.shadowOpacity = thumbShadowOpacity; }
- (CGFloat)thumbShadowOpacity { return self.thumbView.layer.shadowOpacity; }

- (void)setThumbShadowRadius:(CGFloat)thumbShadowRadius { self.thumbView.layer.shadowRadius = thumbShadowRadius; }
- (CGFloat)thumbShadowRadius { return self.thumbView.layer.shadowRadius; }

// -----------------------------------------------
// Number of segments

- (NSInteger)numberOfSegments { return self.itemViews.count; }

#pragma mark - Image Creation and Management -

- (UIImage *)arrowImage
{
    // Retrieve from the image table
    UIImage *arrowImage = [self.imageTable objectForKey:kTOSegmentedControlArrowImage];
    if (arrowImage != nil) { return arrowImage; }

    // Generate for the first time
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:(CGSize){5.0, 3.0f}];
    arrowImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
        UIBezierPath* arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint: CGPointMake(4.71, 0.16)];
        [arrowPath addCurveToPoint: CGPointMake(5, 0.75) controlPoint1: CGPointMake(4.89, 0.3) controlPoint2: CGPointMake(5.01, 0.37)];
        [arrowPath addCurveToPoint: CGPointMake(4.57, 1.4) controlPoint1: CGPointMake(4.99, 1.13) controlPoint2: CGPointMake(4.8, 1.19)];
        [arrowPath addCurveToPoint: CGPointMake(3.28, 2.57) controlPoint1: CGPointMake(4.35, 1.62) controlPoint2: CGPointMake(3.61, 2.29)];
        [arrowPath addCurveToPoint: CGPointMake(2.95, 2.85) controlPoint1: CGPointMake(3.2, 2.67) controlPoint2: CGPointMake(3.08, 2.77)];
        [arrowPath addCurveToPoint: CGPointMake(2.5, 3) controlPoint1: CGPointMake(2.83, 2.94) controlPoint2: CGPointMake(2.67, 3)];
        [arrowPath addCurveToPoint: CGPointMake(2.05, 2.85) controlPoint1: CGPointMake(2.33, 3) controlPoint2: CGPointMake(2.17, 2.94)];
        [arrowPath addCurveToPoint: CGPointMake(1.72, 2.57) controlPoint1: CGPointMake(1.92, 2.77) controlPoint2: CGPointMake(1.8, 2.67)];
        [arrowPath addCurveToPoint: CGPointMake(0.43, 1.4) controlPoint1: CGPointMake(1.39, 2.29) controlPoint2: CGPointMake(0.65, 1.62)];
        [arrowPath addCurveToPoint: CGPointMake(0, 0.75) controlPoint1: CGPointMake(0.2, 1.19) controlPoint2: CGPointMake(0.01, 1.13)];
        [arrowPath addCurveToPoint: CGPointMake(0.29, 0.16) controlPoint1: CGPointMake(-0.01, 0.37) controlPoint2: CGPointMake(0.11, 0.3)];
        [arrowPath addCurveToPoint: CGPointMake(0.73, 0) controlPoint1: CGPointMake(0.41, 0.06) controlPoint2: CGPointMake(0.56, 0.01)];
        [arrowPath addCurveToPoint: CGPointMake(2.46, 0) controlPoint1: CGPointMake(0.81, 0) controlPoint2: CGPointMake(2.13, 0)];
        [arrowPath addCurveToPoint: CGPointMake(4.21, 0) controlPoint1: CGPointMake(2.87, 0) controlPoint2: CGPointMake(4.19, 0)];
        [arrowPath addCurveToPoint: CGPointMake(4.71, 0.16) controlPoint1: CGPointMake(4.42, -0) controlPoint2: CGPointMake(4.58, 0.06)];
        [arrowPath closePath];
        [UIColor.blackColor setFill];
        [arrowPath fill];
    }];

    // Force to always be template
    arrowImage = [arrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    // Save to the map table for next time
    [self.imageTable setObject:arrowImage forKey:kTOSegmentedControlArrowImage];

    return arrowImage;
}

- (UIImage *)separatorImage
{
    UIImage *separatorImage = [self.imageTable objectForKey:kTOSegmentedControlSeparatorImage];
    if (separatorImage != nil) { return separatorImage; }

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:(CGSize){1.0f, 3.0f}];
    separatorImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
        UIBezierPath* separatorPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 1, 3) cornerRadius:0.5];
        [UIColor.blackColor setFill];
        [separatorPath fill];
    }];

    // Format image to be resizable and tint-able.
    separatorImage = [separatorImage resizableImageWithCapInsets:(UIEdgeInsets){1.0f, 0.0f, 1.0f, 0.0f}
                                                    resizingMode:UIImageResizingModeTile];
    separatorImage = [separatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    return separatorImage;
}

- (NSMapTable *)imageTable
{
    // The map table is a global instance that allows all instances of
    // segmented controls to efficiently share the same images.

    // The images themselves are weakly referenced, so they will be cleaned
    // up from memory when all segmented controls using them are deallocated.

    if (_imageTable) { return _imageTable; }
    _imageTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                        valueOptions:NSPointerFunctionsWeakMemory];
    return _imageTable;
}

@end
