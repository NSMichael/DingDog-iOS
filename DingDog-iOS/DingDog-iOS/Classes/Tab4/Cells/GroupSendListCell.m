//
//  GroupSendListCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendListCell.h"

NSString * const GroupSendListCellIdentifier = @"GroupSendListCellIdentifier";

@interface GroupSendListCell ()

@property (nonatomic, strong) UIView *uvContainer;
@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblTime;


@end

@implementation GroupSendListCell

- (UIView *)uvContainer {
    if (!_uvContainer) {
        _uvContainer = [UIView new];
        [self.contentView addSubview:_uvContainer];
        
        _uvContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _uvContainer.layer.borderWidth = 0.5;
        _uvContainer.layer.cornerRadius = 5;
    }
    return _uvContainer;
}

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [UIImageView new];
        [self.uvContainer addSubview:_imgAvatar];
        
        _imgAvatar.layer.masksToBounds = YES;
        _imgAvatar.layer.cornerRadius = 5;
    }
    return _imgAvatar;
}

- (UILabel *)lblName {
    if (!_lblName) {
        _lblName = [UILabel new];
        [self.uvContainer addSubview:_lblName];
        
        _lblName.font = kFont16;
        _lblName.textColor = [UIColor blackColor];
    }
    return _lblName;
}

- (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [UILabel new];
        [self.uvContainer addSubview:_lblContent];
        
        _lblContent.preferredMaxLayoutWidth = kScreen_Width-30-30;
        _lblContent.font = kFont13;
        _lblContent.textColor = [UIColor grayColor];
        _lblContent.numberOfLines = 3;
    }
    return _lblContent;
}

- (UILabel *)lblTime {
    if (!_lblTime) {
        _lblTime = [UILabel new];
        [self.uvContainer addSubview:_lblTime];
        
        _lblTime.font = kFont10;
        _lblTime.textColor = [UIColor grayColor];
    }
    return _lblTime;
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupConstraints {
    
    [self.uvContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.right.equalTo(self.uvContainer);
        make.height.mas_equalTo(220);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvContainer).offset(15);
        make.right.equalTo(self.uvContainer).offset(-15);
        make.top.equalTo(self.imgAvatar.mas_bottom).offset(10);
    }];
    
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvContainer).offset(15);
        make.right.equalTo(self.uvContainer).offset(-15);
        make.top.equalTo(self.lblName.mas_bottom).offset(10);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvContainer).offset(15);
        make.right.equalTo(self.uvContainer).offset(-15);
        make.top.equalTo(self.lblContent.mas_bottom).offset(10);
        make.bottom.equalTo(self.uvContainer).offset(-15);
    }];
}

- (void)configCellDataWithGroupSendModel:(GroupSendModel *)model {
    if (!model) {
        return;
    }
    
    self.imgAvatar.image = [UIImage imageNamed:@"40808294991"];
    
    self.lblName.text = model.name;
    
    self.lblContent.text = model.content;
    
    self.lblTime.text = model.time;
}

@end
