//
//  WhoCanNotSeeViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/8.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "WhoCanNotSeeViewController.h"
#import "CustomerModel.h"
#import "CustomerListCell.h"
#import "CustomerListCmd.h"

@interface WhoCanNotSeeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>
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

@property (nonatomic, strong) UIView *uvTitleView;
@property (nonatomic, strong) UILabel *lblTitleAdd;
@property (nonatomic, strong) UILabel *lblTitleCount;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation WhoCanNotSeeViewController

- (instancetype)initWithCurrentSelectedArray:(NSMutableArray *)selectedArray {
    self = [super init];
    if (self) {
        _customerArray = [selectedArray mutableCopy];
        for (int i = 0; i < _customerArray.count; i++) {
            CustomerModel *model = _customerArray[i];
            if (model) {
                model.isSelected = NO;
            }
        }
        _selectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *app = APP;
    app.rootVC.tabBarHidden = YES;
    
    [self setLeftBarWithBtn:@"取消" imageName:@"icon-button-cancel" action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configSearch];
    [self customerNavigationItemTitleView];
    
    [self generateSectionTitleIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)customerNavigationItemTitleView {
    
    _uvTitleView = [UIView new];
    _uvTitleView.frame = CGRectMake(kScreen_Width/3, 0, 120, 44);
    
    _lblTitleAdd = [UILabel new];
    _lblTitleAdd.font = kFont16;
    _lblTitleAdd.text = @"谁不可以看";
    _lblTitleAdd.textColor = [UIColor blackColor];
    _lblTitleAdd.textAlignment = NSTextAlignmentCenter;
    _lblTitleAdd.frame = CGRectMake(30, 10, 90, 14);
    [self.uvTitleView addSubview:_lblTitleAdd];
    
    _lblTitleCount = [UILabel new];
    _lblTitleCount.font = kFont11;
    _lblTitleCount.textColor = [UIColor colorWithRGB:0x007AFF];
    _lblTitleCount.textAlignment = NSTextAlignmentCenter;
    _lblTitleCount.frame = CGRectMake(30, 26, 90, 14);
    _lblTitleCount.text = [NSString stringWithFormat:@"已删除%ld人", _selectedArray.count];
    [self.uvTitleView addSubview:_lblTitleCount];
    
    self.navigationItem.titleView = self.uvTitleView;
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    if (self.selectedArray.count == 0) {
        [self showAlertViewControllerWithText:@"请至少选择1人"];
        return;
    }
    
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.whoCanNotSeeBlocked) {
            for (int i = 0; i < weakSelf.selectedArray.count; i++) {
                CustomerModel *model = weakSelf.selectedArray[i];
                if ([weakSelf.selectedArray containsObject:model]) {
                    [weakSelf.customerArray removeObject:model];
                }
            }
            weakSelf.whoCanNotSeeBlocked(weakSelf.customerArray);
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
        [cell configCellDataWithCustomerModel:model];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model];
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
        [cell configCellDataWithCustomerModel:model];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        [cell configCellDataWithCustomerModel:model];
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
        
        if (model.isSelected) {
            model.isSelected = NO;
            [self.selectedArray removeObject:model];
        } else {
            model.isSelected = YES;
            [self.selectedArray addObject:model];
        }
        
        [self.mTableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    } else {
        NSArray *subsections = [mAllSectionArray objectAtIndex:indexPath.section];
        CustomerModel *model = subsections[indexPath.row];
        
        if (model.isSelected) {
            [self.selectedArray removeObject:model];
            model.isSelected = NO;
        } else {
            model.isSelected = YES;
            [self.selectedArray addObject:model];
        }
        [self.mTableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    }
    
    self.lblTitleCount.text = [NSString stringWithFormat:@"已删除%ld人", _selectedArray.count];
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
