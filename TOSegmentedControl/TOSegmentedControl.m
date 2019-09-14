//
//  TOSegmentedControl.m
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

#import "TOSegmentedControl.h"
#import "TOSegmentedControlItem.h"

// ----------------------------------------------------------------
// Static Members

// A cache to hold images generated for this view that may be shared.
static NSMapTable *_imageTable = nil;

// Statically referenced key names for the images stored in the map table.
static NSString * const kTOSegmentedControlArrowImage = @"arrowIcon";
static NSString * const kTOSegmentedControlSeparatorImage = @"separatorImage";

// When tapped the amount the focused elements will shrink / fade
static CGFloat const kTOSegmentedControlSelectedTextAlpha = 0.3f;
static CGFloat const kTOSegmentedControlSelectedScale = 0.95f;

// ----------------------------------------------------------------
// Private Members

@interface TOSegmentedControl ()

/** The private list of item objects, storing state and view data */
@property (nonatomic, strong) NSMutableArray<TOSegmentedControlItem *> *itemObjects;

/** Keep track when the user taps explicitily on the thumb view */
@property (nonatomic, assign) BOOL isDraggingThumbView;

/** Before we commit to a new selected index, this is the index the user has dragged over */
@property (nonatomic, assign) NSInteger focusedIndex;

/** The background rounded "track" view */
@property (nonatomic, strong) UIView *trackView;

/** The view that shows which view is highlighted */
@property (nonatomic, strong) UIView *thumbView;

/** The separator views between each of the items */
@property (nonatomic, strong) NSMutableArray<UIView *> *separatorViews;

/** A weakly retained image table that holds cached images for us. */
@property (nonatomic, readonly) NSMapTable *imageTable;

/** An arrow icon used to denote when a view is reversible. */
@property (nonatomic, readonly) UIImage *arrowImage;

/** A rounded line used as the separator line. */
@property (nonatomic, readonly) UIImage *separatorImage;

/** The width of each segment */
@property (nonatomic, readonly) CGFloat segmentWidth;

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
    self.trackView.userInteractionEnabled = NO;
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

    // Create list for managing each item
    self.itemObjects = [NSMutableArray array];
    
    // Create containers for views
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
    self.thumbShadowOpacity = 0.13f;
    
    // Configure view interaction
    // When the user taps down in the view
    [self addTarget:self
             action:@selector(didTapDown:withEvent:)
   forControlEvents:UIControlEventTouchDown];
    
    // When the user drags, either inside or out of the view
    [self addTarget:self
             action:@selector(didDragTap:withEvent:)
   forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
    
    // When the user's finger leaves the bounds of the view
    [self addTarget:self
             action:@selector(didExitTapBounds:withEvent:)
   forControlEvents:UIControlEventTouchDragExit];
    
    // When the user's finger re-enters the bounds
    [self addTarget:self
             action:@selector(didEnterTapBounds:withEvent:)
   forControlEvents:UIControlEventTouchDragEnter];
    
    // When the user taps up, either inside or out
    [self addTarget:self
             action:@selector(didEndTap:withEvent:)
   forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
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

#pragma mark - Public Item Access -

- (nullable UIImage *)imageForItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.itemObjects.count) { return nil; }
    return [self objectForItemAtIndex:index class:UIImage.class];
}

- (nullable NSString *)titleForItemAtIndex:(NSInteger)index
{
    return [self objectForItemAtIndex:index class:UILabel.class];
}

- (nullable id)objectForItemAtIndex:(NSInteger)index class:(Class)class
{
    // Make sure the index provided is valid
    if (index < 0 || index >= self.items.count) { return nil; }

    // Return the item only if it is an image
    id item = self.items[index];
    if ([item isKindOfClass:class]) { return item; }
    
    // Return nil if a label or anything else
    return nil;
}

#pragma mark Replacing Items

- (void)setImage:(UIImage *)image forItemAtIndex:(NSInteger)index
{
    [self setObject:image forItemAtIndex:index];
}

- (void)setTitle:(NSString *)title forItemAtIndex:(NSInteger)index
{
    [self setObject:title forItemAtIndex:index];
}

