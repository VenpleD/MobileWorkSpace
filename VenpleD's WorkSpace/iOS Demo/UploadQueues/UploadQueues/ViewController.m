//
//  ViewController.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/14.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "ViewController.h"
#import "UploadImageCell.h"
#import <Photos/Photos.h>
#import "CustomImagePickViewController.h"
#import "CustomUrlCache.h"


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end


static NSInteger maxSelectedCount = 5;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLCache setSharedURLCache:[[CustomUrlCache alloc] initWithMemoryCapacity:4*1024*1024
                                                                    diskCapacity:1024*1024*1024
                                                                        diskPath:nil]];
    UIWebView *webview = [[UIWebView alloc] init];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:webview];
//    [self.view addSubview:self.mainCollectionView];
}

#pragma mark - UICollectionView's delegate and dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UploadImageCell class]) forIndexPath:indexPath];
    UploadImageModel *model = self.dataArray[indexPath.row];
    [cell.imageView setImageModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UploadImageCell *cell = (UploadImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UploadImageModel *model = cell.imageView.imageModel;
    if (model.imageStatus == ImageSatausNoSelected) {
        [self openSystemCameraOrAlbum];
    }
    
}

#pragma mark - open System's camera or album
- (void)openSystemCameraOrAlbum {
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OpenCamera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"OpenAlbum" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CustomImagePickViewController *imagePickViewController = [[CustomImagePickViewController alloc] init];
        imagePickViewController.selectedCompletionHandler = ^(NSArray *imagesArray, NSArray *imagesDataArray) {
            [self handleSelectedImagesArray:imagesArray imagesDataArray:imagesDataArray];
        };
        [self presentViewController:imagePickViewController animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleSelectedImagesArray:(NSArray *)imagesArray imagesDataArray:(NSArray *)imagesDataArray {
    for (NSInteger i = 0; i < imagesArray.count; i ++) {
        UploadImageModel *imageModel = [[UploadImageModel alloc] init];
        [imageModel setImage:imagesArray[i]];
        [imageModel setImageStatus:ImageStatusReadyUpload];
        [self.dataArray insertObject:imageModel atIndex:0];
    }
    [self.mainCollectionView reloadData];
}

- (void)writeDataToFile:(NSArray *)imagesDataArray {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    for (NSData *imageData in imagesDataArray) {

    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        UploadImageModel *imageModel = [[UploadImageModel alloc] init];
        [imageModel setImageStatus:ImageSatausNoSelected];
        [imageModel setImage:[UIImage imageNamed:@"btn_add_image"]];
        [_dataArray addObject:imageModel];
    }
    return _dataArray;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:20.f];
        [flowLayout setItemSize:CGSizeMake(80, 80)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        [_mainCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_mainCollectionView setDelegate:self];
        [_mainCollectionView setDataSource:self];
        [_mainCollectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:NSStringFromClass([UploadImageCell class])];
        
    }
    return _mainCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
