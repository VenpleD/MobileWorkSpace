//
//  CustomUrlProtocol.m
//  UploadQueues
//
//  Created by 段文菩 on 2018/1/5.
//  Copyright © 2018年 VenpleD. All rights reserved.
//

#import "CustomUrlProtocol.h"

@implementation CustomUrlProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {

    return NO;
}

@end
