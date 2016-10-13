//
//  UIKit+Addition.m
//  GVPackages
//
//  Created by Gavin on 16/10/13.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "UIKit+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "AdditionMacros.h"

@implementation UIView (Addition)

#pragma mark -
#pragma mark getter
- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)rightMostX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)topY { //(x, y): (0, 0)
    return CGRectGetMaxY(self.frame);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGPoint)bottomRightPoint {
    return CGPointMake(self.rightMostX, self.y);
}

- (CGPoint)topLeftPoint {
    return CGPointMake(self.x, self.topY);
}

- (CGPoint)topRightPoint {
    return CGPointMake(self.rightMostX, self.topY);
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

- (id)superviewOfKind:(Class)kind {
    UIView *superview = self.superview;
    while (superview && ![superview isKindOfClass:kind]) {
        superview = self.superview;
    }
    return superview;
}


#pragma mark -
#pragma mark setter
- (void)setX:(CGFloat)x {
    self.frame = (CGRect){x, self.y, self.size};
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect){self.x, y, self.size};
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect){self.origin, width, self.height};
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect){self.origin, self.width, height};
}

- (void)setRightMostX:(CGFloat)rightMostX {
    self.frame = (CGRect){rightMostX-self.width, self.y, self.size};
}

- (void)setTopY:(CGFloat)topY {
    self.frame = (CGRect){self.x, topY-self.height, self.size};
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.size};
}

- (void)setBottomRightPoint:(CGPoint)bottomRightPoint {
    self.frame = (CGRect){bottomRightPoint.x-self.width, bottomRightPoint.y, self.size};
}

- (void)setTopLeftPoint:(CGPoint)topLeftPoint {
    self.frame = (CGRect){topLeftPoint.x, topLeftPoint.y-self.height, self.size};
}

- (void)setTopRightPoint:(CGPoint)topRightPoint {
    self.frame = (CGRect){topRightPoint.x-self.width, topRightPoint.y-self.height, self.size};
}

- (void)setSize:(CGSize)size {
    self.frame = (CGRect){self.origin, size};
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    GVIfReturn(cornerRadius<0);
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark -
#pragma mark convenient
+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size {
    UIView *view = [[self alloc] initWithFrame:(CGRect){0, 0, size}];
    view.backgroundColor = color;
    
    return view;
}

+ (UIView *)viewByRoundingAndStrokingImage:(UIImage *)image {
    // make new layer to contain shadow and masked image
    CGRect rect = (CGRect){0, 0, image.size};
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 2.5f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 1.f);
    containerLayer.shadowOpacity = 0.8;
    
    // use the image to mask the image into a circle
    CALayer *contentLayer = [CALayer layer];
    contentLayer.contents = (id)image.CGImage;
    contentLayer.frame = rect;
    
    contentLayer.borderColor = [UIColor colorWithRed:0.825 green:0.82 blue:0.815 alpha:1.0].CGColor;
    contentLayer.borderWidth = 1.0;
    contentLayer.cornerRadius = 6.0;
    contentLayer.masksToBounds = YES;
    
    // add masked image layer into container layer so that it's shadowed
    [containerLayer addSublayer:contentLayer];
    
    // add container including masked image and shadow into view
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:contentLayer];
    
    return view;
}

+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark -
#pragma mark animation
- (void)pulsateOnce {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleUp.duration = 0.125;
    scaleUp.repeatCount = 1;
    scaleUp.autoreverses = YES;
    scaleUp.removedOnCompletion = YES;
    scaleUp.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [self.layer addAnimation:scaleUp forKey:@"pulsate"];
}



#pragma mark -
#pragma mark transition
- (void)transitionToSubview:(UIView *)view option:(UIViewAnimationOptions)option duration:(CGFloat)duration {
    [UIView transitionWithView:self
                      duration:duration
                       options:option
                    animations:^{[self addSubview:view];}
                    completion:nil];
}




#pragma mark -
#pragma mark gesture
- (UITapGestureRecognizer *)addTapRecognizer:(id)target action:(SEL)action {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    
    if(!self.userInteractionEnabled) self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    return tapRecognizer;
}

