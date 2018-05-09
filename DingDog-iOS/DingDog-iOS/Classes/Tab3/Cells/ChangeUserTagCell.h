//
//  ChangeUserTagCell.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"
#import "TTGTextTagCollectionView.h"

extern NSString * const ChangeUserTagCellIdentifier;

@interface ChangeUserTagCell : UITableViewCell

@property (nonatomic, strong) TTGTextTagCollectionView *tagView;

- (void)configCellDataWithCustomerModel:(CustomerModel *)model AllTagArray:(NSArray *)allTagArray;

- (void)configCellDataWithAllTagArray:(NSArray *)allTagArray SelectedTagArray:(NSArray *)selectedArray;

@end
