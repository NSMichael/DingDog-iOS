//
//  MessageListCell.h
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/19.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

extern NSString * const MessageListCellIdentifier;

@interface MessageListCell : UITableViewCell

- (void)configCellDataWithMessageModel:(MessageModel *)model;

@end