- (UIPanGestureRecognizer *)addPanRecognizer:(id)target action:(SEL)action {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    
    if(!self.userInteractionEnabled) self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
    
    return panRecognizer;
}




- (void)whenTouches:(NSUInteger)numTouches tapped:(NSUInteger)numTaps handler:(CallbackTask)task {
}
- (void)whenTapped:(CallbackTask)task {
    //Adds a recognizer for one finger tapping once.
}
- (void)whenDoubleTapped:(CallbackTask)task {
}
- (void)eachSubview:(void(^)(UIView *view))task {
}
- (void)onTouchDow:(CallbackTask)task {
}
- (void)onTouchMove:(CallbackTask)task {
}
- (void)onTouchUp:(CallbackTask)task {
}

@end


#define kBracketBigBegin            @"{"
#define kBracketBigEnd              @"}"
#define kSeparatorComma             @","



@implementation UIColor (Addition)
+ (UIColor *)randomColor {
    int red = arc4random_uniform(256);
    int green = arc4random_uniform(256);
    int blue = arc4random_uniform(256);
    return GVRGB(red, green, blue);
}

+ (UIColor *)randomColorMix:(UIColor *)color {
    UIColor *originalColor = [self randomColor];
    
    CGFloat red, green, blue;
    [originalColor getRed:&red green:&green blue:&blue alpha:nil];
    
    CGFloat mixRed, mixGreen, mixBlue;
    [color getRed:&mixRed green:&mixGreen blue:&mixBlue alpha:nil];
    
    return GVRGB_F((red+mixRed)/2, (green+mixGreen)/2, (blue+mixBlue)/2);
}

+ (UIColor *)colorWithString:(NSString *)string {
    if(![string hasPrefix:kBracketBigBegin] || ![string hasSuffix:kBracketBigEnd]) return nil;
    
    NSString *colorValue = [string substringWithRange:NSMakeRange(1, string.length-2)];
    NSArray *token = [colorValue componentsSeparatedByString:kSeparatorComma];
    UIColor *color = nil;
    if (token.count == 2) { //in white mode
        CGFloat white = [token[0] doubleValue];
        CGFloat alpha = [token[1] doubleValue];
        
        color = [UIColor colorWithWhite:white alpha:alpha];
        return color;
    }
    
    if (token.count == 4) { //in R, G, B mode
        CGFloat red = [token[0] doubleValue];
        CGFloat green = [token[1] doubleValue];
        CGFloat blue = [token[2] doubleValue];
        CGFloat alpha = [token[3] doubleValue];
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        return color;
    }
    
    return nil;
}

+ (NSArray*)colorWithHexString: (NSString *) stringToConvert
{
    //去掉前后空格换行符
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6)
        return @[[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1]];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return  @[[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1]];;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //NSLog(@"r = %u, g = %u, b = %u",r, g, b);
    return  @[[NSNumber numberWithInt:r],[NSNumber numberWithInt:g],[NSNumber numberWithInt:b]];;
    
}

- (NSString *)string {
    NSString *string = nil;
    
    const CGFloat *comps = CGColorGetComponents(self.CGColor);
    NSInteger count = CGColorGetNumberOfComponents(self.CGColor);
    
    if (count == 2) {
        string = GVString(@"{%0.3f,%0.3f}", comps[0], comps[1]);
    } else if (count == 4) {
        string = GVString(@"{%0.3f,%0.3f,%0.3f,%0.3f}", comps[0], comps[1], comps[2], comps[3]);
    }
    return string;
}


- (UIColor *)lighten:(float)amount {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        float newB = b * (1 + amount);
        return [UIColor colorWithHue:h saturation:s brightness:newB alpha:a];
    }
    
    return self;
}

- (UIColor *)darken:(float)amount {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        float newB = b * (1 - amount);
        return [UIColor colorWithHue:h saturation:s brightness:newB alpha:a];
    }
    
    return self;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end


#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Addition)

