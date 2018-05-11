//
//  CreateMessageCmd.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/11.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CreateMessageCmd.h"

@implementation CreateMessageCmd

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"msgid": @"msgid",
             @"preview_url" : @"preview_url"
             };
}

@end
