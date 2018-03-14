//
//  BaseNavigationController.m
//  vdangkou
//
//  Created by 耿功发 on 15/3/5.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

//先注释掉  不然PSTAlertController会crash
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.visibleViewController supportedInterfaceOrientations];
//}

@end
