//
//  ImageCollectionViewCell.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/17.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self createSubviews];
    
    return self;
}

- (void)createSubviews {
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
    [self.contentView addSubview:self.imageView];
}

@end
