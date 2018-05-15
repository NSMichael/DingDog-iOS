//
//  GroupSendListCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendListCell.h"
#import "MsgGroupItem.h"

NSString * const GroupSendListCellIdentifier = @"GroupSendListCellIdentifier";

@interface GroupSendListCell()

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblText;

@end

@implementation GroupSendListCell

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        [self.contentView addSubview:_lblTitle];
        
        _lblTitle.font = kFont14;
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.numberOfLines = 2;
    }
    return _lblTitle;
}

- (UILabel *)lblText {
    if (!_lblText) {
        _lblText = [UILabel new];
        [self.contentView addSubview:_lblText];
        
        _lblText.font = kFont14;
        _lblText.textColor = [UIColor grayColor];
        _lblText.numberOfLines = 2;
    }
    return _lblText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblTitle.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
    
}

- (void)configCellDataWithMsgGroupModel:(MsgGroupModel *)groupModel {
    if (!groupModel) {
        return;
    }
    
    MsgGroupItem *item = groupModel.msgGroupItem;
    
    self.lblTitle.text = item.title ? : @"";
    
    self.lblText.text = item.text ? : @"";
}

@end
