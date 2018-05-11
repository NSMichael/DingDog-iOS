//
//  CreateMessageCmd.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/11.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMessageCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) NSString *msgid;
@property (nonatomic, strong) NSString *preview_url;

@end
