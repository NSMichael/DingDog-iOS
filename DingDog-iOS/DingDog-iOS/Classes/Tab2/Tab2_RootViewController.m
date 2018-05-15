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
#import "TagListCmd.h"
#import "TagCustomerSelectedVC.h"
#import "TagCustomerListViewControlller.h"

@interface Tab2_RootViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray  *searchResults;  //搜索结果

@end

@implementation Tab2_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
    
    [self setRightBarWithBtn:@"新建" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self configSearch];
    
    [self.mTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                            fillColor:[UIColor colorWithRGBHex:0x178afb]
                           atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                               [self getCustomerTagList];
                           }];
    
    [self.mTableView.headRefreshControl beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTagSuccess) name:kNotification_createTagSuccess object:nil];
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

- (void)createTagSuccess {
    [self getCustomerTagList];
}

#pragma mark - click event

- (void)onRightBarButtonClicked:(id)sender {
    TagCustomerSelectedVC *vc = [[TagCustomerSelectedVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network

- (void)getCustomerTagList {
    WS(weakSelf);
    [NetworkAPIManager customer_tagList:^(BaseCmd *cmd, NSError *error) {
        [weakSelf.mTableView.headRefreshControl endRefreshing];
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                if ([cmd isKindOfClass:[TagListCmd class]]) {
                    TagListCmd *tagCmd = (TagListCmd *)cmd;
                    _tagArray = [NSMutableArray arrayWithArray:tagCmd.itemArray];
                    [weakSelf.mTableView reloadData];
                }
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
}

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
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
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.hidesNavigationBarDuringPresentation = false;
    [_searchController.searchBar sizeToFit];
    
    _searchController.searchBar.placeholder = @"Search";
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 60);
    self.mTableView.tableHeaderView = _searchController.searchBar;
    
    //解决：退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
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
    
    if (self.searchController.active) {
        TagModel *model = self.searchResults[indexPath.row];
        TagCustomerListViewControlller *vc = [[TagCustomerListViewControlller alloc] initWithTagModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TagModel *model = self.tagArray[indexPath.row];
        TagCustomerListViewControlller *vc = [[TagCustomerListViewControlller alloc] initWithTagModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakself);
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定解散该标签？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            TagModel *model = weakself.tagArray[indexPath.row];
            
            [NetworkAPIManager customer_tagRemoveWithParams:@{@"tagid":model.tagId} andBlock:^(BaseCmd *cmd, NSError *error) {
                if (error) {
                    [self showHudTipStr:TIP_NETWORKERROR];
                } else {
                    [cmd errorCheckSuccess:^{
                        
                        NSString *msgStr = cmd.message;
                        [self showHudTipStr:msgStr];
                        
                        [weakself.tagArray removeObject:model];
                        [weakself.mTableView reloadData];
                        
                    } failed:^(NSInteger errCode) {
                        if (errCode == 0) {
                            NSString *msgStr = cmd.message;
                            [self showHudTipStr:msgStr];
                        }
                    }];
                }
            }];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//修改编辑按钮文字

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解散标签";
}

//设置进入编辑状态时，Cell不会缩进

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    
    [self.mTableView reloadData];
    
    //显示搜索结果
    //在新控制器调用刷新页面的方法
//    self.resultVC.results = _searchResults;
}

@end
