//
//  TimeLineTextCell.h
//  ZhaoBu
//
//  Created by 耿功发 on 16/9/19.
//  Copyright © 2016年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

extern NSString * const TimeLineTextCellIdentifier;

@interface TimeLineTextCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, copy) void(^textValueChangedBlock)(NSString *);

+ (CGFloat)cellHeight;

@end
