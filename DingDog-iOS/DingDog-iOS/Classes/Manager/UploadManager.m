//
//  UploadManager.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "UploadManager.h"
#import "UploadTokenCmd.h"
#import "QiniuSDK.h"

static UploadManager *instance;

@interface UploadManager()

@property(nonatomic,strong) QNUploadManager *upManager;

@end

@implementation UploadManager

+ (UploadManager*)GetInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadManager alloc] init];
        
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _upManager = [[QNUploadManager alloc] init];
    }
    return self;
}

- (void)startUp
{
    NSString *userToken = [[MyAccountManager sharedManager] getToken];
    if(userToken && ![userToken isEqualToString:@""]){
        __weak __typeof(self) weakself = self;
        [self getResTokenFromServer:^(NSString *token, NSError *error) {
            if(error){
                // 10 秒钟后重试
                [weakself performSelector:@selector(startUp) withObject:nil afterDelay:10.];
                SLOG(@"警告：无法获取用于上传资源用的token.");
            }else{
                SLOG(@"获取上传资源用的token成功！token:%@",token);
            }
        }];
    }else{
        SLOG(@"用户还没有登录，无法进行获取资源resToken");
    }
}

/**
 从档口服务器获得token
 */
- (void)getResTokenFromServer :(void(^)(NSString *token,NSError *error))block{
    __weak __typeof(self) weakself = self;
    [NetworkAPIManager common_getUpToken:^(BaseCmd *cmd, NSError *error) {
        if(error){
            block(nil,error);
        }else{
            [cmd errorCheckSuccess:^{
                
                if ([cmd isKindOfClass:[UploadTokenCmd class]]) {
                    UploadTokenCmd *uploadCmd = (UploadTokenCmd *)cmd;
                    
                    weakself.token = uploadCmd.upload_Token;
                    [USER setObject:weakself.token forKey:@"AppResToken"];
                    [USER synchronize];
                    
                    block(uploadCmd.upload_Token,nil);
                }
                
            } failed:^(NSInteger errCode) {
                block(nil,[NSError errorWithDomain:@"" code:errCode userInfo:nil]);
            }];
        }
    }];
    
}

/**
 上传图片到档口服务器
 （1）上处图片本身到七牛的服务器
 （2）上传成功后，将资源对应的keystr上传到档口服务器
 @param keystr 对应的key值，由APP server返回
 */
- (void)uploadImgWithRestype:(RES_TYPE)resType img:(UIImage*)img
                       block:(void(^)(NSString *keystr, NSError *error))block {
    UIImage *image = img;
    if(img.size.width>IMG_WIDTH_PERFECT){
        CGFloat td = IMG_WIDTH_PERFECT/image.size.width;
        CGSize nsize = CGSizeMake(IMG_WIDTH_PERFECT, td*image.size.height);
        image = [img resizeImageWithNewSize:nsize];
    }else{
        
    }
    
    NSString *filePaht = [self getImagePath:img];
    
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    
    NSData *imgData = [ImageTools GetJpegBytesFromImage:image jpegQulity:0.6];
    
    __weak __typeof(self) weakself = self;
    [weakself.upManager putData:imgData key:nil token:weakself.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        
        if (info.error) {
            block(key, info.error);
        } else {
            block(key, nil);
        }
    } option:uploadOption];
    
    
//    [weakself.upManager putFile:filePaht key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"info ===== %@", info);
//        NSLog(@"resp ===== %@", resp);
//
//        if (info.error) {
//            block(key, info.error);
//        } else {
//            block(key, nil);
//        }
//    } option:uploadOption];
    
    /*
    NSData *imgData = [ImageTools GetJpegBytesFromImage:image jpegQulity:0.6];
    [weakself.upManager putData:imgData key:nil token:weakself.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        
        if (info.error) {
            block(key, info.error);
        } else {
            block(key, nil);
        }
        
    } option:nil];
     */
    
    /*
    [weakself.upManager putData:imgData key:keyStr token:weakself.token
                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           SLOG("%@", info);
                           SLOG(@"%@", resp);
                           if(info.error){
                               //默认认为是restoken不正确，自动去刷新一下resToken，界面中显示网络故障即可
                               [weakself getResTokenFromServer:^(NSString *token, NSError *error) {
                                   
                               }];
                               block(keyStr,info.error);
                           }else{
                               block(keyStr,nil);
                           }
                       } option:nil];
     */
    
    /*
    [self getResKeyFromServer:@(resType) block:^(NSString *keyStr, NSError *error) {
        if(error){
            block(nil,error);
        }else{
            NSData *imgData = [ImageTools GetJpegBytesFromImage:image jpegQulity:0.6];
            [weakself.upManager putData:imgData key:keyStr token:weakself.token
                               complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                   SLOG("%@", info);
                                   SLOG(@"%@", resp);
                                   if(info.error){
                                       //默认认为是restoken不正确，自动去刷新一下resToken，界面中显示网络故障即可
                                       [weakself getResTokenFromServer:^(NSString *token, NSError *error) {
                                           
                                       }];
                                       block(keyStr,info.error);
                                   }else{
                                       block(keyStr,nil);
                                   }
                               } option:nil];
        }
    }];
     */
    
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

- (void)getResKeyFromServer:(NSNumber*)resType
                      block:(void(^)(NSString *keyStr, NSError *error))block {
    [NetworkAPIManager common_getResKey:resType block:^(BaseCmd *cmd, NSError *error) {
        if(error){
            block(nil,error);
        }else{
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[UploadTokenCmd class]]) {
                    UploadTokenCmd *uploadCmd = (UploadTokenCmd *)cmd;
                    block(uploadCmd.upload_Token,nil);
                }
            } failed:^(NSInteger errCode) {
                block(nil,[NSError errorWithDomain:[cmd errorMsg] code:errCode userInfo:nil]);
            }];
            
        }
    }];
}

@end
