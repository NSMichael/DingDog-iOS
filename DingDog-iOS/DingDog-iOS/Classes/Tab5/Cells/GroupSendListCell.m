//
//  GroupSendListCell.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendListCell.h"
#import "MsgGroupItem.h"
#import "SDWeiXinPhotoContainerView.h"
#import "PhotoEntity.h"
#import "SDAutoLayout.h"

NSString * const GroupSendListCellIdentifier = @"GroupSendListCellIdentifier";

@interface GroupSendListCell()

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblText;
@property (nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;

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

- (SDWeiXinPhotoContainerView *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        [self.contentView addSubview:_picContainerView];
    }
    return _picContainerView;
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
    
    self.lblTitle.sd_layout.topSpaceToView(self.contentView, 12).leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, -15);
    
    self.lblText.sd_layout.topSpaceToView(self.lblTitle, 12).leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, -15);
    
    self.picContainerView.sd_layout.topSpaceToView(self.lblText, 12).leftSpaceToView(self.contentView, 1).rightSpaceToView(self.contentView, -1);
}

- (void)setModel:(MsgGroupItem *)model {
    
    _model = model;
    
    self.lblTitle.text = model.title ? : @"";
    
    self.lblText.text = model.text ? : @"";
    
    NSString *imageStr = model.images;
    NSMutableArray *photos = [NSMutableArray array];
    
    if (imageStr.length > 0) {
        NSArray *imagesArr = [imageStr componentsSeparatedByString:@","];
        NSString *prefix = [MyAccountManager sharedManager].currentUser.configModel.cdn;
        for (int i = 0; i < imagesArr.count; i++) {
            NSString *imageKey = imagesArr[i];
            if (imageKey.length > 0) {
                PhotoEntity *entity = [[PhotoEntity alloc] init];
                entity.url = [NSString stringWithFormat:@"%@/%@", prefix, imageKey];
                [photos addObject:entity];
            }
        }
        self.picContainerView.picPathStringsArray = photos;
        
    } else {
        
    }
    
    UIView *bottomView;
    
    if (photos.count > 0) {
        bottomView = self.picContainerView;
    } else {
        bottomView = self.lblText;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:kPaddingLeftWidth];
}

@end
