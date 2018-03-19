//
//  MessageListCell.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/19.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MessageListCell.h"

NSString * const MessageListCellIdentifier = @"MessageListCellIdentifier";

@interface MessageListCell ()

@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UILabel *lblMessage;
@property (nonatomic, strong) UIImageView *imgStatus;

@end

@implementation MessageListCell

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [UIImageView new];
        [self.contentView addSubview:_imgAvatar];
    }
    return _imgAvatar;
}

- (UILabel *)lblName {
    if (!_lblName) {
        _lblName = [UILabel new];
        [self.contentView addSubview:_lblName];
        
        _lblName.font = kFont16;
        _lblName.textColor = [UIColor colorWithHexString:@"0x000000"];
    }
    return _lblName;
}

- (UILabel *)lblTime {
    if (!_lblTime) {
        _lblTime = [UILabel new];
        [self.contentView addSubview:_lblTime];
        
        _lblTime.font = kFont13;
        _lblTime.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    }
    return _lblTime;
}

- (UILabel *)lblMessage {
    if (!_lblMessage) {
        _lblMessage = [UILabel new];
        [self.contentView addSubview:_lblMessage];
        
        _lblMessage.font = kFont13;
        _lblMessage.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    }
    return _lblMessage;
}

- (UIImageView *)imgStatus {
    if (!_imgStatus) {
        _imgStatus = [UIImageView new];
        [self.contentView addSubview:_imgStatus];
    }
    return _imgStatus;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupConstraints {
    
    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.contentView).offset(12);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.imgAvatar.mas_right).offset(12);
        make.height.mas_equalTo(22);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(18);
    }];
    
    [self.lblMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom).offset(3);
        make.left.equalTo(self.imgAvatar.mas_right).offset(12);
    }];
    
    [self.imgStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.lblTime.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}

- (void)configCellDataWithMessageModel:(MessageModel *)model {
    if (!model) {
        return;
    }
    
    self.imgAvatar.image = [UIImage imageNamed:@"icon-img-app"];
    
    self.lblName.text = model.name;
    
    self.lblTime.text = model.time;
    
    self.lblMessage.text = model.content;
    
    self.imgStatus.image = [UIImage imageNamed:@"icon-readed-g"];
}

@end
