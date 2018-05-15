//
//  PreviewViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/11.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "PreviewViewController.h"
#import "GroupSendListViewController.h"

@interface PreviewViewController ()

@property (nonatomic, strong) CreateMessageCmd *createMessageCmd;

@property (nonatomic, strong) LYWebViewController *webVC;

@end

@implementation PreviewViewController

- (instancetype)initWithCreateMessageCmd:(CreateMessageCmd *)cmd {
    self = [super init];
    if (self) {
        _createMessageCmd = cmd;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预览";

    AppDelegate *app = APP;
    app.rootVC.tabBarHidden = YES;
    
    _webVC = [[LYWKWebViewController alloc] initWithAddress:_createMessageCmd.preview_url];
    _webVC.showsToolBar = NO;
    _webVC.showsBackgroundLabel = NO;
    [self addChildViewController:_webVC];
    [self.view addSubview:_webVC.view];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onRightBarButtonClicked:(id)sender {
    
    WS(weakSelf);
    GroupSendListViewController *vc = [[GroupSendListViewController alloc] initWithCreateMessageCmd:_createMessageCmd];
    [vc setOnGronpSendSuccessBlocked:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
