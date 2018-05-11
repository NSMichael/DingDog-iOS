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

@end

@implementation PreviewViewController

- (instancetype)initWithCreateMessageCmd:(CreateMessageCmd *)cmd {
    self = [super init];
    if (self) {
        _createMessageCmd = cmd;
        
        self.url = cmd.preview_url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rdv_tabBarController.tabBarHidden = YES;
    
//    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onRightBarButtonClicked:(id)sender {
    
    GroupSendListViewController *vc = [[GroupSendListViewController alloc] initWithCreateMessageCmd:_createMessageCmd];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
