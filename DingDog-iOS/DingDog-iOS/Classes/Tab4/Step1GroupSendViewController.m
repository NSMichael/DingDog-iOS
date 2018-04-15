//
//  Step1GroupSendViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Step1GroupSendViewController.h"
#import "Step2GroupSendViewController.h"

@interface Step1GroupSendViewController ()

@end

@implementation Step1GroupSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"群发";
    
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onRightBarButtonClicked:(id)sender {
    Step2GroupSendViewController *vc = [[Step2GroupSendViewController alloc] init];
    [self pushViewController:vc animated:YES];
}

@end
