//
//  ProductImgCell.h
//  vdangkou
//  ProductProfile界面中，图片编辑的那个cell.
//  这个cell里有多张产品图片，可以添加或删除图片
//  Created by Smalltask on 15/3/20.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEntity.h"

typedef NS_ENUM(NSInteger, ImgCellType)
{
    CELL_PRODUCT_IMG = 0,
    CELL_COLOR_IMG,
    CELL_STORE_IMG,
    CELL_ORDER_SEND_VOUCHER, // 确认发货凭证
    CELL_QUOTE,
    CELL_DEPLOY_TIMELINE,       // 每日动态
};

@interface ProductImgEditView : UIView
{
    CGFloat imgWidth;
    NSInteger MaxColumnCount;
    NSInteger cellType;
    CGFloat lineGapBase;
}

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) id mTarget;
@property (nonatomic,assign) SEL mActionClick;
@property (nonatomic,assign) SEL mActionDel;

@property (nonatomic,strong) UIButton *btAddImg;


- (void)addTarget:(id)target
           actionClick:(SEL)actionClick
        actionDel:(SEL)actionDel
 forControlEvents:(UIControlEvents)controlEvents;


- (CGFloat)paintWithPhotoArray:(NSMutableArray*)picturesArray isForHeight:(BOOL)isForHeight;

- (UIView*)createImgView:(NSArray*)imgArray isForHeight:(BOOL)isForHeight;
- (instancetype) initWithType:(ImgCellType)type;


@end
