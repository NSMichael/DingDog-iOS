//
//  UserTagListCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "UserTagListCell.h"
#import "TTGTextTagCollectionView.h"

NSString * const UserTagListCellIdentifier = @"UserTagListCellIdentifier";

@interface UserTagListCell()

@property (nonatomic, strong) UIImageView *imgSeparatorLine;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;

@end

@implementation UserTagListCell

- (UIImageView *)imgSeparatorLine {
    if (!_imgSeparatorLine) {
        _imgSeparatorLine = [UIImageView new];
        [self.contentView addSubview:_imgSeparatorLine];
        
        _imgSeparatorLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    }
    return _imgSeparatorLine;
}

- (UILabel *)lblName {
    if (!_lblName) {
        _lblName = [UILabel new];
        [self.contentView addSubview:_lblName];
        
        _lblName.font = kFont13;
        _lblName.text = @"标签";
        _lblName.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
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
        _tagView.defaultConfig.tagTextColor = [UIColor colorWithHexString:@"0x000000"];
        _tagView.defaultConfig.tagBackgroundColor = [UIColor clearColor];
        _tagView.defaultConfig.tagBorderColor = [UIColor clearColor];
        _tagView.defaultConfig.tagShadowColor = [UIColor clearColor];
        _tagView.userInteractionEnabled = NO;
        _tagView.enableTagSelection = NO;
        
    }
    return _tagView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    [self.imgSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgSeparatorLine.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(22);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(6);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
}

- (void)configCellDataWithCustomerModel:(CustomerModel *)model {
    
    if (!model) {
        return;
    }
    
    self.lblName.text = model.nickname ? : @"";
    
    NSArray *arr = model.tagArray;
    NSMutableArray *tagArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSString *tagStr = arr[i];
        [tagArr addObject:tagStr];
    }
    [_tagView removeAllTags];
    [_tagView addTags:tagArr];
    
    // Use manual height, update preferredMaxLayoutWidth
    _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30 - 30;
}

@end
