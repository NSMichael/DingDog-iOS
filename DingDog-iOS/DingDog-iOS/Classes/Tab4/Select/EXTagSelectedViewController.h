//
//  EXTagSelectedViewController.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"

@interface EXTagSelectedViewController : BaseViewController

@property (nonatomic, strong) void(^exTagSelectedBlock)(NSArray *arr);

- (instancetype)initWithCurrentSelectedTagArray:(NSArray *)arr;

@end
