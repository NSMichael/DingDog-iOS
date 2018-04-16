//
//  ImageTools.m
//  tranb
//
//  Created by  SmallTask on 13-7-16.
//  Copyright (c) 2013年 cmf. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools


+ (UIImage *)imgLineWithWidth:(CGFloat)width color:(UIColor*)color
{
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    uv.backgroundColor = color;
    UIImage *img = [ImageTools imageFromView:uv];
    return img;
}

+(UIImage *)imageFromView: (UIView *) theView
{
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0.0);
    } else {
        //code will never be executed.
//        UIGraphicsBeginImageContext(theView.frame.size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//获得某个范围内的屏幕图像
+(UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

+(NSData*) GetJpegBytesFromImageWithDefaultQulity:(UIImage*)_image;
{
    NSMutableData * newPacket = [NSMutableData dataWithCapacity:(1)];
    NSData *tmp = UIImageJPEGRepresentation(_image,JPEGQULITY);
    [newPacket appendData:tmp];
    return newPacket;
}

+(NSData*) GetJpegBytesFromImage:(UIImage*)_image jpegQulity:(CGFloat)_jpegQulity;
{
    NSMutableData * newPacket = [NSMutableData dataWithCapacity:(1)];
    NSData *tmp = UIImageJPEGRepresentation(_image,_jpegQulity);
    [newPacket appendData:tmp];
    return newPacket;
}

@end
