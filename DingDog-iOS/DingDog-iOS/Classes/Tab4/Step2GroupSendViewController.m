//
//  Step2GroupSendViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Step2GroupSendViewController.h"
#import "Step3GroupSendViewController.h"

@interface Step2GroupSendViewController ()

@end

@implementation Step2GroupSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群发";
    
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onRightBarButtonClicked:(id)sender {
    Step3GroupSendViewController *vc = [[Step3GroupSendViewController alloc] init];
    [self pushViewController:vc animated:YES];
}
@end