+ (UIImage *)imageByScalingImage:(UIImage *)image toSize:(CGSize)newSize {
    //image.scale or [UIScreen mainScreen].scale)
    //create a graphics image context
    //used to be: UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)]; //draw in context
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); //new image
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageByColorizingImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = (CGRect){0, 0, image.size};
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    
    CGContextFillRect(context, area);
    CGContextRestoreGState(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color {
    //decode color
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    CGColorRef colorRef = color.CGColor;
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    const CGFloat *colors = CGColorGetComponents(colorRef);
    if (numComponents == 2) {
        red = green = blue = colors[0];
        alpha = colors[1];
    } else if (numComponents == 4) {
        red = colors[0];
        green = colors[1];
        blue = colors[2];
        alpha = colors[3];
    }
    
    //decode image
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(width * height * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPercomponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPercomponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, (CGRect){0, 0, width,height}, imageRef);
    CGContextRelease(context);
    
    // change color
    int byteIndex = 0;
    for (int ii=0; ii < width*height; ii++) {
        rawData[byteIndex] = (char)(red * 255);
        rawData[byteIndex+1] = (char)(green * 255);
        rawData[byteIndex+2] = (char)(blue * 255);
        //        if(rawData[byteIndex+3]>0) rawData[byteIndex+3] = (char)(alpha * 255);
        rawData[byteIndex+3] = (char)(alpha * rawData[byteIndex+3]);
        
        byteIndex += 4;
    }
    
    //create new image
    CGContextRef ctx;
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth(imageRef),
                                CGImageGetHeight(imageRef),
                                bitsPercomponent,
                                CGImageGetBytesPerRow(imageRef),
                                CGImageGetColorSpace(imageRef),
                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *renderedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(rawData);
    
    return renderedImage;
}

/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     vImage_Buffer outBuffer2;
     outBuffer2.data = pixelBuffer2;
     outBuffer2.width = CGImageGetWidth(img);
     outBuffer2.height = CGImageGetHeight(img);
     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    
    
    return returnImage;
}

- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor *)tintColor
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     vImage_Buffer outBuffer2;
     outBuffer2.data = pixelBuffer2;
     outBuffer2.width = CGImageGetWidth(img);
     outBuffer2.height = CGImageGetHeight(img);
     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGRect imageRect = {CGPointZero, self.size};
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextFillRect(ctx, imageRect);
        CGContextRestoreGState(ctx);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets {
    
    UIImage *topImage = [self imageWithColor:color cornerRadius:cornerRadius];
    UIImage *bottomImage = [self imageWithColor:shadowColor cornerRadius:cornerRadius];
    CGFloat totalHeight = edgeSizeFromCornerRadius(cornerRadius) + shadowInsets.top + shadowInsets.bottom;
    CGFloat totalWidth = edgeSizeFromCornerRadius(cornerRadius) + shadowInsets.left + shadowInsets.right;
    CGFloat topWidth = edgeSizeFromCornerRadius(cornerRadius);
    CGFloat topHeight = edgeSizeFromCornerRadius(cornerRadius);
    CGRect topRect = CGRectMake(shadowInsets.left, shadowInsets.top, topWidth, topHeight);
    CGRect bottomRect = CGRectMake(0, 0, totalWidth, totalHeight);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(totalWidth, totalHeight), NO, 0.0f);
    if (!CGRectEqualToRect(bottomRect, topRect)) {
        [bottomImage drawInRect:bottomRect];
    }
    [topImage drawInRect:topRect];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets resizeableInsets = UIEdgeInsetsMake(cornerRadius + shadowInsets.top,
                                                     cornerRadius + shadowInsets.left,
                                                     cornerRadius + shadowInsets.bottom,
                                                     cornerRadius + shadowInsets.right);
    return [buttonImage resizableImageWithCapInsets:resizeableInsets];
    
}

+ (UIImage *) circularImageWithColor:(UIColor *)color
                                size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [color setStroke];
    [circle addClip];
    [circle fill];
    [circle stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageWithMinimumSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0f);
    [self drawInRect:rect];
    UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
    return [resized resizableImageWithCapInsets:UIEdgeInsetsMake(size.height/2, size.width/2, size.height/2, size.width/2)];
}

