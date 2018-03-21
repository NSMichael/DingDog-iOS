//
//  Tab2_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab2_RootViewController.h"
#import "TagListCell.h"
#import "TagModel.h"
#import "TagSearchViewController.h"

@interface Tab2_RootViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) ODRefreshControl *mRefreshControl;
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray  *searchResults;  //搜索结果
@property (strong,nonatomic) TagSearchViewController *resultVC; //搜索结果展示控制器

//在新控制器里：
//在获得搜索结果数据时，调用刷新页面的方法
@property (nonatomic,strong) NSArray *results;

@end

@implementation Tab2_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
    
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

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (void)configTestData {
    TagModel *model1 = [TagModel new];
    model1.tagName = @"#City:上海";
    [self.tagArray addObject:model1];
    
    TagModel *model2 = [TagModel new];
    model2.tagName = @"#City:活跃用户";
    [self.tagArray addObject:model2];
    
    TagModel *model3 = [TagModel new];
    model3.tagName = @"#City:北京";
    [self.tagArray addObject:model3];
    
    TagModel *model4 = [TagModel new];
    model4.tagName = @"#Age:40";
    [self.tagArray addObject:model4];
    
    [self.mTableView reloadData];
}

- (void)getCoinMarketList {
    [self.mRefreshControl endRefreshing];
    TagModel *model = [TagModel new];
    model.tagName = @"#City:南京";
    [self.tagArray addObject:model];
    
    [self.mTableView reloadData];
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[TagListCell class] forCellReuseIdentifier:TagListCellIdentifier];
        
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}

- (void)configSearch {
    //UISearchController
    //创建显示搜索结果控制器
    _resultVC = [[TagSearchViewController alloc] init];
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
        return _tagArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TagListCell *cell = [tableView dequeueReusableCellWithIdentifier:TagListCellIdentifier forIndexPath:indexPath];
    
    if (self.searchController.active) {
        TagModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithTagModel:model];
    } else {
        TagModel *model = self.tagArray[indexPath.row];
        [cell configCellDataWithTagModel:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static TagListCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[TagListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TagListCellIdentifier];
        }
    });
    if (self.searchController.active) {
        TagModel *model = self.searchResults[indexPath.row];
        [cell configCellDataWithTagModel:model];
    } else {
        TagModel *model = self.tagArray[indexPath.row];
        [cell configCellDataWithTagModel:model];
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
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"tagName", searchString];
    
    NSArray *newArray = [_tagArray filteredArrayUsingPredicate:pred];
    NSLog(@"newArray:%@", newArray);
    
    // 如果搜索框里有文字，就按谓词的匹配结果初始化结果数组，否则，就用字体列表数组初始化结果数组。
    if (_searchResults != nil && searchString.length > 0) {
        //清除搜索结果
        [_searchResults removeAllObjects];
        _searchResults = [NSMutableArray arrayWithArray:newArray];
    } else if (searchString.length == 0) {
        _searchResults = [NSMutableArray arrayWithArray:_tagArray];
    }
    
    //显示搜索结果
    //在新控制器调用刷新页面的方法
    self.resultVC.results = _searchResults;
}

@end
