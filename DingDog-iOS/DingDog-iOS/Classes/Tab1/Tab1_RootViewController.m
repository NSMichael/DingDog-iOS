//
//  Tab1_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab1_RootViewController.h"
#import "MessageListCell.h"

@interface Tab1_RootViewController () //<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ODRefreshControl *mRefreshControl;

@property (nonatomic,strong) UITableView *mTableView;

@end

@implementation Tab1_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
//    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    _mRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.mTableView];
//    [_mRefreshControl addTarget:self action:@selector(getCoinMarketList) forControlEvents:UIControlEventValueChanged];
//    
//    [self getCoinMarketList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getCoinMarketList {
    
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[MessageListCell class] forCellReuseIdentifier:MessageListCellIdentifier];
        
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _mTableView;
}


@end
