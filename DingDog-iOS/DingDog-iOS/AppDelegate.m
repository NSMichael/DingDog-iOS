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
#import "MyAccountManager.h"

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
    
    self.appManager = [AppManager GetInstance];
    [self initTimSDK];
    
    SplashView *splashView = [SplashView splashView];
    
    @weakify(self);
    [splashView beginAnimationWithCompletionBlock:^(SplashView *splashView) {
        @strongify(self);
        
        // 网络
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        [WXApi registerApp:kAPPSTORE_WECHAT_APPID];
        
        [self.appManager startUp];
        
        //设置导航条样式
        [self customizeInterface];
        
//        [NSThread sleepForTimeInterval:1];
        
        [self setupWelcomeViewController];
        
        [splashView endAnimationWithCompletionBlock:^(SplashView *splashView) {
            //
        }];
        
    }];
    
    [iConsole info:@"启动参数:%@",launchOptions];
    
    return YES;
}

- (void)setupWelcomeViewController {
    
    UserCmd *userCmd = [MyAccountManager sharedManager].currentUser;

    if (userCmd) {
        [self setupTabViewController];
    } else {
        [self goToLoginVC];
    }
    
//    [self setupTabViewController];
}

- (void)goToLoginVC {
    LoginViewController *login = [[LoginViewController alloc] initWithLoginType:LoginType_login];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self.window setRootViewController:nav];
}

- (void)setupTabViewController {
    self.rootVC = [[RootTabViewController alloc] init];
    self.rootVC.tabBar.translucent = NO;
    [self.window setRootViewController:self.rootVC];
}

// 初始化聊天
- (void)initTimSDK {
    // 初始化SDK，设置sdkappid和accoutType，由腾讯云控制台分配
    TIMSdkConfig * config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [kSdkAppId intValue];
    config.accountType = kSdkAccountType;
    [[TIMManager sharedInstance] initSdk:config];
    
    // 初始化用户参数配置，使用默认配置
    TIMUserConfig * userConfig = [[TIMUserConfig alloc] init];
    [[TIMManager sharedInstance] setUserConfig:userConfig];
    
    // 添加新消息监听器，实现onNewMessage:
//    [[TIMManager sharedInstance] addMessageListener:self];
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [navigationBarAppearance setTintColor:[UIColor colorWithHexString:@"0x1E90FF"]];//返回按钮的箭头颜色
        [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x1E90FF"]];//设置UITextField的光标颜色
        [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x1E90FF"]];//设置UITextView的光标颜色
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

//和QQ,新浪并列回调句柄
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            NSLog(@"code %@",aresp.code);
            
            if (_weChatType == WeChatType_Login) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_weChatLogin object:self userInfo:@{@"code":aresp.code}];
            } else if (_weChatType == WeChatType_Bind) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_wechatBind object:self userInfo:@{@"code":aresp.code}];
            }
            
        }
    }
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
    
    [UIApplication.sharedApplication.windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *w, NSUInteger idx, BOOL *stop) {
        if (!w.opaque && [NSStringFromClass(w.class) hasPrefix:@"UIText"]) {
            // The keyboard sometimes disables interaction. This brings it back to normal.
            BOOL wasHidden = w.hidden;
            w.hidden = YES;
            w.hidden = wasHidden;
            *stop = YES;
        }
    }];
    
    //清空通知栏消息
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[TIMManager sharedInstance] doForeground:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}


-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    SLOG(@"didRegisterForRemoteNotificationsWithDeviceToken:%ld", (unsigned long)deviceToken.length);
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"SetToken" msg:[NSString stringWithFormat:@"My Token is :%@", token]];
    TIMTokenParam *param = [[TIMTokenParam alloc] init];
    
#if kAppStoreVersion
    
    // AppStore版本
#if DEBUG
    param.busiId = 2383;
#else
    param.busiId = 2382;
#endif
    
#else
    //企业证书id
    param.busiId = 4496;
#endif
    
    [param setToken:deviceToken];
    
    //    [[TIMManager sharedInstance] setToken:param];
    [[TIMManager sharedInstance] setToken:param succ:^{
        
        NSLog(@"-----> 上传token成功 ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"-----> 上传token失败 ");
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    SLOG(@"didFailToRegisterForRemoteNotificationsWithError:%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    SLOG(@"userinfo:%@",userInfo);
    SLOG(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
