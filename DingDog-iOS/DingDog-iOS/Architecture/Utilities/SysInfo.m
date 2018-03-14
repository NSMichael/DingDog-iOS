//
//  SysInfo.m
//  ZhaoBu
//
//  Created by Smalltask on 15/4/8.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "SysInfo.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation SysInfo

#pragma mark - 设置及系统信息
/**
 获取系统信息；
 系统标签及设备型号的对照表见：https://www.theiphonewiki.com/wiki/Models
 */
+ (NSString*)getDeviceInfoForJavaServer{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

#pragma mark -
#pragma mark 客户端检查最后一次的登陆时间，如果超过1天没有登陆，则系统自动为其登陆；
///把当前的启动时间保存下来
+(void)SetLastTimeWhileClientStart;
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%lld",(long long int)time];
    [USER setValue:timeStr forKey:@"LastTimeWhileClientStart"];
    [USER synchronize];
}


+(long long int)GetLastTimeWhileClientStart;
{
    NSString *timeStr = [USER valueForKey:@"LastTimeWhileClientStart"];
    return [timeStr longLongValue];
}

//保存最后一次将App切换到后台的时间
+(void)SetLastTimeWhenClientBecomeBackground;
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%lld",(long long int)time];
    [USER setValue:timeStr forKey:@"LastTimeWhenClientBecomeBackground"];
    [USER synchronize];
}

/*
 清除最后一次退回到后台的时间；
 原因：为加快启动速度，采用以下两个优化：
 如果在socket超时时间内将APP从后台切换到前台，则系统不重新做socket连接；
 如果APP从后台切换到前的时间小于GPS_TIMEOUT_SECOND的设置（1小时），则不再重新定位；
 
 使用场景：
 登录成功后，在连接socket和启动定位前进行设置；
 */
+(void)SetLastTimeWhenClientBecomeBackgroundToZero;
{
    NSString *timeStr = @"0";
    [USER setValue:timeStr forKey:@"LastTimeWhenClientBecomeBackground"];
    [USER synchronize];
}

+(long long int)GetLastTimeWhenClientBecomeBackground;
{
    NSString *timeStr = [USER valueForKey:@"LastTimeWhenClientBecomeBackground"];
    return [timeStr longLongValue];
}

//获取当前时间到最后一次进入后台的时间差，单位：秒；
+(long long int)GetTimespanSinceLastTimeBecomeBackground;
{
    long long int lastBkTime = [SysInfo GetLastTimeWhenClientBecomeBackground];
    long long int currentTime = [[NSDate date] timeIntervalSince1970];
    long long int timespan = currentTime - lastBkTime;
    return timespan;
}

#pragma mark -
//获取用户登录是否成功的状态；
+(BOOL)GetSignInState;
{
    /*
    BOOL signState = [USER boolForKey:@"SignInState"];
    if(!signState){
        MyAccountManager *manager = [MyAccountManager sharedManager];
        NSString *token = [manager getToken];
        if(token && manager.currentUser){
            //向V1.3.x及以下的版本兼容；这些之前的版本还没有signState这个状态记录；
            signState = YES;
        }
    }
    return signState;
     */
    
    return YES;
}

/**
 *  登陆过程要走好几个步骤，如果中间某个步骤有问题，即使login成功，由于后续步骤不成功，无法获取用户资料，会导致出现相关功能不正确的情况；
 *  所以，只要登陆环节中的步骤没有全部成功，就认为登陆失败，是一种简单的处理办法；
 *  使用统一的状态来管理 是否登陆成功的状态，不要依赖于某个过程结果，便于理解；
 *
 *  @param signIn <#signIn description#>
 */
+ (void)SetSignInState:(BOOL)signIn{
    [USER setBool:signIn forKey:@"SignInState"];
    [USER synchronize];
}

#pragma mark - APNS
+(void)SetDeviceToken:(NSString*)_deviceToken
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:_deviceToken forKey:uk(@"DEVICETOKEN")];
    [userDefault synchronize];
}

+(NSString*)GetDeviceToken
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:uk(@"DEVICETOKEN")];
}

//获取当前配置的渠道编号
+ (NSNumber*)getCpId{
    NSString *infoPlist = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:infoPlist];
    NSNumber *cpId = [SysTools NumberObj:[dic valueForKey:@"kChannelNumber"]];
    return cpId;
}

/**
 appManager才是logout操作的主入口
 这个方法仅负责本类管理的内容
 */
+ (void)logout{
    
    [SysInfo SetDeviceToken:nil];
    [SysInfo SetSignInState:NO];
    [USER removeObjectForKey:@"LastTimeWhileClientStart"];
}


#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
