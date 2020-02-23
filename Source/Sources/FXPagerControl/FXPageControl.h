//
//  FXPageControl.h
//
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#import <UIKit/UIKit.h>


#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


extern const CGPathRef FXPageControlDotShapeCircle;
extern const CGPathRef FXPageControlDotShapeSquare;
extern const CGPathRef FXPageControlDotShapeTriangle;


@protocol FXPageControlDelegate;


IB_DESIGNABLE @interface FXPageControl : UIControl

- (void)setUp;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
- (void)updateCurrentPageDisplay;

@property (nonatomic, weak_delegate) IBOutlet id <FXPageControlDelegate> delegate;

@property (nonatomic, assign) IBInspectable NSInteger currentPage;
@property (nonatomic, assign) IBInspectable NSInteger numberOfPages;
@property (nonatomic, assign) IBInspectable BOOL defersCurrentPageDisplay;
@property (nonatomic, assign) IBInspectable BOOL hidesForSinglePage;
@property (nonatomic, assign, getter = isWrapEnabled) IBInspectable BOOL wrapEnabled;
@property (nonatomic, assign, getter = isVertical) IBInspectable BOOL vertical;

@property (nonatomic, strong) IBInspectable UIImage *dotImage;
@property (nonatomic, assign) IBInspectable CGPathRef dotShape;
@property (nonatomic, assign) IBInspectable CGFloat dotSize;
@property (nonatomic, strong) IBInspectable UIColor *dotColor;
@property (nonatomic, strong) IBInspectable UIColor *dotShadowColor;
@property (nonatomic, assign) IBInspectable CGFloat dotShadowBlur;
@property (nonatomic, assign) IBInspectable CGSize dotShadowOffset;

@property (nonatomic, strong) IBInspectable UIImage *selectedDotImage;
@property (nonatomic, assign) IBInspectable CGPathRef selectedDotShape;
@property (nonatomic, assign) IBInspectable CGFloat selectedDotSize;
@property (nonatomic, strong) IBInspectable UIColor *selectedDotColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedDotShadowColor;
@property (nonatomic, assign) IBInspectable CGFloat selectedDotShadowBlur;
@property (nonatomic, assign) IBInspectable CGSize selectedDotShadowOffset;

@property (nonatomic, assign) IBInspectable CGFloat dotSpacing;

@end


@protocol FXPageControlDelegate <NSObject>
@optional

- (UIImage *)pageControl:(FXPageControl *)pageControl imageForDotAtIndex:(NSInteger)index;
- (CGPathRef)pageControl:(FXPageControl *)pageControl shapeForDotAtIndex:(NSInteger)index;
- (UIColor *)pageControl:(FXPageControl *)pageControl colorForDotAtIndex:(NSInteger)index;

- (UIImage *)pageControl:(FXPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index;
- (CGPathRef)pageControl:(FXPageControl *)pageControl selectedShapeForDotAtIndex:(NSInteger)index;
- (UIColor *)pageControl:(FXPageControl *)pageControl selectedColorForDotAtIndex:(NSInteger)index;

@end


#pragma GCC diagnostic pop
