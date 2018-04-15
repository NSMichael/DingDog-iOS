//
//  ConfigModel.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "ConfigModel.h"

@implementation ConfigModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"refresh": @"refresh",
             @"cdn": @"cdn"};
}

@end
