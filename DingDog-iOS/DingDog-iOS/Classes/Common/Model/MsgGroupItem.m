//
//  MsgGroupItem.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MsgGroupItem.h"

@implementation MsgGroupItem

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"uuid": @"uuid",
             @"title": @"title",
             @"text": @"text",
             @"images": @"images",
             @"url": @"url",
             @"is_public": @"is_public"
             };
}

@end
