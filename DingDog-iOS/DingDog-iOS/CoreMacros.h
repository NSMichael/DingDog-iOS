//
//  CoreMacros.h
//  tranb
//
//  Created by zhaoguohui on 15/5/19.
//  Copyright (c) 2015年 cmf. All rights reserved.
//

#ifndef tranb_CoreMacros_h
#define tranb_CoreMacros_h


// 字符串
#define STR_IS_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)
// 字典
#define DICT_IS_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)
// 数组
#define ARRAY_IS_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)

#define kNotification_groupImage_change         @"groupImage_change"


#define RMT_NAVIAGTION_BAR_HEIGHT               64

#endif
