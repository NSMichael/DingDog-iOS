//
//  MessageListCell.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/19.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagModel.h"

extern NSString * const TagListCellIdentifier;

@interface TagListCell : UITableViewCell

- (void)configCellDataWithTagModel:(TagModel *)model;

@end
