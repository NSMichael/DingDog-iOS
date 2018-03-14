//
//  BaseViewController.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/5.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "UIView+Toast.h"
#import "JDStatusBarNotification.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSUInteger, NavigationBarItemType) {
    NavigationBarItemType_Bg,
    NavigationBarItemType_Left,
    NavigationBarItemType_Right,
};

#define HEIGHT_TABBAR CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)
#define HEIGHT_NAVIGATIONBAR 44

@interface BaseViewController : UIViewController

@property(nonatomic,strong) UIView *blankPage;//无数据时显示的view

@property (nonatomic, strong) UIButton *leftBackButton;

@property (nonatomic, strong) MBProgressHUD *progressHUD;


- (void)tabBarItemClicked;

#pragma mark UI
-(CGRect)appFrameWithoutTabbar;

/**
 判断那个覆盖状态栏的statusbar的通知，是否正在显示中
 */
- (BOOL)isJDStatusBarVisiable;

/**
 显示一个无数据的空白页面
 */
- (void)showBlankView:(NSString*)txt;

/**
 与showBlankView配对，隐藏一个空白页面
 */
- (void)hideBlankView;

#pragma mark Navigation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

-(void)setLeftBarWithBtn:(NSString *)title imageName:(NSString *)imageName action:(SEL)action badge:(NSString*)badge;

- (void)setRightBarWithBtn:(NSString *)title imageName:(NSString *)imageName action:(SEL)action badge:(NSString*)badge;

- (UIBarButtonItem *)backButton;

- (void)setBackButton:(id)target action:(SEL)action;

#pragma mark loading..
- (void)showLoadingLayer;

- (void)hideLoadingLayer;

- (void)showMBProgressHUD;
- (void)hideMBProgressHUD;

- (void)showLoadingView;
- (void)hideLoadingView;

#pragma mark - 关闭键盘
- (void)hideKeyboard;

// 导航栏透明
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end
