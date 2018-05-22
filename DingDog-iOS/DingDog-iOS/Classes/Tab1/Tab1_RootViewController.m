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
#import "MsgSearchViewController.h"

@interface Tab1_RootViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray  *searchResults;  //搜索结果
@property (strong,nonatomic) MsgSearchViewController *resultVC; //搜索结果展示控制器

@end

@implementation Tab1_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"111");
    
    self.title = @"消息";
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configTestData];
    [self configSearch];
    
    [self.mTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                           fillColor:[UIColor colorWithRGBHex:0x178afb]
                          atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                              [self getCoinMarketList];
                          }];
    
    [self.mTableView.headRefreshControl beginRefreshing];
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
    [self.mTableView.headRefreshControl endRefreshing];
    MessageModel *model = [MessageModel new];
    model.name = @"李建国";
    model.time = @"18:22";
    model.content = @"业务办理的最后期限是什么时候？";
    [self.messageArray insertObject:model atIndex:0];
    
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

- (void)configSearch {
    //UISearchController
    //创建显示搜索结果控制器
    _resultVC = [[MsgSearchViewController alloc] init];
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
        return _messageArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListCellIdentifier forIndexPath:indexPath];
    
    if (self.searchController.active) {
        MessageModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithMessageModel:model];
    } else {
        MessageModel *model = self.messageArray[indexPath.row];
        [cell configCellDataWithMessageModel:model];
    }
    
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
    if (self.searchController.active) {
        MessageModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithMessageModel:model];
    } else {
        MessageModel *model = self.messageArray[indexPath.row];
        [cell configCellDataWithMessageModel:model];
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
    
    NSArray *newArray = [_messageArray filteredArrayUsingPredicate:pred];
    NSLog(@"newArray:%@", newArray);
    
    // 如果搜索框里有文字，就按谓词的匹配结果初始化结果数组，否则，就用字体列表数组初始化结果数组。
    if (_searchResults != nil && searchString.length > 0) {
        //清除搜索结果
        [_searchResults removeAllObjects];
        _searchResults = [NSMutableArray arrayWithArray:newArray];
    } else if (searchString.length == 0) {
        _searchResults = [NSMutableArray arrayWithArray:_messageArray];
    }
    
    //显示搜索结果
    //在新控制器调用刷新页面的方法
    self.resultVC.results = _searchResults;
}

@end
