//
//  GroupSendSuccessVC.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/16.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendSuccessVC.h"

@interface GroupSendSuccessVC ()

@end

@implementation GroupSendSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onLeftBarButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
