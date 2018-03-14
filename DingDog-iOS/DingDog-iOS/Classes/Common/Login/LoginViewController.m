//
//  LoginViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "LoginViewController.h"

#define MAXLENGTH_11    11

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, assign) LoginType loginType;

@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) UIView *uvPhoneNumber;
@property (nonatomic, strong) UILabel *lblPhoneNumber;
@property (nonatomic, strong) UITextField *txtPhoneNumber;

@property (nonatomic, strong) UIView *uvPassword;
@property (nonatomic, strong) UILabel *lblPassword;
@property (nonatomic, strong) UITextField *txtPassword;

@property (nonatomic, strong) UIButton *btnLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    _loginType = LoginType_login;
    
    _imgAvatar = [UIImageView new];
    _imgAvatar.image = [UIImage imageNamed:@"icon-img-app"];
    [self.view addSubview:_imgAvatar];
    [self.imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(37);
        make.size.mas_equalTo(CGSizeMake(96, 96));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    // 手机号
    _uvPhoneNumber = [UIView new];
    [self.view addSubview:_uvPhoneNumber];
    [self.uvPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgAvatar.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    _lblPhoneNumber = [UILabel new];
    _lblPhoneNumber.font = kFont13;
    _lblPhoneNumber.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    _lblPhoneNumber.text = @"手机号";
    [self.uvPhoneNumber addSubview:_lblPhoneNumber];
    [self.lblPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvPhoneNumber);
        make.top.equalTo(self.uvPhoneNumber).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    _txtPhoneNumber = [UITextField new];
    _txtPhoneNumber.delegate = self;
    _txtPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    _txtPhoneNumber.font = kFont14;
    _txtPhoneNumber.placeholder = @"请输入手机号";
    [_txtPhoneNumber addTarget:self action:@selector(textPhoneValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.uvPhoneNumber addSubview:_txtPhoneNumber];
    [self.txtPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblPhoneNumber.mas_right).offset(8);
        make.top.equalTo(self.uvPhoneNumber).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    UIImageView *imgPhoneLine = [UIImageView new];
    imgPhoneLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvPhoneNumber addSubview:imgPhoneLine];
    [imgPhoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblPhoneNumber.mas_bottom).offset(14);
        make.left.and.right.equalTo(self.uvPhoneNumber);
        make.height.mas_offset(0.5);
    }];
    
    // 密码
    _uvPassword = [UIView new];
    [self.view addSubview:_uvPassword];
    [self.uvPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPhoneNumber.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    _lblPassword = [UILabel new];
    _lblPassword.font = kFont13;
    _lblPassword.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    _lblPassword.text = @"密码";
    [self.uvPassword addSubview:_lblPassword];
    [self.lblPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvPassword);
        make.top.equalTo(self.uvPassword).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    _txtPassword = [UITextField new];
    _txtPassword.delegate = self;
    _txtPassword.font = kFont14;
    _txtPassword.placeholder = @"请输入密码";
    [_txtPassword addTarget:self action:@selector(textPasswordValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.uvPassword addSubview:_txtPassword];
    [self.txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblPassword.mas_right).offset(8);
        make.top.equalTo(self.uvPassword).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    UIImageView *imgPasswordLine = [UIImageView new];
    imgPasswordLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvPassword addSubview:imgPasswordLine];
    [imgPasswordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblPassword.mas_bottom).offset(14);
        make.left.and.right.equalTo(self.uvPassword);
        make.height.mas_offset(0.5);
    }];
    
    // 登录按钮
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLogin.titleLabel setFont:kFont14];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    _btnLogin.backgroundColor = [UIColor colorWithHexString:@"0x007AFF"];
    _btnLogin.layer.cornerRadius = 20;
    [self.view addSubview:_btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.top.equalTo(self.uvPassword.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITextField delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textPhoneValueChanged:(id)sender {
    
    NSString *text = self.txtPhoneNumber.text;
    
    if (text.length > MAXLENGTH_11) {
        text = [self.txtPhoneNumber.text substringToIndex:MAXLENGTH_11];
    }
}

- (void)textPasswordValueChanged:(id)sender {
    
    NSString *text = self.txtPhoneNumber.text;
    
    if (text.length > MAXLENGTH_11) {
        text = [self.txtPhoneNumber.text substringToIndex:MAXLENGTH_11];
    }
}

@end
