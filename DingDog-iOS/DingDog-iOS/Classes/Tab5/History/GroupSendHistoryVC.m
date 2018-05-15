//
//  GroupSendHistoryVC.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendHistoryVC.h"
#import "MsgGroupHistoryCmd.h"
#import "GroupSendListCell.h"
#import "MsgGroupModel.h"

@interface GroupSendHistoryVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *msgGroupArray;

@end

@implementation GroupSendHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"群发历史";
    
    AppDelegate *app = APP;
    app.rootVC.tabBarHidden = YES;
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.mTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                            fillColor:[UIColor colorWithRGBHex:0x178afb]
                           atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                               [self getGroupHistoryList];
                           }];
    
    [self.mTableView.headRefreshControl beginRefreshing];
    
//    [self getGroupHistoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)msgGroupArray {
    if (!_msgGroupArray) {
        _msgGroupArray = [NSMutableArray array];
    }
    return _msgGroupArray;
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[GroupSendListCell class] forCellReuseIdentifier:GroupSendListCellIdentifier];
        
    }
    return _mTableView;
}

- (void)getGroupHistoryList {
    WS(weakSelf);
    [NetworkAPIManager message_groupHistoryListBlock:^(BaseCmd *cmd, NSError *error) {
        [weakSelf.mTableView.headRefreshControl endRefreshing];
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[MsgGroupHistoryCmd class]]) {
                    MsgGroupHistoryCmd *msgCmd = (MsgGroupHistoryCmd *)cmd;
                    NSLog(@"%@", msgCmd);
                    _msgGroupArray = msgCmd.itemArray;
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
    return _msgGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupSendListCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupSendListCellIdentifier forIndexPath:indexPath];
    
    MsgGroupModel *model = _msgGroupArray[indexPath.row];
    [cell configCellDataWithMsgGroupModel:model];
    
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
    MsgGroupModel *model = _msgGroupArray[indexPath.row];
    [cell configCellDataWithMsgGroupModel:model];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
