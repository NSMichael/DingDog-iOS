//
//  GetCaptchaCmd.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCaptchaCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) NSString *urlPic;
@property (nonatomic, strong) NSString *codePic;

//@property (nonatomic, strong) CaptchaModel *capthaModel;

@end
