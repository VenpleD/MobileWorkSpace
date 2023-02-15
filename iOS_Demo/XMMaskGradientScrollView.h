//
//  XMMaskGradientScrollView.h
//  XMVIPModule
//
//  Created by duanwenpu on 2022/8/25.
//  Copyright © 2022 xmly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 遮罩渐变位置，如果scrollview的horizon=yes，XMScrollViewMaskPositionBegin是left位置，XMScrollViewMaskPositionEnd是right位置
/// 如果scrollview的vertical=yes，XMScrollViewMaskPositionBegin是top位置，XMScrollViewMaskPositionEnd是bottom位置
/// XMScrollViewMaskPositionAll是begin和end，都会有遮罩处理
typedef NS_ENUM(NSUInteger, XMScrollViewMaskPosition) {
    XMScrollViewMaskPositionBegin,
    XMScrollViewMaskPositionEnd,
    XMScrollViewMaskPositionAll,
};

/// 隐藏到展示的渐变视图，
@interface XMMaskGradientScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) XMScrollViewMaskPosition maskPosition;

@property (nonatomic, assign) CGFloat maskLength;

@end

NS_ASSUME_NONNULL_END
