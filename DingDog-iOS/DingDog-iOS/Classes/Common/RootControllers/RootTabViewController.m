//
//  RootTabViewController.m
//  vdangkou
//
//  Created by james on 15/3/8.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "RootTabViewController.h"
#import "BaseNavigationController.h"
#import "RDVTabBarItem.h"
#import "Tab1_RootViewController.h"
#import "Tab2_RootViewController.h"
#import "Tab3_RootViewController.h"
#import "Tab4_RootViewController.h"
#import "Tab5_RootViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Private_M
- (void)setupViewControllers {
    
    UserCmd *userCmd = [MyAccountManager sharedManager].currentUser;
    if (userCmd) {
        if ([userCmd.identity isEqualToString:@"manager"]) {
            [self setupFiveTabs];
        } else if ([userCmd.identity isEqualToString:@"customer"]) {
            [self setupTwoTabs];
        }
    } else {
        [self setupTwoTabs];
    }
}

- (void)setupTwoTabs {
    Tab1_RootViewController *tab1 = [[Tab1_RootViewController alloc] init];
    BaseNavigationController *nav_tab1 = [[BaseNavigationController alloc] initWithRootViewController:tab1];
    
    Tab5_RootViewController *tab5 = [[Tab5_RootViewController alloc] init];
    UINavigationController *nav_tab5 = [[BaseNavigationController alloc] initWithRootViewController:tab5];
    
    [self setViewControllers:@[nav_tab1, nav_tab5]];
    
    [self customizeTabBarForControllerTwo];
    self.delegate = self;
}

- (void)setupFiveTabs {
    Tab1_RootViewController *tab1 = [[Tab1_RootViewController alloc] init];
    BaseNavigationController *nav_tab1 = [[BaseNavigationController alloc] initWithRootViewController:tab1];
    
    Tab2_RootViewController *tab2 = [[Tab2_RootViewController alloc] init];
    UINavigationController *nav_tab2 = [[BaseNavigationController alloc] initWithRootViewController:tab2];
    
    Tab3_RootViewController *tab3 = [[Tab3_RootViewController alloc] init];
    UINavigationController *nav_tab3 = [[BaseNavigationController alloc] initWithRootViewController:tab3];
    
    Tab4_RootViewController *tab4 = [[Tab4_RootViewController alloc] init];
    UINavigationController *nav_tab4 = [[BaseNavigationController alloc] initWithRootViewController:tab4];
    
    Tab5_RootViewController *tab5 = [[Tab5_RootViewController alloc] init];
    UINavigationController *nav_tab5 = [[BaseNavigationController alloc] initWithRootViewController:tab5];
    
    [self setViewControllers:@[nav_tab1, nav_tab2, nav_tab3, nav_tab4,  nav_tab5]];
    
    [self customizeTabBarForControllerFive];
    self.delegate = self;
}

- (void)customizeTabBarForControllerTwo {
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"icon-1", @"icon-5"];
    NSArray *tabBarItemTitles = @[@"消息",  @"我"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-a", tabBarItemImages[index]]];
        UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-n", tabBarItemImages[index]]];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        [item setTitle:[NSString stringWithFormat:@"%@", tabBarItemTitles[index]]];
        index++;
    }
}

- (void)customizeTabBarForControllerFive {
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"icon-1",@"icon-2", @"icon-3",@"icon-4", @"icon-5"];
    NSArray *tabBarItemTitles = @[@"消息", @"标签",@"客户",@"群发",  @"我"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-a", tabBarItemImages[index]]];
        UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-n", tabBarItemImages[index]]];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        [item setTitle:[NSString stringWithFormat:@"%@", tabBarItemTitles[index]]];
        index++;
    }
}

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedViewController == viewController) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)viewController;
            if (nav.topViewController == nav.viewControllers[0]) {
                BaseViewController *rootVC = (BaseViewController *)nav.topViewController;
#pragma clang diagnostic ignored "-Warc-performSelector"
                if ([rootVC respondsToSelector:@selector(tabBarItemClicked)]) {
                    [rootVC performSelector:@selector(tabBarItemClicked)];
                }
            }
        }
    }
    return YES;
}

- (void)resetTabbarBadgeByIndex:(NSInteger)index badge:(NSString*)badge{
        if(badge){
            if([badge isEqualToString:@"."]||[badge isEqualToString:@" "]){
                [[[[self tabBar] items] objectAtIndex:index] setBadgeTextFont:[UIFont systemFontOfSize:5]];
            }else{
                [[[[self tabBar] items] objectAtIndex:index] setBadgeTextFont:[UIFont systemFontOfSize:12]];
            }
            [[[[self tabBar] items] objectAtIndex:index] setBadgeValue:@" "];
        }else{
            [[[[self tabBar] items] objectAtIndex:index] setBadgeValue:@""];
        }

}

- (void)setTabBarBadgeStringByIndex:(NSInteger)index badgeString:(NSString *)str{
    if (!str) {
        [[[[self tabBar] items] objectAtIndex:index] setBadgeValue:nil];
    }else{
        [[[[self tabBar] items] objectAtIndex:index] setBadgeValue:str];
    }
}

@end
