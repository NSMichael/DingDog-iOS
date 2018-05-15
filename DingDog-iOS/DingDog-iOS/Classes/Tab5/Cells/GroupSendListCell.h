//
//  GroupSendListCell.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgGroupModel.h"

extern NSString * const GroupSendListCellIdentifier;

@interface GroupSendListCell : UITableViewCell

- (void)configCellDataWithMsgGroupModel:(MsgGroupModel *)groupModel;

@end
