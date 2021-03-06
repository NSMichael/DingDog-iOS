//
//  GroupSendSuccessVC.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/16.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateMessageCmd.h"

@interface GroupSendSuccessVC : BaseViewController

@property (nonatomic, strong) void(^onGronpSendSuccessBlocked)(void);

- (instancetype)initWithAllCustomerArray:(NSMutableArray *)allArray CreateMessageCmd:(CreateMessageCmd *)cmd;

@end
