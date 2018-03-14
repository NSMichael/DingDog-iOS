//
//  UIImage+Common.h
//  vdangkou
//
//  Created by james on 15/3/5.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)imageWithColorByYZ:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

@end
