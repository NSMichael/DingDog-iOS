//
//  AppConfig.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"

//--1：调试模式--
#define DEBUG_VERSION           YES
#define TEST_MODE               NO  //发布时记得关闭这个状态
#define SOCKET_ENABLE           YES

#define CP_APPSTORE_WQF         0
#define CP_INHOUSE_AC           200

//appStore地址
#define kAppUrl  @"http://itunes.apple.com/app/id..."
#define kAppReviewURL   @"itms-apps://itunes.apple.com/..."

//友盟统计
#define kUmeng_AppKey_APPSTORE @"552f336dfd98c5420c00141d"
#define kUmeng_AppKey_InHouse  @"55ed0d71e0f55a9e2b0024a8"

//版本号
#define kVersion_zhaobu [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_zhaobu [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//URL
#define BASE_URL @"v1.api.bulldogo.com/"              // 正式的生产服务器
//#define BASE_URL @"192.168.254.55/9tong-zml-app/"              // 魏慧
//#define BASE_URL @"api1.ddzhaobu.com/zml"             // 找布云测试服务器
//#define BASE_URL @"192.168.254.18:8081/9tong-zml-app"         // 测试服务器2
//#define BASE_URL @"192.168.254.64:8081/9tong-zml-app"           // 刘权
//#define BASE_URL @"58.247.112.82:9992/9tong-zml-app"         // 10测试服务器，外网映射
//#define BASE_URL @"192.168.254.97:8080/9tong-zml-app"           // 高宗
//#define BASE_URL @"api1.ddzhaobu.com/zml"           // 正式的生产服务器2



// H5地址
//#define BASE_URL_H5 @"http://192.168.254.18:8081/9tong-zml-app/support/"         // H5 测试环境
#define BASE_URL_H5 @"http://api.ddzhaobu.com/zml/support/"                     // H5 生产环境

//公网地址
#define SERVER_PATH [NSString stringWithFormat:@"http://%@", BASE_URL]

//H5网站的基地址
#define H5_BASE_PATH ([BASE_URL isEqualToString:@"192.168.254.18:8081/9tong-zml-app"] || [BASE_URL isEqualToString:@"58.247.112.82:9992/9tong-zml-app"]) ? @"http://192.168.254.18:8081/9tong-zml-wx" : @"http://api.ddzhaobu.com"


//常用变量
#define kTipAlert(_S_, ...) [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define PAGESIZE 20
#define IMG_WIDTH_PERFECT 800

#define  kBadgeTipStr @"badgeTip"

// 提示网络错误
#define kToastNetWorkError [self.view.window makeToast:TIP_NETWORKERROR]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

//socket连接失败后，再次重试的间隔时间，单位:秒
#define SOCKET_RETRY_SECOND 5

//socket连接超时的时间，单位：秒；
#define SOCKET_TIMEOUT_SECOND 3*60

/*
 *创建日志输出方法
 */
#ifdef DEBUG

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#define SLOG(frmt, ...) DDLogInfo((@"%s [第%d行]:" frmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

static const int ddLogLevel = LOG_LEVEL_OFF;
#define SLOG(frmt, ...)

#endif


//常用的方法
//将用户输入的key的后面追加userId. 用来区分不同登录用户的缓存信息
//登录成功后，如果要操作UserDefault,建议使用这个包装；
#define uk(identityStr) [SysTools userKey:identityStr]
#define kError(errorCode,desc) [NSError errorWithDomain:desc code:errorCode userInfo:nil]

//字符串操作类
#define TRIM stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]

//提示文字
#define TIP_NETWORKERROR @"网络故障，请重试"
#define TIP_NO_MORE_DATA @"没有更多数据了"
#define TIP_UNIT_MUST_CHINESE @"计量单位必须使用中文"

// 手势密码
#define kCurrentPattern         @"KeyForCurrentPatternToUnlock"
#define kCurrentPatternTemp		@"KeyForCurrentPatternToUnlockTemp"

//APP系统常用变量
#define USER [NSUserDefaults standardUserDefaults]
#define APP (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define IOS7_SDK_AVAILABLE ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)

// 编译警告
#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")

///=============================================
/// @name Weak Object
///=============================================

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);


///=============================================
/// sns account
///=============================================

#define kAPPSTORE_WECHAT_APPID      @"wx545c6806dbb6bea8"
#define kAPPSTORE_WECHAT_SECRET     @"86a52ba86585b2dc790586e5bf4e401b"


#ifndef kWBSDKDemoAppSecret
#define kWBSDKDemoAppSecret			@"50deed0f096821dffab1ce1f8e114449"		//REPLACE ME    3acf036f3171f044b884da0d099ca0fc
#endif
#ifndef kWBSDKDemoAppKey
#define kWBSDKDemoAppKey			@"777322123"		//REPLACE ME     3816162523
#endif
#define WBCallBackUrl               @"http://61.129.52.136:8080/callback.jsp"

