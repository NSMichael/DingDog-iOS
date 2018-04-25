//
//  EditInfoViewController.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/24.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerModel.h"

@interface EditInfoViewController : BaseViewController

- (instancetype)initWithModel:(CustomerModel *)model EditInfoType:(EditInfoType)type;

@end
