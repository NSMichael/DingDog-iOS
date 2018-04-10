//
//  GetCaptchaCmd.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GetCaptchaCmd.h"

@implementation GetCaptchaCmd

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"capthaModel": @"data"};
}

+ (NSValueTransformer *)capthaModelJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:CaptchaModel.class];
}

//+ (NSValueTransformer *)capthaModelJSONTransformer {
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CaptchaModel class]];
//}


@end
