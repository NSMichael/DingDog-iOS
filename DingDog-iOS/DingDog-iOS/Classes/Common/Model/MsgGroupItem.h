//
//  MsgGroupItem.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgGroupItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *is_public;

@end
