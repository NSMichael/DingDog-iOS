//
//  ChangeUserTagCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "ChangeUserTagCell.h"

NSString * const ChangeUserTagCellIdentifier = @"ChangeUserTagCellIdentifier";

@interface ChangeUserTagCell ()

@end

@implementation ChangeUserTagCell

- (TTGTextTagCollectionView *)tagView {
    if (!_tagView) {
        _tagView = [TTGTextTagCollectionView new];
        [self.contentView addSubview:_tagView];
        
        // Alignment
        _tagView.alignment = TTGTagCollectionAlignmentLeft;
        // Use manual calculate height
        _tagView.manualCalculateHeight = YES;
        
        _tagView.defaultConfig.tagTextFont = kFont14;
        _tagView.defaultConfig.tagTextColor = [UIColor colorWithHexString:@"0x000000"];
        _tagView.defaultConfig.tagBackgroundColor = [UIColor clearColor];
        _tagView.defaultConfig.tagBorderColor = [UIColor lightGrayColor];
        _tagView.defaultConfig.tagShadowColor = [UIColor clearColor];
        _tagView.defaultConfig.tagCornerRadius = 18;
        _tagView.defaultConfig.tagSelectedCornerRadius = 18;
        _tagView.defaultConfig.tagSelectedBackgroundColor = [UIColor colorWithHexString:@"0x007AFF"];
        _tagView.defaultConfig.tagExtraSpace = CGSizeMake(65, 18);
        
        _tagView.defaultConfig.tagMinWidth = 50;
        
//        _tagView.userInteractionEnabled = NO;
//        _tagView.enableTagSelection = NO;
        
    }
    return _tagView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
}

- (void)configCellDataWithCustomerModel:(CustomerModel *)model AllTagArray:(NSArray *)allTagArray {
    
    if (!model) {
        return;
    }
    
    NSArray *arr = allTagArray;
    NSMutableArray *tagArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        TagModel *tagModel = arr[i];
        [tagArr addObject:tagModel.tagName];
    }
    [_tagView removeAllTags];
    [_tagView addTags:tagArr];
    
    for (int i = 0; i < model.tagArray.count; i++) {
        NSString *value1 = model.tagArray[i];
        for (int j = 0; j < tagArr.count; j++) {
            NSString *value2 = tagArr[j];
            if ([value1 isEqualToString:value2]) {
                [_tagView setTagAtIndex:j selected:YES];
            }
        }
    }
    
    // Use manual height, update preferredMaxLayoutWidth
    _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30;
}

- (void)configCellDataWithAllTagArray:(NSArray *)allTagArray SelectedTagArray:(NSArray *)selectedArray {
    
    if (allTagArray.count == 0) {
        return;
    }
    
    NSMutableArray *tagArr = [NSMutableArray array];
    for (int i = 0; i < allTagArray.count; i++) {
        TagModel *tagModel = allTagArray[i];
        [tagArr addObject:tagModel.tagName];
    }
    [_tagView removeAllTags];
    [_tagView addTags:tagArr];
    
    for (int i = 0; i < tagArr.count; i++) {
        NSString *value1 = tagArr[i];
        for (int j = 0; j < selectedArray.count; j++) {
            NSString *value2 = selectedArray[j];
            if ([value1 isEqualToString:value2]) {
                [_tagView setTagAtIndex:i selected:YES];
            }
        }
    }
    
    
    // Use manual height, update preferredMaxLayoutWidth
    _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 30;
}


@end
