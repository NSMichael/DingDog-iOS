//
//  CustomerModel.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"

@interface CustomerModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray *tagArray;

@end
