//
//  SysTools.m
//  vdangkou
//
//  Created by Smalltask on 15/3/10.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "SysTools.h"

@implementation SysTools


#pragma mark 系统函数
/**
 *  生成一个全局唯一的随机数
 *
 *  @return <#return value description#>
 */
+ (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    //create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}

#pragma mark -
+(NSString*)userKey:(NSString*)identityStr
{
    if(!identityStr)
        identityStr = @"";
    
    NSNumber *myUserId = [USER objectForKey:@"MyUserId"];
    if(!myUserId)
        myUserId = [NSNumber numberWithInteger:0];
    NSString *keystr = [NSString stringWithFormat:@"%@_%lld",identityStr,[myUserId longLongValue]];
    return keystr;
}


#pragma mark UI 
+(id)createViewFromXib:(NSString*)xibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    return uv;
}

#pragma mark 解析Json中的内容
+(NSString*)StringObj:(id)_ob;
{
    if(!_ob)
        return @"";
    else if([_ob isEqual:[NSNull null]])
        return @"";
    else if([_ob isKindOfClass:[NSNumber class]])
        return [_ob stringValue];
    else if([_ob isKindOfClass:[NSString class]])
        return _ob;
    else
        return @"";
}

+(NSNumber*)NumberObj:(id)_ob;
{
    if(!_ob)
        return [NSNumber numberWithInt:0];
    else if([_ob isEqual:[NSNull null]])
        return [NSNumber numberWithInt:0];
    else if([_ob isKindOfClass:[NSNumber class]])
        return _ob;
    else if([_ob isKindOfClass:[NSString class]])
    {
        NSNumber *num = nil;
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        if ([f numberFromString:_ob])
        {
            num = [NSNumber numberWithDouble:[_ob doubleValue]];
        }
        else
        {
            num = [NSNumber numberWithInt:0];
        }
        
        return num;
    }else
        return [NSNumber numberWithInt:0];
    
}

+(NSMutableArray*)NSMutableArrayObj:(id)_ob;
{
    if(!_ob)
        return [NSMutableArray arrayWithCapacity:1];
    else if([_ob isKindOfClass:[NSMutableArray class]]){
        return _ob;
    }else if([_ob isKindOfClass:[NSArray class]]){
        return [_ob mutableCopy];
    }else if([_ob isKindOfClass:[NSString class]]){
        return [NSMutableArray arrayWithObject:_ob];
    }else if([_ob isKindOfClass:[NSNumber class]]){
        return [NSMutableArray arrayWithObject:_ob];
    }else {
        return [NSMutableArray arrayWithCapacity:1];
    }
    
}


#pragma mark - Java Spring MVC
/**
 
 //test
 //    ProductUnit *pu = [[ProductUnit alloc] init];
 //    NSDictionary *dic = @{@"key1":@"123"};
 //    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithDictionary:dic];
 //    [json setObject:@{@"II_K":@"II_V"} forKey:@"key2"];
 //    NSDictionary *ddk = @{@"ddk":@"ddv"};
 //    NSArray *dda = @[ddk];
 //    [json setObject:@[@"a1",@"a2",@[@"b1",@"b2",dda],@"a4"] forKey:@"key3"];
 //    NSMutableDictionary *postDict = [pu getHttpPostParams:json];
 //    SLOG(@"postDict:%@",postDict);
 //
 //
 //
 输出：
 Printing description of postDict:
 {
 key1 = 123;
 "key2.II_K" = "II_V";
 "key3[0]" = a1;
 "key3[1]" = a2;
 "key3[2][0]" = b1;
 "key3[2][1]" = b2;
 "key3[2][2][0].ddk" = ddv;
 "key3[3]" = a4;
 }
 
 */

/**
 构建用于发送到服务器的请求参数字典
 */
+ (NSMutableDictionary*)getHttpPostParams:(NSDictionary*)json
{
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithCapacity:10];
    
    for(NSString *key in json){
        id obj = [json objectForKey:key];
        if([obj isKindOfClass:[NSDictionary class]]){
            //对象套对象
            if([obj count]>0){
                NSMutableString *pstr = [NSMutableString stringWithString:key];
                [SysTools readFromDict:obj toDict:postParams rootStr:key parentStr:pstr];
            }
        }else if([obj isKindOfClass:[NSArray class]]){
            //展开数组
            if([obj count]>0){
                NSMutableString *pstr = [NSMutableString stringWithString:key];
                [SysTools readFromArray:obj toDict:postParams rootStr:key parentStr:pstr];
            }
        }else{
            if(obj == [NSNull null])
                continue;
            [postParams setObject:obj forKey:key];
        }
    }
    return postParams;
}

