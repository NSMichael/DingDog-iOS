//
//  HelpViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/15.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@property (nonatomic, strong) LYWebViewController *webVC;

@end

@implementation HelpViewController

- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest Title:(NSString *)title {
    self = [super init];
    if (self) {
        
        AppDelegate *app = APP;
        app.rootVC.tabBarHidden = YES;
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
