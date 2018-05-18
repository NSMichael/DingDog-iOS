//
//  Tab5_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab5_RootViewController.h"
#import "LoginViewController.h"
#import "SDImageCache.h"
#import "LYWebViewController.h"
#import "LYWKWebViewController.h"
#import "HelpViewController.h"
#import "GroupSendHistoryVC.h"

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
    
    [self.mTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                            fillColor:[UIColor colorWithRGBHex:0x178afb]
                           atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                               [self.mTableView reloadData];
                           }];
    
    //跳转到主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatBindNotification:) name:kNotification_wechatBind object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = NO;
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = kFont16;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
    
    if (indexPath.row == 0) {
        UserCmd *userCmd = [MyAccountManager sharedManager].currentUser;
        if (userCmd) {
            if (userCmd.memberId.length == 0) {
                cell.textLabel.text = @"绑定微信";
            } else if ([userCmd.mobileId isEqualToNumber:@0]) {
                cell.textLabel.text = @"绑定手机号";
            } else {
                cell.textLabel.text = @"群发历史";
            }
        } else {
            cell.textLabel.text = @"绑定手机号";
        }
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"使用帮助";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"意见反馈";
    } else if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = kFont16;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
        cell.textLabel.text = @"清除缓存";
        
        cell.detailTextLabel.font = kFont16;
        cell.detailTextLabel.textColor = kColorTheme;
        
         NSInteger size = [[SDImageCache sharedImageCache] getSize];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M", size/ 1000.0 / 1000];
        
        return cell;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"退出登录";
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = kFont16;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
        cell.textLabel.text = @"当前版本";
        
        cell.detailTextLabel.font = kFont16;
        cell.detailTextLabel.textColor = kColorTheme;
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        // 获取App的版本号
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@", appVersion];
        
        return cell;
    }
    
    [self.mTableView.headRefreshControl endRefreshing];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // 群发历史
        UserCmd *userCmd = [MyAccountManager sharedManager].currentUser;
        if (userCmd) {
            if (userCmd.memberId.length == 0) {
                // 绑定微信
                [self bindWeChat];
            } else if ([userCmd.mobileId isEqualToNumber:@0]) {
                // 绑定手机号
                [self bindMobile];
            } else {
                // 群发历史
                [self gotoSendHistory];
            }
        } else {
            // 绑定手机号
            [self bindMobile];
        }
    } else if (indexPath.row == 1) {
        
        NSString *address = [NSString stringWithFormat:@"http://%@home/site/help", BASE_URL];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        request.URL = [NSURL URLWithString:address];
        
        HelpViewController *vc = [[HelpViewController alloc] initWithURLRequest:request Title:@"帮助"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 2) {
        // 意见反馈
        NSString *address = [NSString stringWithFormat:@"http://%@home/site/support", BASE_URL];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        request.URL = [NSURL URLWithString:address];
        
        HelpViewController *vc = [[HelpViewController alloc] initWithURLRequest:request Title:@"反馈"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 3) {
        // 清除缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [self.mTableView reloadData];
        [self showAlertViewControllerWithText:@"缓存清除成功"];
        
    } else if (indexPath.row == 4) {
        // 清当前版本
    }else {
        // 退出登录
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
            // 清除缓存
            [[MyAccountManager sharedManager] logoutAndClearBuffer];
        }];
    }
}

// 群发历史
- (void)gotoSendHistory {
    GroupSendHistoryVC *vc = [[GroupSendHistoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 绑定微信
- (void)bindWeChat {
    [self onWXTapped];
}

// 绑定手机号
- (void)bindMobile {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginType:LoginType_bind];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - 第三方登录

- (void)onWXTapped {
    
    AppDelegate *app = APP;
    app.weChatType = WeChatType_Bind;
    
    NSLog(@"%s",__func__);
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)wechatBindNotification:(NSNotification *)notification {
    NSString *code = [notification.userInfo objectForKey:@"code"];
    [self getWechatAccessTokenWithCode:code];
}

- (void)getWechatAccessTokenWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    kAPPSTORE_WECHAT_APPID, kAPPSTORE_WECHAT_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
            }
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *unionid = [dic objectForKey:@"unionid"];
                [self loginByWeChatWithOpenId:openId UnionId:unionid];
            }
        });
        
    });
}

- (void)loginByWeChatWithOpenId:(NSString *)openId UnionId:(NSString *)unionId {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:openId forKey:@"openid"];
    [params setObject:unionId forKey:@"unionid"];
    
    WS(weakSelf);
    [NetworkAPIManager bind_weChatWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                [weakSelf showHudTipStr:@"绑定成功"];
                [weakSelf getProfile];
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [APP setupTabViewController];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }
    }];
}

- (void)getProfile {
    WS(weakSelf);
    [NetworkAPIManager get_myProfileInfoWithParams:nil andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[UserCmd class]]) {
                    UserCmd *userCmd = (UserCmd *)cmd;
                    NSLog(@"%@", userCmd);
                    
                    if (userCmd.token.length > 0) {
                        [[MyAccountManager sharedManager] saveToken:userCmd.token];
                    }
                    
                    [[MyAccountManager sharedManager] saveUserProfile:userCmd];
                    [[AppManager GetInstance] onLoginSuccess];//执行系统级的登录任务
                    
                    [APP setupTabViewController];
                }
            } failed:^(NSInteger errCode) {
                
            }];
        }
    }];
}

@end
