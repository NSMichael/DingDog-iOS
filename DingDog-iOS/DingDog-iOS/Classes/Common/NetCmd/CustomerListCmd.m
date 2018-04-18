//
//  CustomerListCmd.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/18.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CustomerListCmd.h"
#import "CustomerModel.h"

@implementation CustomerListCmd

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemArray": @"items"};
}

+ (NSValueTransformer *)itemArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CustomerModel.class];
}

@end
