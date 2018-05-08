//
//  GroupSendListViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/5/7.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendListViewController.h"
#import "WhoCanSeeViewController.h"

@interface GroupSendListViewController ()

@property (nonatomic, strong) UIView *uvTitleView;
@property (nonatomic, strong) UILabel *lblTitleTip;
@property (nonatomic, strong) UILabel *lblTitleCount;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *topView1;
@property (nonatomic, strong) UIButton *btnCanSee;
@property (nonatomic, strong) UIButton *btnCanNotSee;

@property (nonatomic, strong) UIView *topView2;
@property (nonatomic, strong) UILabel *lblInTags;

@property (nonatomic, strong) UIView *topView3;
@property (nonatomic, strong) UILabel *lblEXTags;

@property (nonatomic, strong) UIView *topView4;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation GroupSendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群发";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf3f3f3];
    
    self.rdv_tabBarController.tabBarHidden = YES;
    
    [self setLeftBarWithBtn:@"取消" imageName:@"icon-button-cancel" action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self customerNavigationItemTitleView];
    [self.view addSubview:[self configHeaderView]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)customerNavigationItemTitleView {
    
    _uvTitleView = [UIView new];
    _uvTitleView.frame = CGRectMake(kScreen_Width/3, 0, 120, 44);
    
    _lblTitleTip = [UILabel new];
    _lblTitleTip.font = kFont15;
    _lblTitleTip.text = @"群发";
    _lblTitleTip.textColor = [UIColor blackColor];
    _lblTitleTip.textAlignment = NSTextAlignmentCenter;
    _lblTitleTip.frame = CGRectMake(30, 10, 60, 14);
    [self.uvTitleView addSubview:_lblTitleTip];
    
    _lblTitleCount = [UILabel new];
    _lblTitleCount.font = kFont10;
    _lblTitleCount.textColor = [UIColor colorWithRGB:0x007AFF];
    _lblTitleCount.textAlignment = NSTextAlignmentCenter;
    _lblTitleCount.frame = CGRectMake(30, 26, 60, 14);
    _lblTitleCount.text = @"群发0人";
    [self.uvTitleView addSubview:_lblTitleCount];
    
    self.navigationItem.titleView = self.uvTitleView;
}

