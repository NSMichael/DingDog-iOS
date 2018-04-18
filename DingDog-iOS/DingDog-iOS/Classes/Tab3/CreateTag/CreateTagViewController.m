//
//  CreateTagViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CreateTagViewController.h"

@interface CreateTagViewController ()

@end

@implementation CreateTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新建";
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onRightBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_createTagSuccess object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
