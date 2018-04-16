//
//  ImageTools.h
//  tranb
//
//  Created by  SmallTask on 13-7-16.
//  Copyright (c) 2013年 cmf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTools : NSObject

+(UIImage *)imageFromView: (UIView *) theView;

+(UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)frame;

+(NSData*) GetJpegBytesFromImageWithDefaultQulity:(UIImage*)_image;

+(NSData*) GetJpegBytesFromImage:(UIImage*)_image jpegQulity:(CGFloat)_jpegQulity;

+ (UIImage *)imgLineWithWidth:(CGFloat)width color:(UIColor*)color;

@end
