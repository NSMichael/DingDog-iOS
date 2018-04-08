//
//  GroupSendModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupSendModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *viewCount;
@property (nonatomic, strong) NSString *forwardingCount;

@end
