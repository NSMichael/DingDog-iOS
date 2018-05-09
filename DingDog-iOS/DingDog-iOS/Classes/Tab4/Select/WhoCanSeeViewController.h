//
//  WhoCanSeeViewController.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/8.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"

@interface WhoCanSeeViewController : BaseViewController

@property (nonatomic, strong) void(^whoCanSeeBlocked)(NSMutableArray *selectArr);

- (instancetype)initWithCurrentSelectedArray:(NSMutableArray *)curSelectedArray AllCustomerArray:(NSMutableArray *)allArray;

@end