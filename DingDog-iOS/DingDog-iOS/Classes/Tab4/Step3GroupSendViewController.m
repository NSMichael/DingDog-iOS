//
//  Step3GroupSendViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Step3GroupSendViewController.h"

@interface Step3GroupSendViewController ()

@end

@implementation Step3GroupSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // 用户取消了登录
        AppDelegate *appDelegate = APP;
        appDelegate.rootVC.selectedIndex = 0;
    }];
}

@end
