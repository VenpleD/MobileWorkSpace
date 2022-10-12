//
//  CustomImagePickViewController.m
//  UploadQueues
//
//  Created by duanwenpu on 2017/8/14.
//  Copyright © 2017年 VenpleD. All rights reserved.
//

#import "CustomImagePickViewController.h"
#import "CustomImageFileManager.h"
#import "ImageCollectionViewCell.h"

@interface CustomImagePickViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *imagesDataArray;

@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) NSMutableArray *selectedImagesDataArray;

@property (nonatomic, strong) NSMutableArray *selectedImagesArray;

@end

static dispatch_queue_t mainQueue;

@implementation CustomImagePickViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    printf("mainQueue地址%p\n",&mainQueue);
    CustomImageFileManager *fileManager = [CustomImageFileManager shareManager];
    self.imagesDataArray = [NSMutableArray arrayWithArray:fileManager.imagesArray];
    [self.view addSubview:self.imageCollectionView];
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setBounds:CGRectMake(0, 0, 100, 50)];
    [completeButton setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
}

- (void)completionClick {
    __weak typeof (self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof (self) self = weakSelf;
        if (self.selectedCompletionHandler) {
            self.selectedCompletionHandler(self.selectedImagesArray, self.selectedImagesDataArray);
        }
    }];
}

#pragma mark - UICollectionView's delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImageCollectionViewCell class]) forIndexPath:indexPath];
    [cell.imageView setImage:self.imagesDataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedImagesDataArray addObject:[CustomImageFileManager shareManager].imagesDataArray[indexPath.row]];
    [self.selectedImagesArray addObject:[CustomImageFileManager shareManager].imagesArray[indexPath.row]];
}

- (UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(90, 90)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        [_imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ImageCollectionViewCell class])];
        [_imageCollectionView setDelegate:self];
        [_imageCollectionView setDataSource:self];
    }
    return _imageCollectionView;
}

- (NSMutableArray *)selectedImageDataArray {
    if (!_selectedImagesDataArray) {
        _selectedImagesDataArray = [NSMutableArray array];
    }
    return _selectedImagesDataArray;
}

- (NSMutableArray *)selectedImagesArray {
    if (!_selectedImagesArray) {
        _selectedImagesArray = [NSMutableArray array];
    }
    return _selectedImagesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