+ (UIImage *) stepperPlusImageWithColor:(UIColor *)color {
    CGFloat iconEdgeSize = 15;
    CGFloat iconInternalEdgeSize = 3;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconEdgeSize, iconEdgeSize), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGFloat padding = (iconEdgeSize - iconInternalEdgeSize) / 2;
    CGContextFillRect(context, CGRectMake(padding, 0, iconInternalEdgeSize, iconEdgeSize));
    CGContextFillRect(context, CGRectMake(0, padding, iconEdgeSize, iconInternalEdgeSize));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) stepperMinusImageWithColor:(UIColor *)color {
    CGFloat iconEdgeSize = 15;
    CGFloat iconInternalEdgeSize = 3;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconEdgeSize, iconEdgeSize), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGFloat padding = (iconEdgeSize - iconInternalEdgeSize) / 2;
    CGContextFillRect(context, CGRectMake(0, padding, iconEdgeSize, iconInternalEdgeSize));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius {
    
    CGSize size;
    if (metrics == UIBarMetricsDefault) {
        size = CGSizeMake(50, 30);
    }
    else {
        size = CGSizeMake(60, 23);
    }
    
    
    UIBezierPath *path = [self bezierPathForBackButtonInRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:122 blue:245 alpha:0.0].CGColor);
    CGContextSetLineWidth(context, 3.0f);
    
    static CGFloat const k_tip_x = 8;
    static CGFloat const k_wing_x = 17;
    static CGFloat const k_wing_y_offset = 6;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGPoint tip = CGPointMake(k_tip_x, CGRectGetMidY(rect));
    CGPoint top = CGPointMake(k_wing_x, CGRectGetMinY(rect) + k_wing_y_offset);
    CGPoint bottom = CGPointMake(k_wing_x, CGRectGetMaxY(rect) - k_wing_y_offset);
    CGContextMoveToPoint(context, top.x, top.y);
    CGContextAddLineToPoint(context, tip.x, tip.y);
    CGContextAddLineToPoint(context, bottom.x, bottom.y);
    CGContextStrokePath(context);
    
    [color setFill];
    [path addClip];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // avoid tiling by stretching from the right-hand side only
    UIEdgeInsets insets = UIEdgeInsetsMake(k_wing_y_offset + 1 + cornerRadius, k_wing_x + 1 + cornerRadius,
                                           k_wing_y_offset + 1 + cornerRadius, 1 + cornerRadius);
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        return [image resizableImageWithCapInsets:insets
                                     resizingMode:UIImageResizingModeStretch];
        
    } else {
        return [image resizableImageWithCapInsets:insets];
    }
    
}


+ (UIBezierPath *) bezierPathForBackButtonInRect:(CGRect)rect cornerRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint mPoint = CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y);
    CGPoint ctrlPoint = mPoint;
    [path moveToPoint:mPoint];
    
    ctrlPoint.y += radius;
    mPoint.x += radius;
    mPoint.y += radius;
    if (radius > 0) [path addArcWithCenter:ctrlPoint radius:radius startAngle:(float)M_PI + (float)M_PI_2 endAngle:0 clockwise:YES];
    
    mPoint.y = CGRectGetMaxY(rect) - radius;
    [path addLineToPoint:mPoint];
    
    ctrlPoint = mPoint;
    mPoint.y += radius;
    mPoint.x -= radius;
    ctrlPoint.x -= radius;
    if (radius > 0) [path addArcWithCenter:ctrlPoint radius:radius startAngle:0 endAngle:(float)M_PI_2 clockwise:YES];
    
    mPoint.x = rect.origin.x + (10.0f);
    [path addLineToPoint:mPoint];
    
    [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMidY(rect))];
    
    mPoint.y = rect.origin.y;
    [path addLineToPoint:mPoint];
    
    [path closePath];
    return path;
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapByteOrderMask);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage max:(CGFloat)maxwidth{
    if (sourceImage.size.width < maxwidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = maxwidth;
        btWidth = sourceImage.size.width * (maxwidth / sourceImage.size.height);
    } else {
        btWidth = maxwidth;
        btHeight = sourceImage.size.height * (maxwidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end