- (void)setObject:(id)object forItemAtIndex:(NSInteger)index
{
    NSAssert([object isKindOfClass:NSString.class] || [object isKindOfClass:UIImage.class],
                @"TOSegmentedControl: Only images and strings are supported.");
    
    // Make sure we don't go out of bounds
    if (index < 0 || index >= self.items.count) { return; }
    
    // Remove the item from the item list and insert the new one
    NSMutableArray *items = [self.items mutableCopy];
    [items removeObjectAtIndex:index];
    [items insertObject:object atIndex:index];
    _items = [NSArray arrayWithArray:items];
    
    // Update the item object at that point for the new item
    TOSegmentedControlItem *item = self.itemObjects[index];
    if ([object isKindOfClass:UILabel.class]) { item.title = object; }
    if ([object isKindOfClass:UIImage.class]) { item.image = object; }
    
    // Re-layout the views
    [self setNeedsLayout];
}

#pragma mark Deleting Items

- (void)removeAllItems
{
    // Remove all item objects
    self.itemObjects = [NSMutableArray array];

    // Remove all separators
    for (UIView *separator in self.separatorViews) {
        [separator removeFromSuperview];
    }
    [self.separatorViews removeAllObjects];

    // Delete the items array
    self.items = nil;
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
    CGRect frame = [self frameForItemAtSegment:self.selectedSegmentIndex];
    self.thumbView.frame = frame;

    // Match the shadow path to the size of the thumb view
    CGPathRef oldShadowPath = self.thumbView.layer.shadowPath;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, frame.size}
                                                          cornerRadius:self.cornerRadius - self.thumbInset];

    // If the segmented control is animating its shape, to prevent the
    // shadow from visibly snapping, perform a resize animation on it
    CABasicAnimation *boundsAnimation = [self.layer animationForKey:@"bounds.size"];
    if (oldShadowPath != NULL && boundsAnimation) {
        CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        shadowAnimation.fromValue = (__bridge id)oldShadowPath;
        shadowAnimation.toValue = (id)shadowPath.CGPath;
        shadowAnimation.duration = boundsAnimation.duration;
        shadowAnimation.timingFunction = boundsAnimation.timingFunction;
        [self.thumbView.layer addAnimation:shadowAnimation forKey:@"shadowPath"];
    }
    self.thumbView.layer.shadowPath = shadowPath.CGPath;

    // Lay out the item views
    NSInteger i = 0;
    for (TOSegmentedControlItem *item in self.itemObjects) {
        UIView *itemView = item.itemView;
        [self.trackView addSubview:itemView];
        
        // Size to fit
        [itemView sizeToFit];

        // Lay out the frame
        CGRect thumbFrame = [self frameForItemAtSegment:i];
        itemView.center = (CGPoint){CGRectGetMidX(thumbFrame),
                                    CGRectGetMidY(thumbFrame)};
        
        // Make sure they are all unselected
        [self setItemAtIndex:i++ selected:NO];
    }

    // Set the selected item
    [self setItemAtIndex:self.selectedSegmentIndex selected:YES];
    
    // Lay out the separators
    CGFloat xOffset = (_thumbInset + segmentWidth) - 1.0f;
    i = 0;
    for (UIView *separatorView in self.separatorViews) {
        frame = separatorView.frame;
        frame.size.width = 1.0f;
        frame.size.height = (size.height - (self.cornerRadius) * 2.0f) + 2.0f;
        frame.origin.x = xOffset + (segmentWidth * i);
        frame.origin.y = (size.height - frame.size.height) * 0.5f;
        separatorView.frame = CGRectIntegral(frame);
        i++;
    }
    
    // Update the alpha of the separator views
    [self refreshSeparatorViewsForSelectedIndex:index];
}

- (CGFloat)segmentWidth
{
    return floorf((self.bounds.size.width - (_thumbInset * 2.0f)) / self.numberOfSegments);
}

- (CGRect)frameForItemAtSegment:(NSInteger)index
{
    CGSize size = self.trackView.frame.size;
    
    CGRect frame = CGRectZero;
    frame.origin.x = _thumbInset + (self.segmentWidth * index) + ((_thumbInset * 2.0f) * index);
    frame.origin.y = _thumbInset;
    frame.size.width = self.segmentWidth;
    frame.size.height = size.height - (_thumbInset * 2.0f);
    
    // Cap the position of the frame so it won't overshoot
    frame.origin.x = MAX(_thumbInset, frame.origin.x);
    frame.origin.x = MIN(size.width - (self.segmentWidth + _thumbInset), frame.origin.x);
    
    return CGRectIntegral(frame);
}

