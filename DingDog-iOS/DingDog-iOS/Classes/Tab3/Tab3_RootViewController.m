//
//  Tab3_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab3_RootViewController.h"
#import "CustomerModel.h"
#import "CustomerListCell.h"
#import "ChineseToPinyin.h"
#import "CustomerListCmd.h"
#import "CustomerDetailViewController.h"

@interface Tab3_RootViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>
{
    NSArray *mAllSectionArray;
    NSArray *mSectionTitles;
    
    NSArray *mAllSectionArraySearch;
    NSArray *mSectionTitlesSearch;
}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *customerArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray  *searchResults;  //搜索结果

@end

@implementation Tab3_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"客户";
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configSearch];

    [self.mTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                            fillColor:[UIColor colorWithRGBHex:0x178afb]
                           atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                               [self getCustomerList];
                           }];
    
    [self.mTableView.headRefreshControl beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomerList) name:kNotification_customerAddTagSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustomerList) name:kNotification_customerInfoUpdategSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)customerArray {
    if (!_customerArray) {
        _customerArray = [NSMutableArray array];
    }
    return _customerArray;
}

- (void)getCustomerList {
    WS(weakSelf);
    [NetworkAPIManager customer_List:^(BaseCmd *cmd, NSError *error) {
        [weakSelf.mTableView.headRefreshControl endRefreshing];
        if (error) {
            [self showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                if ([cmd isKindOfClass:[CustomerListCmd class]]) {
                    CustomerListCmd *customerCmd = (CustomerListCmd *)cmd;
                    _customerArray = [NSMutableArray arrayWithArray:customerCmd.itemArray];
                    [weakSelf generateSectionTitleIndex];
                }
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [self showHudTipStr:msgStr];
                }
            }];
        }
    }];
}

- (void)generateSectionTitleIndex {
    
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    //返回27，是a－z和＃
    NSArray *sectionTitles = [indexCollation sectionTitles];
    
    NSMutableArray *allSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitles.count];
    for (int i = 0; i < sectionTitles.count; i++) {
        NSMutableArray *subSectionArray = [NSMutableArray arrayWithCapacity:100];
        [allSectionsArray addObject:subSectionArray];
    }
    
    if (self.searchController.active) {
        for (CustomerModel *model in _searchResults) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:model.nickname];
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [allSectionsArray objectAtIndex:section];
            [array addObject:model];
        }
    } else {
        for (CustomerModel *model in _customerArray) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:model.nickname];
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [allSectionsArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //过滤掉空的
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    for (NSInteger index = 0; index < [allSectionsArray count]; index++) {
        NSMutableArray *subSectionArray = allSectionsArray[index];
        if ([subSectionArray count] == 0) {
            [deleteIndexSet addIndex:index];
        }
    }
    
    [allSectionsArray removeObjectsAtIndexes:deleteIndexSet];
    NSMutableArray *mTitles = [sectionTitles mutableCopy];
    [mTitles removeObjectsAtIndexes:deleteIndexSet];
    
    if (self.searchController.active) {
        mSectionTitlesSearch = [mTitles copy];
        mAllSectionArraySearch = [allSectionsArray copy];
    } else {
        mSectionTitles = [mTitles copy];
        mAllSectionArray = [allSectionsArray copy];
    }
    [self.mTableView reloadData];
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[CustomerListCell class] forCellReuseIdentifier:CustomerListCellIdentifier];
        
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _mTableView;
}

- (void)configSearch {
    
    //UISearchController
    //创建显示搜索结果控制器
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    
    _searchController.searchBar.placeholder = @"Search";
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 60);
    
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.hidesNavigationBarDuringPresentation = false;
    [_searchController.searchBar sizeToFit];
    
    self.mTableView.tableHeaderView = _searchController.searchBar;
    
    //解决：退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
}

#pragma mark - UITableView data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return mSectionTitlesSearch;
    } else {
        return mSectionTitles;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return [mAllSectionArraySearch count];
    } else {
        return [mAllSectionArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [mAllSectionArraySearch[section] count];
    } else {
        return [mAllSectionArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomerListCellIdentifier forIndexPath:indexPath];
    
    if (self.searchController.active) {
        NSArray *subsections = [mAllSectionArraySearch objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model ShowSelected:NO];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model ShowSelected:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CustomerListCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[CustomerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomerListCellIdentifier];
        }
    });
    if (self.searchController.active) {
        NSArray *subsections = [mAllSectionArraySearch objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model ShowSelected:NO];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model ShowSelected:NO];
    }
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithHexString:@"0xF3F3F3"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 4, 100, 22)];
    label.textColor = [UIColor blackColor];
    
    if (self.searchController.active) {
        [label setText:[mSectionTitlesSearch objectAtIndex:section]];
    } else {
        [label setText:[mSectionTitles objectAtIndex:section]];
    }
    [contentView addSubview:label];
    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchController.active) {
        NSArray *subsections = [mAllSectionArraySearch objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        CustomerDetailViewController *vc = [[CustomerDetailViewController alloc] initWithCustomerModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        CustomerDetailViewController *vc = [[CustomerDetailViewController alloc] initWithCustomerModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"nickname", searchString];
    
    NSArray *newArray = [_customerArray filteredArrayUsingPredicate:pred];
    NSLog(@"newArray:%@", newArray);
    
    // 如果搜索框里有文字，就按谓词的匹配结果初始化结果数组，否则，就用字体列表数组初始化结果数组。
    if (_searchResults != nil && searchString.length > 0) {
        //清除搜索结果
        [_searchResults removeAllObjects];
        _searchResults = [NSMutableArray arrayWithArray:newArray];
    } else if (searchString.length == 0) {
        _searchResults = [NSMutableArray arrayWithArray:_customerArray];
    }
    
    [self generateSectionTitleIndex];
    
    [self.mTableView reloadData];
}

@end
