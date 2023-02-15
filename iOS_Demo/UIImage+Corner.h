//
//  UIImage+Corner.h
//  Sound
//
//  Created by duanwenpu on 2021/11/3.
//  Copyright © 2021 xmly. All rights reserved.
//
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Corner)

+ (UIImage *)createPureColorImage:(UIColor *)color corner:(CGFloat)corner rect:(CGRect)rect;

+ (UIImage *)createPureColorImage:(UIColor *)color topLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight rect:(CGRect)rect;

+ (UIImage *)createGradientColorImage:(CAGradientLayer *)gradientLayer corner:(CGFloat)corner rect:(CGRect)rect;

+ (UIImage *)createGradientColorImage:(CAGradientLayer *)gradientLayer topLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
