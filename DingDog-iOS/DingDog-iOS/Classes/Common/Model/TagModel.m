//
//  TagModel.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"tagId": @"tagId",
             @"tagName": @"tagName",
             @"tagIcon": @"tagIcon",
             @"memberTotal": @"memberTotal"
             };
}

@end