#define LinkedInConsumerKey  @"dfmmyspsemia"
#define LinkedInConsumerSecret  @"rYlCCvc71TMrIKgc"
#define LinkedInConsumerKey_en  @"75pprho50cp9y2"
#define LinkedInConsumerSecret_en  @"dbfEKlwGIcxQaTna"


///////////jmessage
#define JMSSAGE_DEV_APPKEY      @"3e4aad786d35ee554f095d7c"   //Jpush帐号app key
#define JMSSAGE_PRD_APPKEY      @"b6baa5ca7cde827a66465dd5"   //Jpush帐号app key


///=============================================
/// notification
///=============================================

//登录成功
#define kNotification_onLoginSuccess        @"onLoginSuccess"

/**
 当注销登录时触发
 */
#define kNotification_Logout                @"onLogoutNotification"

//收到一条socket push过来的消息，Notify内容为NSMutableArray类型，元素为：sktCmd 
#define kNotification_onRecivedSocketPush   @"onRecivedSocketPush"

/**
 声音播放停止时，由发起人发起通知；
 这里有一个假设：声音是全局唯一播放的，不会同时播放两个音频
 */
#define kNotification_onAudioPlayingStoped  @"onAudioPlayingStoped"

/**
 当我的主营分类发生修改后，触发
 */
#define kNotification_MyCategoryChanged     @"onMyCategoryChanged"

/*
 个人资料更新成功之后，触发回调
 */
#define kNotification_MyUserInfoChanged     @"onMyUserInfoChanged"

/**
 定位操作完成后，通知结果，定位结果放在参数中
 */
#define kNotification_onGPSLocationFinished @"onGPSLocationFinished"

#define kNotification_purchaseUpdateSuccess @"purchaseUpdateSuccess"

// 刷新我的报价详情界面
#define kNotification_refreshMyQuoteDetail @"refreshMyQuoteDetail"

#define kNotification_refreshWaitRatingMyPurchase @"refreshWaitRatingMyPurchase"

#define kNotification_refreshWaitRatingMyQuote @"refreshWaitRatingMyQuote"

#define kNotification_refreshWaitRatingTrade @"refreshWaitRatingTrade"

#define kNotification_refreshMyQuoteList @"refreshMyQuoteList"

// 市场现货采购发布成功
#define kNotification_PurchaseDeploySuccCashSale @"PurchaseDeploySuccCashSale"

// 工厂订做采购发布成功
#define kNotification_PurchaseDeploySuccReserve @"PurchaseDeploySuccReserve"

/*
 * 采购重新发布
 */
#define kNotification_purchaseRepublishSuccess @"purchaseRepublishSuccess"

#define kNotification_refreshNewFriendList  @"refreshNewFriendList"

// 找同行点击我的人脉
#define kNotification_onSegementMyContacts  @"onSegementMyContacts"

// iOS Push收到新的好友请求 进入人脉－我的人脉Tab
#define kNotification_iOSPushGoToMyContact @"iOSPushGoToMyContact"

// 刷新我的人脉列表
#define kNotification_refreshMyContacts    @"refreshMyContacts"

// 发布动态成功
#define kNotification_DeployTimeLineSucc    @"DeployTimeLineSucc"

// 抢单Tab滑动
#define kNotification_GrabSegementChanged    @"GrabSegementChanged"

// 客户Tab滑动
#define kNotification_ContactSegementChanged    @"ContactSegementChanged"

/**
 通知触发器跳转到消息中心
 */
#define KNotification_JumpToMessageCenter   @"jumpToMessageCenter"

// 采购报价成功
#define kNotification_QuoteSuccess          @"QuoteSuccess"

#define kNotification_RecepientDeleteSuccess    @"RecepientDeleteSuccess"

// 已添加到购物车
#define kNotification_AddCartSuccess        @"AddCartSuccess"

// 商品发布成功
#define KNotification_ProductDeploySuccess   @"ProductDeploySuccess"

// 添加收货地址成功后刷新收货地址列表
#define kNotification_ReceiptAddSuccess      @"ReceiptAddSuccess"

// 订单价格修改成功
#define kNotification_ChangePriceSuccess     @"ChangePriceSuccess"

// 订单列表向上滚动
#define kNotification_OrderListSliderUp     @"OrderListSliderUp"

// 订单列表向下滚动
#define kNotification_OrderListSliderDown    @"OrderListSliderDown"

// 订单生成
#define kNotification_OrderSubmitSuccess     @"OrderSubmitSuccess"


#define TIP_NO_GPS_PERMISSION @"请在“设置-隐私-定位服务”中允许好面料访问您的位置"
