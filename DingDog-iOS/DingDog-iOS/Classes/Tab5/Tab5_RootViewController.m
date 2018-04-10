//
//  Tab5_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab5_RootViewController.h"
#import "LoginViewController.h"

@interface Tab5_RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) UIImageView *imgAvatar;

@end

@implementation Tab5_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSceneUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSceneUI {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [UIView new];
        [self.view addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _mTableView.tableHeaderView = [self configHeaderView];
    }
}

- (UIView *)configHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 72)];
        
        _lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, kScreen_Width - 130, 22)];
        _lblUserName.font = kFont20;
        _lblUserName.textColor = [UIColor colorWithHexString:@"0x000000"];
        [_headerView addSubview:_lblUserName];
        
        _imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-20-72, (72 - 48) / 2, 48, 48)];
        _imgAvatar.layer.cornerRadius = 24;
        _imgAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _imgAvatar.clipsToBounds = YES;
        [_headerView addSubview:_imgAvatar];
    }
    
    _lblUserName.text = @"比特币";
    
    _imgAvatar.image = [UIImage imageNamed:@"icon-img-app"];
    
    return _headerView;
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = kFont16;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"使用帮助";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"意见反馈";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"清除缓存";
    } else {
        cell.textLabel.text = @"退出登录";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // 使用帮助
    } else if (indexPath.row == 1) {
        // 意见反馈
    } else if (indexPath.row == 2) {
        // 清除缓存
    } else {
        // 退出登录
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
            // 清除缓存
            [[MyAccountManager sharedManager] logoutAndClearBuffer];
        }];
        
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        HKLoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        // Remove use info after presented to login view.
//        [self presentViewController:loginViewController animated:YES completion:^{
//            [HKUser userLogout];
//        }];
    }
}

@end
