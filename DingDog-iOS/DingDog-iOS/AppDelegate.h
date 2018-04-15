//
//  AppDelegate.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabViewController.h"
#import "WXApi.h"
#import "AppManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) AppManager *appManager;

@property (nonatomic, strong) RootTabViewController *rootVC;

- (void)setupTabViewController;

@end

