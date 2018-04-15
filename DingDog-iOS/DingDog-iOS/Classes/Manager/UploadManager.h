//
//  UploadManager.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
