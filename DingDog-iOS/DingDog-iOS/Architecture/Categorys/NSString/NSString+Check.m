//
//  NSString+Phone.m
//  tranb
//
//  Created by Daniel_Li on 14/10/22.
//  Copyright (c) 2014年 cmf. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

- (BOOL)checkStringLegal{

    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"illegalString" ofType:@"txt"];
    NSString *stringViaText = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSString *regex =  [NSString stringWithFormat:@"%@",self];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS [cd]  %@", regex];
    return ![pred evaluateWithObject:stringViaText];
    
}

- (BOOL)checkChineseName{
    
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *regex =  @"^[\u4e00-\u9fa5]{2,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isChinese{
    
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *regex =  @"^[\u4e00-\u9fa5]{1,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


- (BOOL)checkEnglishName{
    
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *regex =  @"[A-Z0-9a-z._%+-]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)checkValidPersonName{
    
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *regex =  @"[A-Za-z\u4e00-\u9fa5._%+-]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)checkPassword{
    if (self == nil || self.length == 0) {
        return NO;
    }
    NSString *regex = @"\\b\\w{6,32}\\b";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)checkIsEmail{
    if (self == nil || self.length == 0) {
        return NO;
    }
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (BOOL)checkIsPhoneNum
{
    if (self == nil || self.length == 0) {
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(177)|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isMobileNumber
{
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)checkIsMoney
{
    if (self == nil || self.length == 0) {
        return NO;
    }
    
    NSString *regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)checkCateogory {
    if (self == nil || self.length == 0) {
        return NO;
    }
    
    NSString *regex = @"^[\u4E00-\u9FA5A-Za-z0-9\\/ ]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (NSString *)transToMoney
{
    if ([self rangeOfString:@"."].location != NSNotFound) {
        NSString *regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0})?$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:self]) {
            return [self stringByAppendingString:@"00"];
        }
        
        regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1})?$";
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:self]) {
            return [self stringByAppendingString:@"0"];
        }
    }
    return self;
}
@end
