//
//  MsgGroupModel.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MsgGroupModel.h"

@implementation MsgGroupModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"uuid": @"uuid",
             @"member_id": @"member_id",
             @"created_dt": @"created_dt",
             @"msgGroupItem" : @"content"
             };
}

+ (NSValueTransformer *)msgGroupItemJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MsgGroupItem.class];
}

@end
