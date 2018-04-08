//
//  Tab4_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab4_RootViewController.h"
#import "GroupSendListCell.h"
#import "GroupSendModel.h"
#import "GroupSendSearchViewController.h"

@interface Tab4_RootViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) ODRefreshControl *mRefreshControl;
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *groupSendArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray  *searchResults;  //搜索结果
@property (strong,nonatomic) GroupSendSearchViewController *resultVC; //搜索结果展示控制器

@end

@implementation Tab4_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群发";
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _mRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.mTableView];
    [_mRefreshControl addTarget:self action:@selector(getCoinMarketList) forControlEvents:UIControlEventValueChanged];
    
    [self configTestData];
    [self configSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)groupSendArray {
    if (!_groupSendArray) {
        _groupSendArray = [NSMutableArray array];
    }
    return _groupSendArray;
}

- (void)configTestData {
    GroupSendModel *model1 = [GroupSendModel new];
    model1.name = @"WAX已加入Bancor (BNT)生态系统";
    model1.content = @"WAX已加入Bancor (BNT)生态系统。持有WAX的用户可以通过Bancor生态系统，用WAX和系统里的其他60多个币种进行兑换。【消息来源:biknow.com】";
    model1.time = @"2018-04-08 08:32:21";
    [self.groupSendArray addObject:model1];
    
    GroupSendModel *model2 = [GroupSendModel new];
    model2.name = @"摩根大通区块链高管Amber Baldet将离职进行创业";
    model2.content = @"据路透社报道，摩根大通区块链高管Amber Baldet将离职进行创业。Baldet为业界知名人物，曾负责摩根大通区块链项目Quorum的产品开发和区块链战略，在Coindesk2017年度最有影响力100人中排名第四。【消息来源:biknow.com】";
    model1.time = @"2018-04-04 15:32:21";
    [self.groupSendArray addObject:model2];
    
    GroupSendModel *model3 = [GroupSendModel new];
    model3.name = @"2018年度十大区块链技术解决方案提供商";
    model3.content = @"唯链（VEN）CEO 近日荣登美国APAC CIO OUTLOOK杂志2018年4月区块链专刊封面，同时被其评为 “2018年度十大区块链技术解决方案提供商”。 【消息来源:biknow.com】";
    model3.time = @"2018-03-16 16:32:21";
    [self.groupSendArray addObject:model3];
    
    GroupSendModel *model4 = [GroupSendModel new];
    model4.name = @"Rivetz (RVT)已加入Bancor (BNT)生态系统";
    model4.content = @"Rivetz (RVT)已加入Bancor (BNT)生态系统。持有RVT的用户可以通过Bancor生态系统，用RVT和系统里的其他60多个币种进行兑换。【消息来源:biknow.com】";
    model4.time = @"2018-03-14 10:32:25";
    [self.groupSendArray addObject:model4];
    
    [self.mTableView reloadData];
}

- (void)getCoinMarketList {
    [self.mRefreshControl endRefreshing];
    GroupSendModel *model = [GroupSendModel new];
    model.name = @"(TNB)将空投100万个TNB币";
    model.content = @"Time New Bank (TNB)将空投100万个TNB币，目前有10002个参与名额。";
    model.time = @"2018-03-08 06:32:21";
    [self.groupSendArray addObject:model];
    
    [self.mTableView reloadData];
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[GroupSendListCell class] forCellReuseIdentifier:GroupSendListCellIdentifier];
        
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}

- (void)configSearch {
    //UISearchController
    //创建显示搜索结果控制器
    _resultVC = [[GroupSendSearchViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    
    _searchController.searchBar.placeholder = @"Search";
    _searchController.hidesNavigationBarDuringPresentation = YES; //搜索时隐藏导航栏
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 60);
    self.mTableView.tableHeaderView = _searchController.searchBar;
    
    //解决：退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchResults.count;
    }else {
        return self.groupSendArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupSendListCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupSendListCellIdentifier forIndexPath:indexPath];
    
    if (self.searchController.active) {
        GroupSendModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithGroupSendModel:model];
    } else {
        GroupSendModel *model = self.groupSendArray[indexPath.row];
        [cell configCellDataWithGroupSendModel:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static GroupSendListCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[GroupSendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupSendListCellIdentifier];
        }
    });
    if (self.searchController.active) {
        GroupSendModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithGroupSendModel:model];
    } else {
        GroupSendModel *model = self.groupSendArray[indexPath.row];
        [cell configCellDataWithGroupSendModel:model];
    }
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark UISearchResultsUpdating
// 每次更新搜索框里的文字，就会调用这个方法
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
// 根据输入的关键词及时响应：里面可以实现筛选逻辑  也显示可以联想词
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
    
    //会自动显示新控制器的view 来展示搜索结果
    
    //获取搜索框里地字符串
    NSString *searchString = searchController.searchBar.text;
    
    // 谓词
    /**
     1.BEGINSWITH ： 搜索结果的字符串是以搜索框里的字符开头的
     2.ENDSWITH   ： 搜索结果的字符串是以搜索框里的字符结尾的
     3.CONTAINS   ： 搜索结果的字符串包含搜索框里的字符
     
     [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
     
     */
    
    // 创建谓词
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [CD] %@", searchString];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"name", searchString];
    
    NSArray *newArray = [_groupSendArray filteredArrayUsingPredicate:pred];
    NSLog(@"newArray:%@", newArray);
    
    // 如果搜索框里有文字，就按谓词的匹配结果初始化结果数组，否则，就用字体列表数组初始化结果数组。
    if (_searchResults != nil && searchString.length > 0) {
        //清除搜索结果
        [_searchResults removeAllObjects];
        _searchResults = [NSMutableArray arrayWithArray:newArray];
    } else if (searchString.length == 0) {
        _searchResults = [NSMutableArray arrayWithArray:_groupSendArray];
    }
    
    //显示搜索结果
    //在新控制器调用刷新页面的方法
    self.resultVC.results = _searchResults;
}

@end
