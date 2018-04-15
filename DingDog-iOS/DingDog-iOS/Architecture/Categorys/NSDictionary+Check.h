//
//  NSDictionary+Check.h
//  vdangkou
//
//  Created by Smalltask on 15/3/24.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Check)

/**
 检查NSDictionary中的value，如果有[NSNull null]的值，则移除
 目的：用于将NSDictionary保存到NSUserDefault中，如果value中有null值，则会crash.
 */
- (NSDictionary*)removeEmptyValue;

@end
