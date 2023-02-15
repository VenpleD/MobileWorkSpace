//
//  XMPlayingFloatScrollLabel.m
//  XMNowPlayingModule
//
//  Created by wenpu.duan on 2022/11/3.
//  Copyright © 2022 xmly. All rights reserved.
//

#import "XMPlayingFloatScrollLabel.h"
#import "XMMaskGradientScrollView.h"

@interface XMPlayingFloatScrollLabel ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) XMMaskGradientScrollView *scrollContainer;

@property (nonatomic, assign) BOOL scrollToLeft;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL hasSuspend;

@end

@implementation XMPlayingFloatScrollLabel

- (void)dealloc {
    /// 挂起状态不能释放timer，需要在resume状态
    if (_timer && _hasSuspend) {
        dispatch_resume(_timer);
    }
    if (_timer) {
        dispatch_cancel(_timer);
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollContainer.maskLength = self.maskLength;
    self.scrollContainer.frame = self.bounds;
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self reset];
}

- (void)initUI {
    self.interval = 1;
    self.speed = 15;
    self.maskLength = 10.f;
    
    self.scrollContainer = [XMMaskGradientScrollView new];
    self.scrollContainer.userInteractionEnabled = NO;
    self.scrollContainer.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollContainer.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollContainer.scrollView.scrollEnabled = NO;
    self.scrollContainer.scrollView.userInteractionEnabled = NO;
    self.scrollContainer.maskPosition = XMScrollViewMaskPositionAll;
    [self addSubview:self.scrollContainer];
    
    _label = [UILabel new];
    _label.frame = CGRectZero;
    _label.userInteractionEnabled = NO;
    [self.scrollContainer.scrollView addSubview:_label];
}

- (void)reset {
    [self prepareAnimation];
}

- (void)prepareAnimation {
    CGFloat labelWidth = ceilf([self.label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame))].width);
    
    NSLog(@"---scrollLabel---%@--%@", @(labelWidth), @(0));
    
    if (labelWidth <= CGRectGetWidth(self.frame)) {
        self.label.frame = CGRectMake(0, 0, labelWidth, CGRectGetHeight(self.label.frame));
        self.scrollContainer.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.label.frame), CGRectGetHeight(self.scrollContainer.frame));
        [self.scrollContainer.scrollView setContentOffset:CGPointZero];
        self.scrollToLeft = NO;
        [self suspendTimer];
    } else {
        if (labelWidth == CGRectGetWidth(self.label.frame) && self.timer) {
            return;
        } else {
            self.label.frame = CGRectMake(0, 0, labelWidth, CGRectGetHeight(self.label.frame));
            self.scrollContainer.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.label.frame), CGRectGetHeight(self.scrollContainer.frame));
            [self beginAnimation];
        }
        
    }
}

- (void)displayCallBack {
    CGFloat labelWidth = self.scrollContainer.scrollView.contentSize.width;
    CGFloat containerWidth = CGRectGetWidth(self.frame);
    CGFloat contentOffsetX = self.scrollContainer.scrollView.contentOffset.x;
    CGFloat contentOffsetY = self.scrollContainer.scrollView.contentOffset.y;
    CGFloat lessContentOffsetX = contentOffsetX - self.speed;
    CGFloat moreContentOffsetX = contentOffsetX + self.speed;
    CGFloat maxContentOffsetX = labelWidth - containerWidth;
    if (labelWidth <= containerWidth) {
        return;
    }
    self.interval = 1;
    if (self.scrollToLeft) {
        if (contentOffsetX < 0 || lessContentOffsetX < 0) {
            if (lessContentOffsetX < 0) {
                self.interval = (contentOffsetX - 0) / self.speed;
            }
            contentOffsetX = 0;
            self.scrollToLeft = NO;
            [self suspendWithAfterBegin];
        } else {
            contentOffsetX -= self.speed;
        }

    } else {
        if (contentOffsetX > maxContentOffsetX || moreContentOffsetX > maxContentOffsetX) {
            if (moreContentOffsetX > 0) {
                self.interval = (maxContentOffsetX - contentOffsetX) / self.speed;
            }
            contentOffsetX = maxContentOffsetX;
            self.scrollToLeft = YES;
            [self suspendWithAfterBegin];
        } else {
            contentOffsetX += self.speed;
        }
    }
    [UIView animateWithDuration:self.interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.scrollContainer.scrollView setContentOffset:CGPointMake(contentOffsetX, contentOffsetY)];
    } completion:^(BOOL finished) {
    }];
}

- (void)suspendWithAfterBegin {
    [self suspendTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.interval * 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self beginAnimation];
    });
}

- (void)beginAnimation {
    if (!self.timer) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf displayCallBack];
            });

        });
        self.hasSuspend = YES;
    }
    [self resumeTimer];
}

- (void)resumeTimer {
    if (self.timer && self.hasSuspend) {
        dispatch_resume(self.timer);
        self.hasSuspend = NO;
    }
}

- (void)suspendTimer {
    if (self.timer && !self.hasSuspend) {
        dispatch_suspend(self.timer);
        self.hasSuspend = YES;
    }
}

- (void)sizeToFit {
    [self.label sizeToFit];
    [super sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.label sizeThatFits:size];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = _textColor;
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.label.font = _font;
    [self reset];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = _text;
    [self reset];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.label.attributedText = attributedText;
    [self reset];
}

- (void)setMaskLength:(CGFloat)maskLength {
    _maskLength = maskLength;
    self.scrollContainer.maskLength = _maskLength;
}

@end
