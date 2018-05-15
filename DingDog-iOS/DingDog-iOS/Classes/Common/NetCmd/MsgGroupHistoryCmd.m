//
//  MsgGroupHistoryCmd.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MsgGroupHistoryCmd.h"
#import "MsgGroupModel.h"

@implementation MsgGroupHistoryCmd

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemArray": @"items"};
}

+ (NSValueTransformer *)itemArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MsgGroupModel.class];
}

@end
