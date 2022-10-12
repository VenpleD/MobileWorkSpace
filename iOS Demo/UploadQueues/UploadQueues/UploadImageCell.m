//
//  UploadImageCell.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/14.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "UploadImageCell.h"

@interface UploadImageCell ()



@end

@implementation UploadImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self createSubviews];
    
    return self;
}

- (void)createSubviews {
    self.imageView = [[UploadImageView alloc] init];
    [self.imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
    [self.contentView addSubview:self.imageView];
//    self.button = [UploadImageButton buttonWithType:UIButtonTypeCustom];
//    [self.button setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
//    [self.contentView addSubview:self.button];
}
@end
