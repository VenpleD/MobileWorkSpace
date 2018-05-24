//
//  UploadImageView.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/18.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "UploadImageView.h"

@implementation UploadImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageModel:(UploadImageModel *)imageModel {
    _imageModel = imageModel;
    [self setImage:_imageModel.image];
}

@end
