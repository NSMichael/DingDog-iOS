//
//  CustomerModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"

@interface CustomerModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *since;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *headimgurl;

@property (nonatomic, strong) NSArray *tagArray;

@end