- (NSInteger)segmentIndexForPoint:(CGPoint)point
{
    CGFloat segmentWidth = floorf(self.frame.size.width / self.numberOfSegments);
    NSInteger segment = floorf(point.x / segmentWidth);
    segment = MAX(segment, 0);
    segment = MIN(segment, self.numberOfSegments-1);
    return segment;
}

- (void)setThumbViewShrunken:(BOOL)shrunken
{
    CGFloat scale = shrunken ? kTOSegmentedControlSelectedScale : 1.0f;
    self.thumbView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                      scale, scale);
}

- (void)setItemViewAtIndex:(NSInteger)segmentIndex shrunken:(BOOL)shrunken
{
    NSAssert(segmentIndex >= 0 && segmentIndex < self.items.count,
             @"TOSegmentedControl: Array should not be out of bounds");
    
    UIView *itemView = self.itemObjects[segmentIndex].itemView;
    CGFloat scale = shrunken ? kTOSegmentedControlSelectedScale : 1.0f;
    itemView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                      scale, scale);
}

- (void)setItemAtIndex:(NSInteger)index selected:(BOOL)selected
{
    NSAssert(index >= 0 && index < self.itemObjects.count,
             @"TOSegmentedControl:  Array should not be out of bounds");
    
    UILabel *label = (UILabel *)self.itemObjects[index].label;
    if (label == nil) { return; }

    // Capture its current position and scale
    CGPoint center = label.center;
    CGAffineTransform transform = label.transform;
    
    // Reset its transform so we don't mangle the frame
    label.transform = CGAffineTransformIdentity;
    
    // Set the font
    UIFont *font = selected ? self.selectedTextFont : self.textFont;
    label.font = font;
    
    // Resize the frame in case the new font exceeded the bounds
    [label sizeToFit];
    
    // Re-apply the transform and the positioning
    label.transform = transform;
    label.center = center;
}

- (void)setItemAtIndex:(NSInteger)index faded:(BOOL)faded
{
    NSAssert(index >= 0 && index < self.itemObjects.count,
             @"Array should not be out of bounds");
    UIView *itemView = self.itemObjects[index].itemView;
    itemView.alpha = faded ? kTOSegmentedControlSelectedTextAlpha : 1.0f;
}

- (void)refreshSeparatorViewsForSelectedIndex:(NSInteger)index
{
    // Hide the separators on either side of the selected segment
    NSInteger i = 0;
    for (UIView *separatorView in self.separatorViews) {
        separatorView.alpha = (i == index || i == (index - 1)) ? 0.0f : 1.0f;
        i++;
    }
}

#pragma mark - Touch Interaction -

- (void)didTapDown:(UIControl *)control withEvent:(UIEvent *)event
{
    // Determine which segment the user tapped
    CGPoint tapPoint = [event.allTouches.anyObject locationInView:self];
    NSInteger tappedIndex = [self segmentIndexForPoint:tapPoint];
    
    // Work out if we tapped on the thumb view, or on an un-selected segment
    self.isDraggingThumbView = (tappedIndex == self.selectedSegmentIndex);
    
    // Capture the index we are focussing on
    self.focusedIndex = tappedIndex;
    
    // Work out which animation effects to apply
    if (!self.isDraggingThumbView) {
        [UIView animateWithDuration:0.45f animations:^{
            [self setItemAtIndex:tappedIndex faded:YES];
        }];
        return;
    }
    
    id animationBlock = ^{
        [self setThumbViewShrunken:YES];
        [self setItemViewAtIndex:self.selectedSegmentIndex shrunken:YES];
    };
    
    // Animate the transition
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animationBlock
                     completion:nil];
}

