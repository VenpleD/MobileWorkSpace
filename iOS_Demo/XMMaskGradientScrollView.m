//
//  XMMaskGradientScrollView.m
//  XMVIPModule
//
//  Created by duanwenpu on 2022/8/25.
//  Copyright © 2022 xmly. All rights reserved.
//

#import "XMMaskGradientScrollView.h"
#import <XMCategories/XMMacro.h>

static NSString *kScrollOffsetKey = @"contentOffset";

@interface XMMaskGradientScrollView ()

@property (nonatomic, strong) CAGradientLayer *maskGradientLayer;

@property (nonatomic, strong) NSArray *maskColorsBegin;

@property (nonatomic, strong) NSArray *maskColorsEnd;

@property (nonatomic, strong) NSArray *maskColorsAll;

@property (nonatomic, strong) NSArray *maskColorsNone;

@end

@implementation XMMaskGradientScrollView

- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.maskGradientLayer.frame = self.bounds;
    CGFloat scale = self.maskLength / CGRectGetWidth(self.frame);
    self.maskGradientLayer.locations = @[@0, @(scale), @0.5, @(1-scale), @1];
}

- (void)setUI {
    self.scrollView = [UIScrollView new];
    [self addSubview:self.scrollView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@0, (@0.15),@(0.5), @(0.85), @1];
    self.maskGradientLayer = gradientLayer;
    self.layer.mask = gradientLayer;
    
    [self addScrollOffsetObserver];
}

- (void)setMaskPosition:(XMScrollViewMaskPosition)maskPosition {
    _maskPosition = maskPosition;
    [self settingTagsMaskWithScrollView:self.scrollView];
}

- (void)addScrollOffsetObserver {
    [self.scrollView addObserver:self forKeyPath:kScrollOffsetKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kScrollOffsetKey]) {
        [self settingTagsMaskWithScrollView:self.scrollView];
    }
}

- (void)settingTagsMaskWithScrollView:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (scrollView.contentSize.width <= scrollView.frame.size.width) {
        if (![self.maskGradientLayer.colors isEqual:self.maskColorsNone]) {
            self.maskGradientLayer.colors = self.maskColorsNone;
        }
        return;
    }
    if (offsetX <=0 ) {
        if (_maskPosition != XMScrollViewMaskPositionBegin) {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsEnd]) {
                self.maskGradientLayer.colors = self.maskColorsEnd;
            }
        } else {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsNone]) {
                self.maskGradientLayer.colors = self.maskColorsNone;
            }
        }
    } else if (offsetX >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
        if (_maskPosition != XMScrollViewMaskPositionEnd) {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsBegin]) {
                self.maskGradientLayer.colors = self.maskColorsBegin;
            }
        } else {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsNone]) {
                self.maskGradientLayer.colors = self.maskColorsNone;
            }
        }
    } else {
        if (_maskPosition == XMScrollViewMaskPositionAll) {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsAll]) {
                self.maskGradientLayer.colors = self.maskColorsAll;
            }
        } else if (_maskPosition == XMScrollViewMaskPositionBegin) {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsBegin]) {
                self.maskGradientLayer.colors = self.maskColorsBegin;
            }
        } else {
            if (![self.maskGradientLayer.colors isEqual:self.maskColorsEnd]) {
                self.maskGradientLayer.colors = self.maskColorsEnd;
            }
        }
    }
}

- (NSArray *)maskColorsBegin {
    if (!_maskColorsBegin) {
        _maskColorsBegin = @[(__bridge id)colorFromRGBA(0x000000, 0).CGColor,
                                   (__bridge id)colorFromRGB(0x000000).CGColor,
                                   (__bridge id)colorFromRGB(0x000000).CGColor,
                                   (__bridge id)colorFromRGB(0x000000).CGColor,
                                   (__bridge id)colorFromRGB(0x000000).CGColor];
    }
    return _maskColorsBegin;
}

- (NSArray *)maskColorsEnd {
    if (!_maskColorsEnd) {
        _maskColorsEnd = @[(__bridge id)colorFromRGB(0x000000).CGColor,
                                    (__bridge id)colorFromRGB(0x000000).CGColor,
                                    (__bridge id)colorFromRGB(0x000000).CGColor,
                                    (__bridge id)colorFromRGB(0x000000).CGColor,
                                    (__bridge id)colorFromRGBA(0x000000, 0).CGColor];
    }
    return _maskColorsEnd;
}

- (NSArray *)maskColorsAll {
    if (!_maskColorsAll) {
        _maskColorsAll = @[(__bridge id)colorFromRGBA(0x000000, 0).CGColor,
                                  (__bridge id)colorFromRGB(0x000000).CGColor,
                                  (__bridge id)colorFromRGB(0x000000).CGColor,
                                  (__bridge id)colorFromRGB(0x000000).CGColor,
                                  (__bridge id)colorFromRGBA(0x000000, 0).CGColor];
    }
    return _maskColorsAll;
}

- (NSArray *)maskColorsNone {
    if (!_maskColorsNone) {
        _maskColorsNone = @[(__bridge id)colorFromRGB(0x000000).CGColor,
                            (__bridge id)colorFromRGB(0x000000).CGColor,
                            (__bridge id)colorFromRGB(0x000000).CGColor,
                            (__bridge id)colorFromRGB(0x000000).CGColor,
                            (__bridge id)colorFromRGB(0x000000).CGColor];
    }
    return _maskColorsNone;
}

@end
