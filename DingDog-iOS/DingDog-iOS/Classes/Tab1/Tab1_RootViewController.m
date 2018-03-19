//
//  Tab1_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab1_RootViewController.h"
#import "MessageListCell.h"
#import "MessageModel.h"

@interface Tab1_RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ODRefreshControl *mRefreshControl;

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation Tab1_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _mRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.mTableView];
    [_mRefreshControl addTarget:self action:@selector(getCoinMarketList) forControlEvents:UIControlEventValueChanged];
    
    [self configTestData];

//    [self getCoinMarketList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)configTestData {
    MessageModel *model1 = [MessageModel new];
    model1.name = @"订阅号";
    model1.time = @"两小时前";
    model1.content = @"今日头条：中国移动进入英国市场；迪士尼..";
    [self.messageArray addObject:model1];
    
    MessageModel *model2 = [MessageModel new];
    model2.name = @"王萍";
    model2.time = @"昨天";
    model2.content = @"您可以到我们的网站上注册购买";
    [self.messageArray addObject:model2];
    
    MessageModel *model3 = [MessageModel new];
    model3.name = @"刘月";
    model3.time = @"两小时前";
    model3.content = @"嗯嗯好的";
    [self.messageArray addObject:model3];
    
    MessageModel *model4 = [MessageModel new];
    model4.name = @"赵平民";
    model4.time = @"08:32";
    model4.content = @"在？";
    [self.messageArray addObject:model4];
    
    [self.mTableView reloadData];
}

- (void)getCoinMarketList {
    [self.mRefreshControl endRefreshing];
    MessageModel *model = [MessageModel new];
    model.name = @"李建国";
    model.time = @"18:22";
    model.content = @"业务办理的最后期限是什么时候？";
    [self.messageArray addObject:model];
    
    [self.mTableView reloadData];
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

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListCellIdentifier forIndexPath:indexPath];
    
    MessageModel *model = self.messageArray[indexPath.row];
    [cell configCellDataWithMessageModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static MessageListCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageListCellIdentifier];
        }
    });
    MessageModel *model = self.messageArray[indexPath.row];
    [cell configCellDataWithMessageModel:model];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
