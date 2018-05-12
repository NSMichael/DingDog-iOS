//
//  
//  AutomaticCoder
//
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "PhotoEntity.h"
#import "FCFileManager.h"
#import "ImageTools.h"

@implementation PhotoEntity

-(id)init{
    self = [super init];
    if(self){
        _order = @(0);
        _resourceId = @(0);
        _pictureID = @(0);
        _url = @"";
        _type = @(0);
        _title = @"";
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}

-(instancetype)initWithLocalImg:(UIImage*)img photoName:(NSString*)mPhotoName{
    self = [super init];
    if(self){
        //缓存img到tmp临时文件,程序重启后，该图片会被系统自动清除
        NSString *tmpName = [SysTools getUniqueStrByUUID];
        NSData *imgData = [ImageTools GetJpegBytesFromImageWithDefaultQulity:img];
        NSString *targetFileName = [[FCFileManager pathForTemporaryDirectory] stringByAppendingFormat:@"/%@",tmpName];
        [[NSFileManager defaultManager] createFileAtPath:targetFileName contents:imgData attributes:nil];
        
        _isLocal = YES;
        _imgfilePath = targetFileName;
        _title = mPhotoName?mPhotoName:@"";
        _img = img;
    }
    return self;
}

-(instancetype)initWithServerImgUrl:(NSString*)imgUrl photoName:(NSString*)mPhotoName{
    self = [super init];
    if(self){
        _isLocal = NO;
        _imgfilePath = imgUrl;
        _url = imgUrl;
        _title = mPhotoName?mPhotoName:@"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    PhotoEntity *copy = [[[PhotoEntity class] allocWithZone:zone] init];
    //server端返回的内容
    copy.order = [self.order mutableCopy];
    copy.resourceId = [self.resourceId mutableCopy];
    copy.pictureID = [self.pictureID mutableCopy];
    copy.url = [self.url mutableCopy];
    copy.type = [self.type mutableCopy];
    
    //本地增加的内容
    copy.isLocal = self.isLocal;
    copy.imgfilePath = self.imgfilePath;
    copy.title = self.title;
    return copy;
}

+ (instancetype)photoEntityWithImage:(UIImage *)image {
    PhotoEntity *photoEntity = [[PhotoEntity alloc] init];
    photoEntity.img = image;
    return photoEntity;
}

@end
