//
//  UIKit+Addition.h
//  GVPackages
//
//  Created by Gavin on 16/10/13.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionMacros.h"


#pragma --mark UIView

@interface UIView (Addition)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat rightMostX; //max x
@property (nonatomic, assign) CGFloat topY; //max y

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint bottomRightPoint;
@property (nonatomic, assign) CGPoint topLeftPoint;
@property (nonatomic, assign) CGPoint topRightPoint;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat cornerRadius;

+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size;
+ (UIView *)viewByRoundingAndStrokingImage:(UIImage *)image;
+ (UIImage *)imageFromView:(UIView *)view;

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag;
- (id)superviewOfKind:(Class)kind;

- (void)pulsateOnce;

//gesture
- (UITapGestureRecognizer *)addTapRecognizer:(id)target action:(SEL)action;
- (UIPanGestureRecognizer *)addPanRecognizer:(id)target action:(SEL)action;


//transition
- (void)transitionToSubview:(UIView *)view option:(UIViewAnimationOptions)option duration:(CGFloat)duration;

@end

#pragma --mark UIColor

@interface UIColor (Addition)
+ (UIColor *)randomColor;
+ (UIColor *)randomColorMix:(UIColor *)color;
/**
 *  create a UIColor object with the string
 *
 *  @param string the color string, must in this format: {white, alpha} or {red, gree, blue, alpha}
 *
 *  @return a UIColor object
 *
 *  @discuss use this method pair with the .string method.
 */
+ (UIColor *)colorWithString:(NSString *)string;
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
+ (NSArray*)colorWithHexString: (NSString *) stringToConvert;
- (NSString *)string;
- (UIColor *)lighten:(float)amount; //amount: 0-1
- (UIColor *)darken:(float)amount;

@end

#pragma mark - UIImage

@interface UIImage (Addition)

+ (UIImage *)imageByScalingImage:(UIImage *)image toSize:(CGSize)newSize;
+ (UIImage *)imageByColorizingImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *) circularImageWithColor:(UIColor *)color
                                size:(CGSize)size;

- (UIImage *) imageWithMinimumSize:(CGSize)size;

+ (UIImage *) stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *) stepperMinusImageWithColor:(UIColor *)color;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius;

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage max:(CGFloat)maxwidth;
-(UIImage*)scaleToSize:(CGSize)size;
@end


