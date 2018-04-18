//
//  CustomerListCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CustomerListCell.h"
#import "TTGTextTagCollectionView.h"

NSString * const CustomerListCellIdentifier = @"CustomerListCellIdentifier";

@interface CustomerListCell ()

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;

@end

@implementation CustomerListCell

- (UIButton *)btnRadio {
    if (!_btnRadio) {
        _btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnRadio];
        
        [_btnRadio setBackgroundImage:[UIImage imageNamed:@"icon-readed-g"] forState:UIControlStateNormal];
    }
    return _btnRadio;
}

- (UIImageView *)imgAvatar {
    if (!_imgAvatar) {
        _imgAvatar = [UIImageView new];
        [self.contentView addSubview:_imgAvatar];
        
        _imgAvatar.layer.cornerRadius = 24;
        _imgAvatar.layer.masksToBounds = YES;
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

- (TTGTextTagCollectionView *)tagView {
    if (!_tagView) {
        _tagView = [TTGTextTagCollectionView new];
        [self.contentView addSubview:_tagView];
        
        // Alignment
        _tagView.alignment = TTGTagCollectionAlignmentLeft;
        // Use manual calculate height
        _tagView.manualCalculateHeight = YES;
        
        _tagView.defaultConfig.tagTextFont = kFont10;
        _tagView.defaultConfig.tagTextColor = [UIColor colorWithHexString:@"0x#454553"];
        _tagView.defaultConfig.tagBackgroundColor = [UIColor clearColor];
        _tagView.defaultConfig.tagBorderColor = [UIColor clearColor];
        _tagView.defaultConfig.tagShadowColor = [UIColor clearColor];
        _tagView.enableTagSelection = NO;
        
    }
    return _tagView;
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
    
    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.imgAvatar.mas_right).offset(12);
        make.height.mas_equalTo(22);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom).offset(3);
        make.left.equalTo(self.imgAvatar.mas_right).offset(12);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
    
    [self.btnRadio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
}

- (void)configCellDataWithCustomerModel:(CustomerModel *)model ShowSelected:(BOOL)isShow {
    
    if (!model) {
        return;
    }
    
    if (isShow) {
        self.btnRadio.hidden = NO;
    } else {
        self.btnRadio.hidden = YES;
    }
    
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:nil];
    self.lblName.text = model.nickname;
    
    NSArray *arr = model.tagArray;
    
    if (arr.count > 0) {
        NSMutableArray *tagArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            NSString *tagStr = arr[i];
            [tagArr addObject:tagStr];
        }
        
        [_tagView removeAllTags];
        [_tagView addTags:tagArr];
        
        // Use manual height, update preferredMaxLayoutWidth
        _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 72 - 30;
    } else {
        [self.imgAvatar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-12);
        }];
    }
    
}

@end
