//
//  UploadManager.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>

//参数type说明：
//1:发单商品图片；2:抢单商品图片；3:发单语音；4:抢单语音；5:用户头像图片；7:档口展示图片；8:发布商品图片
typedef NS_ENUM(NSInteger, RES_TYPE){
    RES_IMG_GroupSend = 1,      // 群发
    RES_IMG_Avatar,             // 头像
    RES_IMG_Chat,               // 聊天
};

@interface UploadManager : NSObject

@property(nonatomic,strong) NSString *token;

/**
 注：resultArray中是上传结果，顺序与进入队列时的顺序一致
 */
@property (nonatomic, copy) void (^UploadCallBack) (NSMutableArray *resultArray,NSError *error);

/**
 当有多个资源同时上传时，每上传完成一个，就回调一次；
 remainTaskCount  上传队列中还剩余的任务总数,remainTaskCount=0时不回调，直接回调另外一个方法：uploadCallBack...
 */
@property (nonatomic, copy) void (^UploadProgressCallBack) (NSInteger remainTaskCount);


#pragma mark -
+ (UploadManager*)GetInstance;

- (void)startUp;

- (void)saveUploadToken:(NSString *)token;

- (NSString *)getUploadToken;

/**
 上传图片到档口服务器
 （1）上处图片本身到七牛的服务器
 （2）上传成功后，将资源对应的keystr上传到档口服务器
 @param keystr 对应的key值，由APP server返回
 */
- (void)uploadImgWithRestype:(RES_TYPE)resType img:(UIImage*)img
                       block:(void(^)(NSString *keystr, NSError *error))block;

@end
