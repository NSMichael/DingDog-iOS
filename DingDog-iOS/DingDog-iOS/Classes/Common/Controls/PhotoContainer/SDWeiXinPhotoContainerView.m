//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWeiXinPhotoContainerView.h"

#import "UIView+SDAutoLayout.h"
#import "UITapImageView.h"
#import "PhotoEntity.h"

@interface SDWeiXinPhotoContainerView () 

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UITapImageView *imageView = [UITapImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = [self itemHeightForPicPathArray:_picPathStringsArray];
    
    /*
    if (_picPathStringsArray.count == 1) {
        
        PhotoEntity *photo = _picPathStringsArray.firstObject;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:photo.url] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!error) {
                if (image.size.width) {
                    itemH = image.size.height / image.size.width * itemW;
                }
            }
        }];
        
        
    } else {
        itemH = itemW;
    }
     */
    
//    itemH = itemW;
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        
        PhotoEntity *photo = [_picPathStringsArray objectAtIndex:idx];
        UITapImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:kImageWithURLWidthHeight(photo.url, (int)itemW*2, (int)itemH*2)] placeholderImage:IMG_PLACEHOLDER_PRODUCT];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        
        [imageView addTapBlock:^(id obj) {
            [self viewQuoteImage:idx];
        }];
    }];
     
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width_sd = w;
    self.height_sd = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return kScreen_Width-75-50;
    } else if (array.count == 2 || array.count == 4) {
        CGFloat w = (kScreen_Width-75-50-10)/ 3 + 20;
        return w;
    }
    else {
        CGFloat w = (kScreen_Width-75-50-10)/3;
        return w;
    }
    
    
//    CGFloat w = (kScreen_Width-75-50-10)/3;
//    return w;
    
    /*
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
     */
}

- (CGFloat)itemHeightForPicPathArray:(NSArray *)array {
    if (array.count == 1) {
        return (kScreen_Width-75-50)/2;
    } else if (array.count == 2 || array.count == 4) {
        CGFloat w = (kScreen_Width-75-50-10)/ 3 + 20;
        return w;
    }
    else {
        CGFloat w = (kScreen_Width-75-50-10)/3;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count > 3 && array.count < 7) {
        return 2;
    } else {
        return 3;
    }
}

#pragma mark - 查看大图
- (void)viewQuoteImage:(NSInteger)index {
    
    /*
    NSUInteger picCount = (_picPathStringsArray.count > 0) ? _picPathStringsArray.count : 1;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:picCount];
    for (int i = 0; i < picCount; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        PhotoEntity *entity = [_picPathStringsArray objectAtIndex:i];
        if(entity.url){
            photo.url = [NSURL URLWithString:entity.url];
            [photos addObject:photo];
        }else{
            if(entity.img){
                photo.image = entity.img;
                [photos addObject:photo];
            }else if(entity.imgfilePath && ![entity.imgfilePath isEqualToString:@""]){
                photo.image = [UIImage imageWithContentsOfFile:entity.imgfilePath];
                [photos addObject:photo];
            }
        }
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是？
    browser.currentPhotoIndex = index != -1 ? index : 0;
    // 设置所有的图片
    browser.photos = photos;
    [browser show];
    */
    
}

@end