- (UIView *)configHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 196)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _topView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 58)];
        [_headerView addSubview:_topView1];
        
        _btnCanSee = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCanSee.frame = CGRectMake(15, 10, (kScreen_Width-45)/2, 38);
        _btnCanSee.layer.cornerRadius = 8;
        [_btnCanSee setTitle:@"谁可以看" forState:UIControlStateNormal];
        [_btnCanSee.titleLabel setFont:kFont14];
        _btnCanSee.backgroundColor = [UIColor colorWithRGB:0x007AFF];
        [_btnCanSee addTarget:self action:@selector(onBtnCanSeeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topView1 addSubview:_btnCanSee];
        
        _btnCanNotSee = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCanNotSee.frame = CGRectMake(30 + (kScreen_Width-45)/2, 10, (kScreen_Width-45)/2, 38);
        _btnCanNotSee.layer.cornerRadius = 8;
        [_btnCanNotSee setTitle:@"不给谁看" forState:UIControlStateNormal];
        [_btnCanNotSee.titleLabel setFont:kFont14];
        _btnCanNotSee.backgroundColor = [UIColor colorWithRGB:0xD0021B];
        [_btnCanNotSee addTarget:self action:@selector(onBtnCanNotSeeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topView1 addSubview:_btnCanNotSee];
        
        UIImageView *imgSeparatorLine1 = [UIImageView new];
        imgSeparatorLine1.frame = CGRectMake(0, 57.5, kScreen_Width, 0.5);
        imgSeparatorLine1.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_topView1 addSubview:imgSeparatorLine1];
        
        _topView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 58, kScreen_Width, 54)];
        [_headerView addSubview:_topView2];
        
        UILabel *lblIn = [UILabel new];
        lblIn.frame = CGRectMake(15, 10, 50, 18);
        lblIn.text = @"IN";
        lblIn.font = kFont16;
        lblIn.textAlignment = NSTextAlignmentCenter;
        [_topView2 addSubview:lblIn];
        
        UILabel *lblInTip = [UILabel new];
        lblInTip.frame = CGRectMake(15, 28, 50, 18);
        lblInTip.text = @"包含条件";
        lblInTip.font = kFont10;
        lblInTip.textAlignment = NSTextAlignmentCenter;
        [_topView2 addSubview:lblInTip];
        
        UIImageView *imgArrowRight1 = [UIImageView new];
        imgArrowRight1.frame = CGRectMake(kScreen_Width-15-9, 19, 9, 16);
        imgArrowRight1.image = [UIImage imageNamed:@"img-arrow-right"];
        [_topView2 addSubview:imgArrowRight1];
        
        _lblInTags = [UILabel new];
        _lblInTags.frame = CGRectMake(80, 17, kScreen_Width-80-35, 20);
        _lblInTags.textAlignment = NSTextAlignmentRight;
        _lblInTags.font = kFont14;
        _lblInTags.text = @"#当月活跃用户 #点击A广告 #当月活跃用户";
        [_topView2 addSubview:_lblInTags];
        
        UIImageView *imgSeparatorLine2 = [UIImageView new];
        imgSeparatorLine2.frame = CGRectMake(0, 53.5, kScreen_Width, 0.5);
        imgSeparatorLine2.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_topView2 addSubview:imgSeparatorLine2];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewINTapped:)];
        [_topView2 addGestureRecognizer:tap1];
        
        _topView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 58+54, kScreen_Width, 54)];
        [_headerView addSubview:_topView3];
        
        UILabel *lblEX = [UILabel new];
        lblEX.frame = CGRectMake(15, 10, 50, 18);
        lblEX.text = @"EX";
        lblEX.font = kFont16;
        lblEX.textAlignment = NSTextAlignmentCenter;
        [_topView3 addSubview:lblEX];
        
        UILabel *lblEXTip = [UILabel new];
        lblEXTip.frame = CGRectMake(15, 28, 50, 18);
        lblEXTip.text = @"删除条件";
        lblEXTip.font = kFont10;
        lblEXTip.textAlignment = NSTextAlignmentCenter;
        [_topView3 addSubview:lblEXTip];
        
        UIImageView *imgArrowRight2 = [UIImageView new];
        imgArrowRight2.frame = CGRectMake(kScreen_Width-15-9, 19, 9, 16);
        imgArrowRight2.image = [UIImage imageNamed:@"img-arrow-right"];
        [_topView3 addSubview:imgArrowRight2];
        
        _lblEXTags = [UILabel new];
        _lblEXTags.frame = CGRectMake(80, 17, kScreen_Width-80-35, 20);
        _lblEXTags.textAlignment = NSTextAlignmentRight;
        _lblEXTags.font = kFont14;
        _lblEXTags.text = @"#当月活跃用户 #点击A广告 #当月活跃用户";
        [_topView3 addSubview:_lblEXTags];
        
        UIImageView *imgSeparatorLine3 = [UIImageView new];
        imgSeparatorLine3.frame = CGRectMake(0, 53.5, kScreen_Width, 0.5);
        imgSeparatorLine3.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_topView3 addSubview:imgSeparatorLine3];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewEXTapped:)];
        [_topView3 addGestureRecognizer:tap2];
        
        _topView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 58+54+54, kScreen_Width, 30)];
        [_headerView addSubview:_topView4];
        
        UILabel *lblResult = [UILabel new];
        lblResult.frame = CGRectMake(15, 5, 100, 20);
        lblResult.textAlignment = NSTextAlignmentLeft;
        lblResult.font = kFont12;
        lblResult.text = @"筛选结果";
        lblResult.textColor = [UIColor colorWithRGB:0x007AFF];
        [_topView4 addSubview:lblResult];
    }
    
    return _headerView;
}

#pragma mark - Click Events

- (void)onLeftBarButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    
}

// 谁可以看
- (void)onBtnCanSeeClicked:(id)sender {
    WhoCanSeeViewController *vc = [[WhoCanSeeViewController alloc] initWithCurrentSelectedArray:_selectedArray];
    [vc setWhoCanSeeBlocked:^(NSMutableArray *selectArr) {
        _selectedArray = selectArr;
        [self showHudTipStr:[NSString stringWithFormat:@"选了%ld个", selectArr.count]];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

// 不给谁看
- (void)onBtnCanNotSeeClicked:(id)sender {
    [self showHudTipStr:@"不给谁看"];
}

- (void)onViewINTapped:(UITapGestureRecognizer *)tapGesture {
    [self showHudTipStr:@"onViewINTapped"];
}

- (void)onViewEXTapped:(UITapGestureRecognizer *)tapGesture {
    [self showHudTipStr:@"onViewEXTapped"];
}

@end
