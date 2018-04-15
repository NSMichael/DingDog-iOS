//
//  UserCmd.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigModel.h"

@interface UserCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mobileId;
@property (nonatomic, strong) NSNumber *memberId;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *rcloud_token;
@property (nonatomic, strong) NSString *qcloud_token;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *identity;

@property (nonatomic, strong) ConfigModel *configModel;

@end
