//
//  UploadTokenCmd.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/16.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadTokenCmd : BaseCmd<MTLJSONSerializing>

@property (nonatomic, strong) NSString *upload_Token;

@end
