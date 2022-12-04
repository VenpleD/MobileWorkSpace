//
//  CustomUrlCache.m
//  Camera
//
//  Created by 段文菩 on 2018/1/5.
//  Copyright © 2018年 段文菩. All rights reserved.
//

#import "CustomUrlCache.h"

@implementation CustomUrlCache

- (nullable NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    return [super cachedResponseForRequest:request];
}

@end
