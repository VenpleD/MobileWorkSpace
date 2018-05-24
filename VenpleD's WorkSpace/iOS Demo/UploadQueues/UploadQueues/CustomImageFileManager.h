//
//  CustomImageFileManager.h
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/17.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomImageFileManager : NSObject

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *imagesDataArray;

+ (instancetype)shareManager;

@end
