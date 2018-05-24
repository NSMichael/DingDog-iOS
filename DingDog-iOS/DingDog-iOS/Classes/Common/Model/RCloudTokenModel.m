//
//  RCloudTokenModel.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "RCloudTokenModel.h"

@implementation RCloudTokenModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"userId",
             @"token": @"token"
             };
}


@end
