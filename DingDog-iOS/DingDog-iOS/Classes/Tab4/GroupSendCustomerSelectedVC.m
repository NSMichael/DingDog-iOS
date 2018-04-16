//
//  GroupSendCustomerSelectedVC.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/16.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendCustomerSelectedVC.h"
#import "GroupSendSuccessVC.h"

@interface GroupSendCustomerSelectedVC ()

@end

@implementation GroupSendCustomerSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"群发";
    
    self.rdv_tabBarController.tabBarHidden = YES;
        
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onRightBarButtonClicked:(id)sender {
    GroupSendSuccessVC *vc = [[GroupSendSuccessVC alloc] init];
    [self pushViewController:vc animated:YES];
}

@end
