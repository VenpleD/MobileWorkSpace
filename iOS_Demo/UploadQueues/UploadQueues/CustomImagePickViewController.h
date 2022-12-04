//
//  CustomImagePickViewController.h
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/14.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedCompletionHandler)(NSArray *imagesArray, NSArray *imagesDataArray);

@interface CustomImagePickViewController : UIViewController

@property (nonatomic, strong) SelectedCompletionHandler selectedCompletionHandler;

@end
