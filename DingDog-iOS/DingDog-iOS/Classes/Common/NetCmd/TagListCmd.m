//
//  TagListCmd.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "TagListCmd.h"
#import "TagModel.h"

@implementation TagListCmd

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemArray": @"items"};
}

+ (NSValueTransformer *)itemArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TagModel.class];
}

@end
