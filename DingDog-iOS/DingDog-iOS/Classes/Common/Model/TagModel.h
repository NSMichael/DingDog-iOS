//
//  TagModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *tagIcon;
@property (nonatomic, strong) NSString *memberTotal;

@end
