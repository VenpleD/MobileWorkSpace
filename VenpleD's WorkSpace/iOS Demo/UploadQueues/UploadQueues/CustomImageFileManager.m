//
//  CustomImageFileManager.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/17.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "CustomImageFileManager.h"
#import <Photos/Photos.h>

@interface CustomImageFileManager ()

@property (nonatomic, strong) NSMutableArray *assetsArray;


@end

@implementation CustomImageFileManager

+ (instancetype)shareManager {
    static CustomImageFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[self alloc] init];
    });
    return fileManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self getAllAssetCollections];
    
    return self;
}

- (void)getAllAssetCollections {
//    self.assetsArray = [NSMutableArray array];
    self.imagesArray = [NSMutableArray array];
    self.imagesDataArray = [NSMutableArray array];
    PHFetchResult<PHAssetCollection *>* assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSLog(@"assetCollectionsCount:%ld",assetCollections.count);
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original {
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSLog(@"assetsCount%ld",assets.count);
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [self.imagesDataArray addObject:imageData];
            NSLog(@"dataLength:%ld,dataUTI%@,imageOrientation%ld,info%@",imageData.length,dataUTI,orientation,info[@"PHImageFileURLKey"]);
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self.imagesArray addObject:image];
            
        }];
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"%@", info);
//
//            [self.imagesArray addObject:result];
//        }];
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}


@end
