//
//  GetCaptchaCmd.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptchaModel.h"

@interface GetCaptchaCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) CaptchaModel *capthaModel;

@end
