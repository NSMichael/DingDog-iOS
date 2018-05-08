//
//  InTagSelectedViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "InTagSelectedViewController.h"

@interface InTagSelectedViewController ()

@end

@implementation InTagSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Click Events

- (void)onRightBarButtonClicked:(id)sender {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
