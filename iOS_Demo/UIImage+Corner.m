//
//  UIImage+Corner.m
//  Sound
//
//  Created by duanwenpu on 2021/11/3.
//  Copyright © 2021 xmly. All rights reserved.
//

#import "UIImage+Corner.h"

@implementation UIImage (Corner)

+ (UIImage *)createPureColorImage:(UIColor *)color corner:(CGFloat)corner rect:(CGRect)rect {
    return [self createPureColorImage:color topLeft:corner topRight:corner bottomLeft:corner bottomRight:corner rect:rect];
}

+ (UIImage *)createPureColorImage:(UIColor *)color topLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight rect:(CGRect)rect {
    UIBezierPath *roundedPath = [self createRoundedPath:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight rect:rect];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, roundedPath.CGPath);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGContextClip(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)createGradientColorImage:(CAGradientLayer *)gradientLayer corner:(CGFloat)corner rect:(CGRect)rect {
    return [self createGradientColorImage:gradientLayer topLeft:corner topRight:corner bottomLeft:corner bottomRight:corner rect:rect];
}

+ (UIImage *)createGradientColorImage:(CAGradientLayer *)gradientLayer topLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight rect:(CGRect)rect {
    UIBezierPath *roundedPath = [self createRoundedPath:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight rect:rect];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, roundedPath.CGPath);
    CGContextClip(context);
    [gradientLayer renderInContext:context];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIBezierPath *)createRoundedPath:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight rect:(CGRect)rect {
    NSLog(@"corner--------%@--%@--%@--%@--", @(topLeft), @(topRight), @(bottomLeft), @(bottomRight));
    CGFloat imageWidth = CGRectGetWidth(rect);
    CGFloat imageHeight = CGRectGetHeight(rect);
    UIBezierPath *roundedPath = [UIBezierPath bezierPath];
    if (topLeft > 0) {
        [roundedPath moveToPoint:CGPointMake(0, topLeft)];
        [roundedPath addArcWithCenter:CGPointMake(topLeft, topLeft) radius:topLeft startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    } else {
        [roundedPath moveToPoint:CGPointMake(0, 0)];
    }
    if (topRight > 0) {
        [roundedPath addLineToPoint:CGPointMake(imageWidth - topRight, 0)];
        [roundedPath addArcWithCenter:CGPointMake(imageWidth - topRight, topRight) radius:topRight startAngle:M_PI * 1.5 endAngle:0 clockwise:YES];
    } else {
        [roundedPath addLineToPoint:CGPointMake(imageWidth, 0)];
    }
    if (bottomRight > 0) {
        [roundedPath addLineToPoint:CGPointMake(imageWidth, imageHeight - bottomRight)];
        [roundedPath addArcWithCenter:CGPointMake(imageWidth - bottomRight, imageHeight - bottomRight) radius:bottomRight startAngle:0 endAngle:M_PI_2 clockwise:YES];
    } else {
        [roundedPath addLineToPoint:CGPointMake(imageWidth, imageHeight)];
    }
    if (bottomLeft > 0) {
        [roundedPath addLineToPoint:CGPointMake(bottomLeft, imageHeight)];
        [roundedPath addArcWithCenter:CGPointMake(bottomLeft, imageHeight - bottomLeft) radius:bottomLeft startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    } else {
        [roundedPath addLineToPoint:CGPointMake(0, imageHeight)];
    }
    [roundedPath closePath];
    return roundedPath;
}

@end
