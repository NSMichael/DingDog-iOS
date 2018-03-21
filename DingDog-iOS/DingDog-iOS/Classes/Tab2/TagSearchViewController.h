//
//  TagSearchViewController.h
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "BaseViewController.h"

@interface TagSearchViewController : BaseViewController

//在获得搜索结果数据时，调用刷新页面的方法
@property (nonatomic,strong) NSArray *results;

@end
