//
//  PreviewViewController.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/11.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateMessageCmd.h"

@interface PreviewViewController : BaseViewController

- (instancetype)initWithCreateMessageCmd:(CreateMessageCmd *)cmd;

@end
