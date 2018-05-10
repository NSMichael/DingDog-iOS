//
//  CustomerListCell.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"

extern NSString * const CustomerListCellIdentifier;

@interface CustomerListCell : UITableViewCell

@property (nonatomic, strong) UIButton *btnRadio;

- (void)configCellDataWithCustomerModel:(CustomerModel *)model ShowSelected:(BOOL)isShow;

- (void)configCellDataWithCustomerModel:(CustomerModel *)model ExTagArray:(NSArray *)exTagArray;

- (void)configCellDataWithCustomerModel:(CustomerModel *)model;

@end
