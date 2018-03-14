//
//  AppDelegate.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "AppDelegate.h"
#import "DingDog-Prefix.pch"
#import "AppConfig.h"
#import "iConsole.h"
#import "SplashView.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if(DEBUG_VERSION){
        self.window = [[iConsoleWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    SplashView *splashView = [SplashView splashView];
    
    @weakify(self);
    [splashView beginAnimationWithCompletionBlock:^(SplashView *splashView) {
        @strongify(self);
        
        // 网络
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        //设置导航条样式
        [self customizeInterface];
        
        [NSThread sleepForTimeInterval:1];
        
        [self setupWelcomeViewController];
        
        [splashView endAnimationWithCompletionBlock:^(SplashView *splashView) {
            //
        }];
        
    }];
    
    [iConsole info:@"启动参数:%@",launchOptions];
    
    return YES;
}

- (void)setupWelcomeViewController {
    
    [self goToRootVC];
}

- (void)goToLoginVC {
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self.window setRootViewController:nav];
}

- (void)goToRootVC {
    self.rootVC = [[RootTabViewController alloc] init];
    self.rootVC.tabBar.translucent = YES;
    [self.window setRootViewController:self.rootVC];
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [navigationBarAppearance setTintColor:[UIColor colorWithHexString:@"0xFF871F"]];//返回按钮的箭头颜色
        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0xFF871F"]];//设置UITextField的光标颜色
        [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0xFF871F"]];//设置UITextView的光标颜色
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xe5e5e5"]] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xe5e5e5"]]];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    //    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(254, 153, 60)] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:kColorWhite] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
