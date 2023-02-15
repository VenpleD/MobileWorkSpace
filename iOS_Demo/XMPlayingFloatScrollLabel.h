//
//  XMPlayingFloatScrollLabel.h
//  XMNowPlayingModule
//
//  Created by wenpu.duan on 2022/11/3.
//  Copyright © 2022 xmly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 使用的时候，涉及到倒计时修改此label的text时，font要用此api方法monospacedDigitSystemFontOfSize，不然会频繁抖动
@interface XMPlayingFloatScrollLabel : UIView

/// 数值越大，速度越快   默认 5px /(秒)
@property (nonatomic, assign) CGFloat speed;

/// 滚动到边缘停留的时间
@property (nonatomic, assign) CGFloat interval;

/// 边缘遮罩长度，默认10px
@property (nonatomic, assign) CGFloat maskLength;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSAttributedString *attributedText;

@property (nonatomic, strong) UIColor *textColor;

@end

NS_ASSUME_NONNULL_END
