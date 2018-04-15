//
//  UserCmd.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "UserCmd.h"

@implementation UserCmd

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"mobileId": @"mobileId",
//             @"memberId": @"memberId",
//             @"nickname": @"nickname",
//             @"rcloud_token": @"rcloud_token",
//             @"qcloud_token": @"qcloud_token",
//             @"rcoulod_token": @"rcoulod_token",
             @"token": @"token",
             @"identity": @"identity",
             @"configModel": @"config"
             };
}

+ (NSValueTransformer *)configModelJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:ConfigModel.class];
}

@end
