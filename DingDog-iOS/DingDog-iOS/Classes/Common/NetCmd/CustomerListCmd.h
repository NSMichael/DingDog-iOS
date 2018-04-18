//
//  CustomerListCmd.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/18.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerListCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *itemArray;

@end
