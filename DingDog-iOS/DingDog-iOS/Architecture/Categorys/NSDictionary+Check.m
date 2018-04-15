//
//  NSDictionary+Check.m
//  vdangkou
//
//  Created by Smalltask on 15/3/24.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "NSDictionary+Check.h"

@implementation NSDictionary (Check)

- (NSDictionary*)removeEmptyValue
{
    if(self){
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
        
        for(NSString *keystr in self){
            id object = [self objectForKey:keystr];
            if(object == [NSNull null] || [object isKindOfClass:[UIImage class]]){
                //跳过
            }else if([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *tmp = [object removeEmptyValue];
                [dict setObject:tmp forKey:keystr];
            }else if([object isKindOfClass:[NSArray class]]){
                NSArray *tmp = [self removeEmptyValueFromArray:object];
                [dict setObject:tmp forKey:keystr];
            }
            else{
                [dict setObject:object forKey:keystr];
            }
        }
        return dict;
    }
    else
        return [NSDictionary dictionary];
}

-(NSArray*)removeEmptyValueFromArray:(NSArray*)array{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:array.count];
    for(id object in array){
        if(object == [NSNull null]  || [object isKindOfClass:[UIImage class]]){
            //跳过
        }else if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary *tmp = [object removeEmptyValue];
            [tmpArray addObject:tmp];
        }else if([object isKindOfClass:[NSArray class]]){
            NSArray *tmp = [self removeEmptyValueFromArray:object];
            [tmpArray addObject:tmp];
        }else{
            [tmpArray addObject:object];
        }
    }
    return tmpArray;
}

@end
