//
//  CustomerModel.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"member_id": @"member_id",
             @"since": @"since",
             @"nickname": @"nickname",
             @"memo": @"memo",
             @"first": @"first",
             @"fullname": @"fullname",
             @"province": @"province",
             @"headimgurl": @"headimgurl",
             @"tagArray": @"tags"
             };
}

//+ (NSValueTransformer *)tagArrayJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:NSString.class];
//}

@end
