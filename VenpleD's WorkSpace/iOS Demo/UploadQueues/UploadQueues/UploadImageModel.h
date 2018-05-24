//
//  UploadImageModel.h
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/14.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageSataus) {
    ImageSatausNoSelected, //没有选择图片
    ImageStatusReadyUpload, //准备上传
    ImageSatausUploading, //图片正在上传
    ImageSatausUploaded, //图片上传完成
};

@interface UploadImageModel : NSObject

@property (nonatomic, assign) ImageSataus imageStatus;

@property (nonatomic, strong) UIImage *image;

@end
