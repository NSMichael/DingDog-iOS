//
//  CaptchaModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptchaModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *code;

@end
