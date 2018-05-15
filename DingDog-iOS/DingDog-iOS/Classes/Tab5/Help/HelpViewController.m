//
//  HelpViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/15.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "HelpViewController.h"
#import "LYWebViewController.h"
#import "LYWKWebViewController.h"

@interface HelpViewController ()

@property (nonatomic, strong) LYWebViewController *webVC;

@end

@implementation HelpViewController

- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest Title:(NSString *)title {
    self = [super init];
    if (self) {
        
        self.rdv_tabBarController.tabBarHidden = YES;
        
//        self.rdv_tabBarController.tabBar.hidden = YES;
        
        self.title = title;
        
        _webVC = [[LYWKWebViewController alloc] initWithRequest:urlRequest];
        _webVC.showsToolBar = NO;
        _webVC.showsBackgroundLabel = NO;
        [self addChildViewController:_webVC];
        [self.view addSubview:_webVC.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.rdv_tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
