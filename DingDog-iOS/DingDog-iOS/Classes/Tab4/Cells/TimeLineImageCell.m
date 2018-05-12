//
//  TimeLineImageCell.m
//  ZhaoBu
//
//  Created by 耿功发 on 16/9/19.
//  Copyright © 2016年 9tong. All rights reserved.
//

#import "TimeLineImageCell.h"

NSString * const TimeLineImageCellIdentifier = @"TimeLineImageCellIdentifier";

@implementation TimeLineImageCell

- (ProductImgEditView *)imgEditView {
    if (!_imgEditView) {
        _imgEditView = [[ProductImgEditView alloc] initWithType:CELL_DEPLOY_TIMELINE];
        _imgEditView.frame = CGRectMake(0, 0, kScreen_Width, 300);
        _imgEditView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_imgEditView];
    }
    return _imgEditView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)paintWithDefaultPhotoArray:(NSMutableArray*)photoArray {
    CGRect originalFrame = self.imgEditView.frame;
    _imgEditView.height = [self.imgEditView paintWithPhotoArray:photoArray isForHeight:NO];
    _imgEditView.frame = originalFrame;
    _imgEditView.y = 0;
}

@end