- (void)didDragTap:(UIControl *)control withEvent:(UIEvent *)event
{
    CGPoint tapPoint = [event.allTouches.anyObject locationInView:self];
    NSInteger tappedIndex = [self segmentIndexForPoint:tapPoint];
    
    if (tappedIndex == self.focusedIndex) { return; }
    
    // Handle transitioning when not dragging the thumb view
    if (!self.isDraggingThumbView) {
        // If we dragged out of the bounds, disregard
        if (self.focusedIndex < 0) { return; }
        
        id animationBlock = ^{
            // Deselect the current item
            [self setItemAtIndex:self.focusedIndex faded:NO];
            
            // Fade the text if it is NOT the thumb track one
            if (tappedIndex != self.selectedSegmentIndex) {
                [self setItemAtIndex:tappedIndex faded:YES];
            }
        };
        
        // Perform a faster change over animation
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animationBlock
                         completion:nil];
        
        // Update the focused item
        self.focusedIndex = tappedIndex;
        return;
    }
    
    // Get the new frame of the segment
    CGRect frame = [self frameForItemAtSegment:tappedIndex];
    
    // Work out the center point from the frame
    CGPoint center = (CGPoint){CGRectGetMidX(frame), CGRectGetMidY(frame)};
    
    // Create the animation block
    id animationBlock = ^{
        self.thumbView.center = center;
        
        // Deselect the focused item
        [self setItemAtIndex:self.focusedIndex selected:NO];
        [self setItemViewAtIndex:self.focusedIndex shrunken:NO];
        
        // Select the new one
        [self setItemAtIndex:tappedIndex selected:YES];
        [self setItemViewAtIndex:tappedIndex shrunken:YES];
        
        // Update the separators
        [self refreshSeparatorViewsForSelectedIndex:tappedIndex];
    };
    
    // Perform the animation
    [UIView animateWithDuration:0.45
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animationBlock
                     completion:nil];
    
    // Update the focused item
    self.focusedIndex = tappedIndex;
}

- (void)didExitTapBounds:(UIControl *)control withEvent:(UIEvent *)event
{
    // No effects needed when tracking the thumb view
    if (self.isDraggingThumbView) { return; }
    
    // Un-fade the focused item
    [UIView animateWithDuration:0.45f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ [self setItemAtIndex:self.focusedIndex faded:NO]; }
                     completion:nil];
    
    // Disable the focused index
    self.focusedIndex = -1;
}

- (void)didEnterTapBounds:(UIControl *)control withEvent:(UIEvent *)event
{
    // No effects needed when tracking the thumb view
    if (self.isDraggingThumbView) { return; }
    
    CGPoint tapPoint = [event.allTouches.anyObject locationInView:self];
    self.focusedIndex = [self segmentIndexForPoint:tapPoint];
    
    // Un-fade the focused item
    [UIView animateWithDuration:0.45f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ [self setItemAtIndex:self.focusedIndex faded:YES]; }
                     completion:nil];
}

- (void)didEndTap:(UIControl *)control withEvent:(UIEvent *)event
{
    // If we WEREN'T dragging the thumb view, work out where we need to move to
    if (!self.isDraggingThumbView) {
        if (self.focusedIndex < 0) { return; }
        
        self.selectedSegmentIndex = self.focusedIndex;
        self.focusedIndex = -1;
        
        id animationBlock = ^{
            for (NSInteger i = 0; i < self.itemObjects.count; i++) {
                [self.itemObjects[i].itemView setAlpha:1.0f];
            }
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        };
        
        [UIView animateWithDuration:0.45
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:2.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animationBlock
                         completion:nil];
        
        if (self.segmentTappedHandler) {
            self.segmentTappedHandler(self.selectedSegmentIndex, NO);
        }
        
        return;
    }
    
    // Update the state and alert the delegate
    self.selectedSegmentIndex = self.focusedIndex;
    if (self.segmentTappedHandler) {
        self.segmentTappedHandler(self.selectedSegmentIndex, NO);
    }
    
    // Work out which animation effects to apply
    id animationBlock = ^{
        [self setThumbViewShrunken:NO];
        [self setItemViewAtIndex:self.selectedSegmentIndex shrunken:NO];
    };

    // Animate the transition
    [UIView animateWithDuration:0.3f
                         delay:0.0f
        usingSpringWithDamping:1.0f
         initialSpringVelocity:0.1f
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:animationBlock
                    completion:nil];
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

    // Create the list of item objects  to track their state
    _itemObjects = [TOSegmentedControlItem itemsWithObjects:_items
                                        forSegmentedControl:self].mutableCopy;
    
    // Update the number of separators
    [self updateSeparatorViewCount];

    // Trigger a layout update
    [self setNeedsLayout];
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
    for (TOSegmentedControlItem *item in self.itemObjects) {
        [item refreshItemView];
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

    // Set each item to adopt the new font
    for (TOSegmentedControlItem *item in self.itemObjects) {
        [item refreshItemView];
    }
}

// -----------------------------------------------
// Selected Text Font

- (void)setSelectedTextFont:(UIFont *)selectedTextFont
{
    _selectedTextFont = selectedTextFont;
    if (_selectedTextFont == nil) {
        _selectedTextFont = [UIFont systemFontOfSize:13.0f weight:UIFontWeightSemibold];
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

- (NSInteger)numberOfSegments { return self.itemObjects.count; }

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
