//
//  TOSegmentedControl.m
//  TOSegmentedControlExample
//
//  Created by Tim Oliver on 11/8/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOSegmentedControl.h"

@interface TOSegmentedControl ()

/** The items provided by the user, before translated into views */
@property (nonatomic, readwrite, copy) NSMutableArray *items;

/** The background rounded "track" view */
@property (nonatomic, strong) UIView *contentView;

/** The view that shows which view is highlighted */
@property (nonatomic, strong) UIView *thumbView;

/** The separator views between each of the items */
@property (nonatomic, strong) NSMutableArray<UIView *> *separatorViews;

/** The views set up for each item. */
@property (nonatomic, strong) NSMutableArray<UIView *> *itemViews;

@end

@implementation TOSegmentedControl

#pragma mark - Class Init -

- (instancetype)initWithItems:(NSString *)items
{
    if (self = [super initWithFrame:(CGRect){0.0f, 0.0f, 300.0f, 32.0f}]) {
        _items = [items mutableCopy];
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
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.layer.masksToBounds = YES;
    #ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) { self.contentView.layer.cornerCurve = kCACornerCurveContinuous; }
    #endif
    [self addSubview:self.contentView];

    // Create thumb view
    self.thumbView = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 100.0f, 28.0f)];
    self.thumbView.layer.shadowColor = [UIColor blackColor].CGColor;
    #ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) { self.thumbView.layer.cornerCurve = kCACornerCurveContinuous; }
    #endif
    [self.contentView addSubview:self.thumbView];

    // Set default values
    self.backgroundColor = nil;
    self.thumbColor = nil;
    self.cornerRadius = 8.0f;
    self.thumbInset = 2.0f;
    self.thumbShadowRadius = 3.0f;
    self.thumbShadowOffset = 2.0f;
    self.thumbShadowOpacity = 0.1f;
}

#pragma mark - Accessors -

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.contentView.layer.cornerRadius = cornerRadius;
    self.thumbView.layer.cornerRadius = (cornerRadius - _thumbInset) + 0.5f;
}

- (CGFloat)cornerRadius { return self.contentView.layer.cornerRadius; }

- (void)setThumbColor:(UIColor *)thumbColor
{
    self.thumbView.backgroundColor = thumbColor;
    if (self.thumbView.backgroundColor == nil) {
        self.thumbView.backgroundColor = [UIColor whiteColor];
    }
}
- (UIColor *)thumbColor { return self.thumbView.backgroundColor; }

- (void)setThumbInset:(CGFloat)thumbInset
{
    _thumbInset = thumbInset;
    self.thumbView.layer.cornerRadius = (self.cornerRadius - _thumbInset) + 0.5f;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.contentView.backgroundColor = backgroundColor;
    if (self.contentView.backgroundColor == nil) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.08f alpha:0.06666f];
    }
}
- (UIColor *)backgroundColor { return self.contentView.backgroundColor; }

- (void)setThumbShadowOffset:(CGFloat)thumbShadowOffset {self.thumbView.layer.shadowOffset = (CGSize){0.0f, thumbShadowOffset}; }
- (CGFloat)thumbShadowOffset { return self.thumbView.layer.shadowOffset.height; }

- (void)setThumbShadowOpacity:(CGFloat)thumbShadowOpacity { self.thumbView.layer.shadowOpacity = thumbShadowOpacity; }
- (CGFloat)thumbShadowOpacity { return self.thumbView.layer.shadowOpacity; }

- (void)setThumbShadowRadius:(CGFloat)thumbShadowRadius { self.thumbView.layer.shadowRadius = thumbShadowRadius; }
- (CGFloat)thumbShadowRadius { return self.thumbView.layer.shadowRadius; }

@end