+ (void)readFromDict:(NSDictionary*)sDict toDict:(NSMutableDictionary*)tDict rootStr:(NSString*)rootStr parentStr:(NSMutableString*)parentStr{
    for(NSString *key in sDict){
        id obj = [sDict objectForKey:key];
        if([obj isKindOfClass:[NSDictionary class]]){
            if([obj count]>0){
                
                [parentStr appendString:@"."];
                [parentStr appendString:key];
                [SysTools readFromDict:obj toDict:tDict rootStr:rootStr parentStr:parentStr];
            }
        }else if([obj isKindOfClass:[NSArray class]]){
            if([obj count]>0){
                [parentStr appendString:@"."];
                [parentStr appendString:key];
                [SysTools readFromArray:obj toDict:tDict rootStr:parentStr parentStr:parentStr];
            }
        }else{
            if(obj == [NSNull null])
                continue;
            NSString *keystr = [NSString stringWithFormat:@"%@.%@",rootStr,key];
            [tDict setObject:obj forKey:keystr];
        }
    }
}

+ (void)readFromArray:(NSArray*)sArray toDict:(NSMutableDictionary*)tDict rootStr:(NSString*)rootStr parentStr:(NSMutableString*)parentStr{
    for(int i=0;i<sArray.count;i++){
        id obj = sArray[i];
        NSString *tmpKey = [NSString stringWithFormat:@"%@[%d]",rootStr,i];
        
        if([obj isKindOfClass:[NSDictionary class]]){
            if([obj count]>0){
                [SysTools readFromDict:obj toDict:tDict rootStr:tmpKey parentStr:parentStr];
            }
        }else if([obj isKindOfClass:[NSArray class]]){
            if([obj count]>0){
                [SysTools readFromArray:obj toDict:tDict rootStr:tmpKey parentStr:parentStr];
            }
        }else{
            if(obj == [NSNull null])
                continue;
            [tDict setObject:obj forKey:tmpKey];
        }
    }
}

#pragma mark - date time
//返回单位：毫秒
+(long long int)GetCurrentTimeNumber;
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int uu = time*1000;//＊1000是为了与服务器端的格式一致；
    //    SLOG(@"SysTools.GetCurrentTimeNumber,time:%lli",uu);
    return uu;
}

#pragma mark - 字符串

/**
 *  比较两个版本号，返回版本号中，最大的那个字符串
 *  版本号必须都是3段式的；
 *
 *  @param ver1 <#ver1 description#>
 *  @param ver2 <#ver2 description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getMaxVersion:(NSString*)ver1 version2:(NSString*)ver2
{
    NSArray *array_ver1 = [ver1 componentsSeparatedByString:@"."];
    NSArray *array_ver2 = [ver2 componentsSeparatedByString:@"."];
    if(array_ver1.count==array_ver2.count){
        for(int i=0;i<array_ver1.count;i++){
            if([array_ver1[i] integerValue] > [array_ver2[i] integerValue]){
                return ver1;
            }else if([array_ver1[i] integerValue] < [array_ver2[i] integerValue]){
                return ver2;
            }else{
                continue;
            }
        }
        return ver1;
    }else if(array_ver1.count>array_ver2.count){
        return ver1;
    }else if(array_ver1.count<array_ver2.count){
        return ver2;
    }else{
        NSAssert(0, @"不可能发生的事情~");
        return ver1;
    }
}


+(NSString*)GetFommatPhoneNumber:(NSString*)_phoneNumber;
{
    NSMutableString *phoneStr = [[NSMutableString alloc] initWithCapacity:10];
    NSRange range;
    for(int i=0;i<_phoneNumber.length;i++)
    {
        range.location = i;
        range.length = 1;
        NSString *oneletter = [_phoneNumber substringWithRange:range];
        NSString *regex = @"[0-9]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL result = [pred evaluateWithObject:_phoneNumber];
        if(result){
            [phoneStr appendString:oneletter];
        }
    }
    return phoneStr;
}

@end
