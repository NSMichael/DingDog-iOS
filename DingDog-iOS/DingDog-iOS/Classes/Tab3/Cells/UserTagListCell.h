//
//  UserTagListCell.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"

extern NSString * const UserTagListCellIdentifier;

@interface UserTagListCell : UITableViewCell

- (void)configCellDataWithCustomerModel:(CustomerModel *)model;

@end
