//
//  MessageListCell.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/19.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "TagListCell.h"

NSString * const TagListCellIdentifier = @"TagListCellIdentifier";

@interface TagListCell ()

@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) UILabel *lblName;

@end

@implementation TagListCell

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
        make.left.equalTo(self.imgAvatar.mas_right).offset(12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(22);
    }];
}

- (void)configCellDataWithTagModel:(TagModel *)model {
    if (!model) {
        return;
    }
    
    self.imgAvatar.image = [UIImage imageNamed:@"icon-img-app"];
    
    self.lblName.text = model.tagName;
}

@end
