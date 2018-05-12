//
//  TimeLineImageCell.h
//  ZhaoBu
//
//  Created by 耿功发 on 16/9/19.
//  Copyright © 2016年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductImgEditView.h"

extern NSString * const TimeLineImageCellIdentifier;

@interface TimeLineImageCell : UITableViewCell

@property (nonatomic, strong) ProductImgEditView *imgEditView;

-(void)paintWithDefaultPhotoArray:(NSMutableArray*)photoArray;

@end
