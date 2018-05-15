//
//  GroupSendListViewController.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/7.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateMessageCmd.h"

@interface GroupSendListViewController : BaseViewController

@property (nonatomic, strong) void(^onGronpSendSuccessBlocked)(void);

- (instancetype)initWithCreateMessageCmd:(CreateMessageCmd *)cmd;

@end
