//
//  ProductImgCell.m
//  vdangkou
//
//  Created by Smalltask on 15/3/20.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "ProductImgEditView.h"
#import "UIButton+WebCache.h"

#define MaxImgCount 4

@interface ProductImgEditView()
{

}

@end

@implementation ProductImgEditView

- (void)dealloc{
    self.mTarget = nil;
    self.mActionClick = nil;
    self.mActionDel = nil;
    self.bgView = nil;
    self.btAddImg = nil;    
}

- (instancetype)init
{
    self = [super init];
    if(self){
        imgWidth = 60;
        MaxColumnCount = 4;
        cellType = CELL_PRODUCT_IMG;
    }
    return self;
}

- (instancetype) initWithType:(ImgCellType)type {
    if (self = [super init]) {
        imgWidth = 60;
        MaxColumnCount = 4;
        cellType = type;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)addTarget:(id)target
      actionClick:(SEL)actionClick
        actionDel:(SEL)actionDel
 forControlEvents:(UIControlEvents)controlEvents{
    self.mTarget = target;
    self.mActionClick = actionClick;
    self.mActionDel = actionDel;
}

- (CGFloat)paintWithPhotoArray:(NSMutableArray*)picturesArray isForHeight:(BOOL)isForHeight 
{
    if(!picturesArray)
        return 0;
    
    if (cellType == CELL_DEPLOY_TIMELINE) {
        lineGapBase = 15;
    } else {
        lineGapBase = 30;
    }
    
    if(self.bgView){
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
    if(cellType == CELL_PRODUCT_IMG || cellType == CELL_STORE_IMG || cellType == CELL_ORDER_SEND_VOUCHER || cellType == CELL_QUOTE || cellType == CELL_DEPLOY_TIMELINE){
        self.bgView = [self createImgView:picturesArray isForHeight:isForHeight];
    }
    if(!isForHeight){
        [self addSubview:self.bgView];
    }
    
    return self.bgView.height;
}


- (UIView*)createImgView:(NSArray*)imgArray isForHeight:(BOOL)isForHeight
{

    CGFloat bottomGap = 5;//底边距
    CGFloat scale = kScreen_Width/320.;//缩放因子，自动缩放图片和间距，让iphone5，iphone6，iphone6plus上的排版看起来可以更好看一些；
    
    UIView *uv = [[UIView alloc] initWithFrame:CGRectZero];
    NSInteger px = 25;
    NSInteger py = 15,columnGap = 8;
    NSInteger width = imgWidth * scale;
    
    CGFloat lineGap = lineGapBase * scale;
    
    NSInteger lineCount = 1;
    
    columnGap = (kScreen_Width - px)/MaxColumnCount - width;
    
    NSInteger imgCount = imgArray.count;
    NSInteger virtualCount = imgCount<9?imgCount+1:imgCount;
    
    lineCount = virtualCount/MaxColumnCount;
    if(virtualCount % MaxColumnCount>0)
        lineCount++;
    
    if(isForHeight){
        uv.frame = CGRectMake(0, 0, kScreen_Width, py + lineCount * (width + lineGap) + bottomGap);
        return uv;
    }
    
    CGFloat cx = 0,cy = 0;
    
    NSInteger tag=0;
    
    if (cellType == CELL_DEPLOY_TIMELINE) {
        
        for (int i = 0; i < 9; i++) {
            cx = tag%MaxColumnCount * (columnGap + width);
            cy = tag/MaxColumnCount * (lineGap + width);
            UIButton *btAddPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
            btAddPhoto.frame = CGRectMake(px + cx, py + cy, width, width);
            
            [btAddPhoto setImage:[UIImage imageNamed:@"icon-addimg"] forState:UIControlStateNormal];
            [uv addSubview:btAddPhoto];
            [btAddPhoto addTarget:self.mTarget  action:self.mActionClick forControlEvents:UIControlEventTouchUpInside];
            btAddPhoto.tag = tag;
            tag++;
            
            if (imgCount > 0) {
                
                if (i == imgCount) {
                    btAddPhoto.hidden = NO;
                } else {
                    btAddPhoto.hidden = YES;
                }
                
            } else {
                if (i == 0) {
                    btAddPhoto.hidden = NO;
                } else {
                    btAddPhoto.hidden = YES;
                }
            }
        }
        
    } else {
        for (int i=0;i<MaxColumnCount;i++){
            cx = tag%MaxColumnCount * (columnGap + width);
            cy = tag/MaxColumnCount * (lineGap + width);
            UIButton *btAddPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
            btAddPhoto.frame = CGRectMake(px + cx, py + cy, width, width);
            switch (cellType) {
                case CELL_PRODUCT_IMG:
                    [btAddPhoto setImage:[UIImage imageNamed:[NSString stringWithFormat:@"upload-box%d", i+1]] forState:UIControlStateNormal];
                    break;
                case CELL_STORE_IMG:
                    [btAddPhoto setImage:[UIImage imageNamed:@"upload-box-dptp"] forState:UIControlStateNormal];
                    break;
                case CELL_ORDER_SEND_VOUCHER:
                    [btAddPhoto setImage:[UIImage imageNamed:[NSString stringWithFormat:@"upload-box-cer%d", i+1]] forState:UIControlStateNormal];
                    break;
                case CELL_DEPLOY_TIMELINE:
                    [btAddPhoto setImage:[UIImage imageNamed:@"icon-addimg"] forState:UIControlStateNormal];
                    break;
                case CELL_QUOTE:
                    [btAddPhoto setImage:[UIImage imageNamed:@"upload-box1-seka"] forState:UIControlStateNormal];
                    break;
                default:
                    [btAddPhoto setImage:[UIImage imageNamed:@"photoframe"] forState:UIControlStateNormal];
                    break;
            }
            [uv addSubview:btAddPhoto];
            [btAddPhoto addTarget:self.mTarget  action:self.mActionClick forControlEvents:UIControlEventTouchUpInside];
            btAddPhoto.tag = tag;
            tag++;
        }
    }
    
    tag=0;
    for (int i=0; i<imgCount; i++) {
        PhotoEntity *photo = [imgArray objectAtIndex:i];
        
        cx = tag%MaxColumnCount * (columnGap + width);
        cy = tag/MaxColumnCount * (lineGap + width);
        UIButton *buttonImage=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage.contentMode=UIViewContentModeScaleToFill;
        
        buttonImage.frame=CGRectMake(px + cx, py + cy, width, width);
        [buttonImage.layer setMasksToBounds:YES];
        
        if (cellType == CELL_DEPLOY_TIMELINE) {
            [buttonImage.layer setCornerRadius:1];
        } else {
            [buttonImage.layer setCornerRadius:5];
        }
        
        [buttonImage setImage:IMG_PLACEHOLDER_PRODUCT forState:UIControlStateNormal];
        buttonImage.tag = tag;
        buttonImage.imageView.contentMode = UIViewContentModeScaleAspectFill;

        [buttonImage addTarget:self.mTarget  action:self.mActionClick forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:buttonImage];
        
        if(photo.isLocal){
            [buttonImage setImage:[UIImage imageWithContentsOfFile:photo.imgfilePath] forState:UIControlStateNormal];
        }else{
            //列表中展示小图片即可
            NSString *imgFileUrl = photo.url;
            [buttonImage sd_setImageWithURL:[NSURL URLWithString:imgFileUrl] forState:UIControlStateNormal placeholderImage:IMG_PLACEHOLDER_PRODUCT completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(error){
                    //nothing..
                }else{
                    photo.img = image;
                    [buttonImage setImage:image forState:UIControlStateNormal];
                }
            }];
        }
        
        //删除 图片的小按钮
        UIButton *btImgDel = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgDelIcon = [UIImage imageNamed:@"btn－x－y"];
        [btImgDel setImage:imgDelIcon forState:UIControlStateNormal];
        btImgDel.contentMode = UIViewContentModeScaleToFill;
        btImgDel.tag = tag;
        [btImgDel addTarget:self.mTarget action:self.mActionDel forControlEvents:UIControlEventTouchUpInside];
        btImgDel.frame = CGRectMake(buttonImage.x + buttonImage.width - 12, buttonImage.y - 10, 22, 22);
        [uv addSubview:btImgDel];
        
        /*
        //每张图片下面有一个图片名称
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(buttonImage.x - columnGap/4, buttonImage.y + buttonImage.height + 5*scale, width + columnGap/2, 15)];
        lbTitle.font = kFont13;
        lbTitle.textColor = kColorBlack;
        lbTitle.backgroundColor = kColorClear;
        lbTitle.text = photo.title;
        lbTitle.textAlignment = NSTextAlignmentCenter;
        [lbTitle adjustsFontSizeToFitWidth];
        [uv addSubview:lbTitle];
         */
        
        //如果是封面图片，则显示一个“封面”的小蒙层；
        /*
        if(tag==0 && cellType==CELL_PRODUCT_IMG){
            UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
            btnEdit.frame = CGRectMake(0, width - 20, width, 20);
            btnEdit.tag = tag;
            // 萌萌说要删掉标记给删除掉
            //                [btnEdit setImage:[UIImage imageNamed:@"icon_avatar_edit"] forState:UIControlStateNormal];
            [btnEdit setTitle:@"封面" forState:UIControlStateNormal];
            [btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btnEdit setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
            [btnEdit setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
            [btnEdit.titleLabel setFont:kFont11];
            [buttonImage addTarget:self.mTarget  action:self.mActionClick forControlEvents:UIControlEventTouchUpInside];
            [buttonImage addSubview:btnEdit];
        }
         */
        
        tag++;
        
    }
    /*
    if (imgCount < MaxImgCount) {
        //添加新的产品图片
        cx = imgCount %MaxColumnCount * (columnGap + width);
        cy = imgCount/MaxColumnCount * (lineGap + width);
        UIButton *buttonImage=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage.frame=CGRectMake(px + cx, py + cy, width, width);
        if(cellType == CELL_PRODUCT_IMG){
            [buttonImage setImage:[UIImage imageNamed:@"addStoreImg"] forState:UIControlStateNormal];
        }else{
            [buttonImage setImage:[UIImage imageNamed:@"addItemInStore"] forState:UIControlStateNormal];
        }
        [buttonImage.layer setMasksToBounds:YES];
        [buttonImage.layer setCornerRadius:6.0];
        buttonImage.tag = -1;
        [buttonImage addTarget:self.mTarget  action:self.mActionClick forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:buttonImage];
    }
     */
    CGRect frame = CGRectMake(0, 0, kScreen_Width, py + (width+lineGap) * lineCount + bottomGap);
    uv.frame = frame;

    return uv;
}



@end
