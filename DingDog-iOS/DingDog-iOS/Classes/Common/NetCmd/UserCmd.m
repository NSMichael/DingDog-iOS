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
             @"memberId": @"memberId",
             @"nickname": @"nickname",
             @"headimgurl": @"headimgurl",
             @"token": @"token",
             @"identity": @"identity",
             @"qcloud_token": @"qcloud_token",
             @"configModel": @"config",
//             @"rcloudTokenModel": @"rcloud_token"
             };
}

+ (NSValueTransformer *)configModelJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:ConfigModel.class];
}

//+ (NSValueTransformer *)rcloudTokenModelJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:RCloudTokenModel.class];
//}

@end
