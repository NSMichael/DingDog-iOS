//
//  InTagSelectedViewController.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"

@interface InTagSelectedViewController : BaseViewController

@property (nonatomic, strong) void(^inTagSelectedBlock)(NSArray *arr);

- (instancetype)initWithCurrentSelectedTagArray:(NSArray *)arr;

@end
