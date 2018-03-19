//
//  UITableViewCell+Height.h
//  ZhaoBu
//
//  Created by 耿功发 on 15/8/7.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Height)

/**
 下面是公用方法，可以放到UITableViewCell的category中
 */
- (CGFloat)calculateCellHeightInAutolayoutMode:(UITableViewCell*)cellRef tableView:(UITableView*)tableView;

@end
