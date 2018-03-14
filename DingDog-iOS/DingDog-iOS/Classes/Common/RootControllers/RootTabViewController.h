//
//  RootTabViewController.h
//  vdangkou
//
//  Created by james on 15/3/8.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "RDVTabBarController.h"

@interface RootTabViewController : RDVTabBarController <RDVTabBarControllerDelegate>

- (void)resetTabbarBadgeByIndex:(NSInteger)index badge:(NSString*)badge;

- (void)setTabBarBadgeStringByIndex:(NSInteger)index badgeString:(NSString *)str;

@end
