//
//  ChangeTagViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "ChangeTagViewController.h"
#import "ChangeUserTagCell.h"
#import "TagListCmd.h"

@interface ChangeTagViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CustomerModel *customerModel;

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@end

@implementation ChangeTagViewController

- (instancetype)initWithModel:(CustomerModel *)model {
    self = [super init];
    if (self) {
        _customerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改标签";
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self initSceneUI];
    [self getCustomerTagList];
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

- (void)initSceneUI {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellEditingStyleNone;
        [self.view addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_mTableView registerClass:[ChangeUserTagCell class] forCellReuseIdentifier:ChangeUserTagCellIdentifier];
        
//        _mTableView.tableHeaderView = [self configHeaderView];
    }
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    
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

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangeUserTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ChangeUserTagCellIdentifier forIndexPath:indexPath];
    [cell configCellDataWithCustomerModel:_customerModel AllTagArray:_tagArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ChangeUserTagCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[ChangeUserTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangeUserTagCellIdentifier];
        }
    });
    [cell configCellDataWithCustomerModel:_customerModel AllTagArray:_tagArray];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
