//
//  MsgGroupModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgGroupItem.h"

@interface MsgGroupModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *created_dt;

@property (nonatomic, strong) MsgGroupItem *msgGroupItem;

@end
