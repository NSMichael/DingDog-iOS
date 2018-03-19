//
//  LoginViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "LoginViewController.h"
#import "RootTabViewController.h"
#import "AppDelegate.h"

#define MAXLENGTH_11    11

@interface LoginViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, assign) LoginType loginType;

@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) UIView *uvPhoneNumber;
@property (nonatomic, strong) UILabel *lblPhoneNumber;
@property (nonatomic, strong) UITextField *txtPhoneNumber;

@property (nonatomic, strong) UIView *uvPassword;
@property (nonatomic, strong) UILabel *lblPassword;
@property (nonatomic, strong) UITextField *txtPassword;

@property (nonatomic, strong) UIButton *btnVerCode;

@property (nonatomic, strong) UIButton *btnLogin;

@property (nonatomic, strong) TTTAttributedLabel *attrLabel;

@property (nonatomic, strong) UIView *uvSNS;
@property (nonatomic, strong) UIView *uvWeChat;

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
//        make.top.equalTo(self.uvPhoneNumber).offset(8);
        make.centerY.mas_equalTo(self.uvPhoneNumber.mas_centerY);
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
//        make.top.equalTo(self.uvPhoneNumber).offset(8);
        make.centerY.mas_equalTo(self.uvPhoneNumber.mas_centerY);
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
        make.top.equalTo(self.uvPhoneNumber.mas_bottom).offset(14);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    _lblPassword = [UILabel new];
    _lblPassword.font = kFont13;
    _lblPassword.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    _lblPassword.text = @"密 码";
    [self.uvPassword addSubview:_lblPassword];
    [self.lblPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvPassword);
        make.centerY.mas_equalTo(self.uvPassword.mas_centerY);
        make.height.mas_equalTo(18);
    }];
    
    _txtPassword = [UITextField new];
    _txtPassword.delegate = self;
    _txtPassword.font = kFont14;
    _txtPassword.placeholder = @"请输入密码";
    [_txtPassword addTarget:self action:@selector(textPasswordValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.uvPassword addSubview:_txtPassword];
    [self.txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txtPhoneNumber.mas_left);
        make.centerY.mas_equalTo(self.uvPassword.mas_centerY);
        make.height.mas_equalTo(18);
    }];
    
    _btnVerCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnVerCode.titleLabel setFont:kFont14];
    [_btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnVerCode setTitleColor:[UIColor colorWithHexString:@"0x007AFF"] forState:UIControlStateNormal];
    [self.uvPassword addSubview:_btnVerCode];
    [self.btnVerCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.uvPassword.mas_right).offset(-13);
        make.centerY.mas_equalTo(self.uvPassword.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
    _btnVerCode.hidden = YES;
    
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
    [_btnLogin addTarget:self action:@selector(onBtnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.top.equalTo(self.uvPassword.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    NSString *strTips = @"还没有账号？现在注册";
    _attrLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _attrLabel.font = [UIFont systemFontOfSize:14];
    _attrLabel.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    [self.view addSubview:_attrLabel];
    _attrLabel.text = strTips;
    _attrLabel.delegate = self;
    _attrLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [_attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnLogin.mas_bottom).offset(17);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    //设置需要点击的文字的颜色大小
    [_attrLabel setText:strTips afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //得到需要点击的文字的位置
        NSRange selRange=[strTips rangeOfString:@"现在注册"];
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"0x007AFF"] CGColor] range:selRange];
        return mutableAttributedString;
    }];
    
    //给  强者通常平静如水   添加点击事件
    NSRange selRange = [strTips rangeOfString:@"现在注册"];
    [_attrLabel addLinkToTransitInformation:@{@"actionStr":@"现在注册"} withRange:selRange];
    
    _uvSNS = [UIView new];
    [self.view addSubview:_uvSNS];
    [self.uvSNS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(38.5);
        make.right.equalTo(self.view).offset(-38.5);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(self.view).offset(-80);
    }];
    
    UILabel *lblSNSTip = [UILabel new];
    lblSNSTip.font = [UIFont systemFontOfSize:12];
    lblSNSTip.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    lblSNSTip.backgroundColor = [UIColor whiteColor];
    lblSNSTip.textAlignment = NSTextAlignmentCenter;
    lblSNSTip.text = @"你也可以使用社交账户登录";
    [self.uvSNS addSubview:lblSNSTip];
    [lblSNSTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.uvSNS.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 17));
        make.top.equalTo(self.uvSNS).offset(0);
    }];
    
    UIImageView *imgSNSLineLeft = [UIImageView new];
    imgSNSLineLeft.backgroundColor = [UIColor colorWithHexString:@"0xC7C7CC"];
    [self.uvSNS addSubview:imgSNSLineLeft];
    [imgSNSLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvSNS).offset(0);
        make.right.equalTo(lblSNSTip.mas_left).offset(-16.5);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(lblSNSTip.mas_centerY);
    }];
    
    UIImageView *imgSNSLineRight = [UIImageView new];
    imgSNSLineRight.backgroundColor = [UIColor colorWithHexString:@"0xC7C7CC"];
    [self.uvSNS addSubview:imgSNSLineRight];
    [imgSNSLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblSNSTip.mas_right).offset(16.5);
        make.right.equalTo(self.uvSNS).offset(0);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(lblSNSTip.mas_centerY);
    }];
    
    _uvWeChat = [UIView new];
    _uvWeChat.layer.cornerRadius = 20;
    _uvWeChat.layer.masksToBounds = YES;
    _uvWeChat.layer.borderWidth = 0.5;
    _uvWeChat.layer.borderColor = [UIColor colorWithHexString:@"0x979797"].CGColor;
    [self.uvSNS addSubview:_uvWeChat];
    [self.uvWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblSNSTip.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.uvSNS.mas_centerX);
    }];
    
    UIImageView *imgWeChat = [UIImageView new];
    imgWeChat.image = [UIImage imageNamed:@"wechat moment O"];
    [self.uvWeChat addSubview:imgWeChat];
    [imgWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.equalTo(self.uvWeChat).offset(4);
        make.centerY.mas_equalTo(self.uvWeChat.mas_centerY);
    }];
    
    UILabel *lblWeChat = [UILabel new];
    lblWeChat.font = [UIFont systemFontOfSize:14];
    lblWeChat.textColor = [UIColor colorWithHexString:@"0x454553"];
    lblWeChat.backgroundColor = [UIColor whiteColor];
    lblWeChat.textAlignment = NSTextAlignmentCenter;
    lblWeChat.text = @"微信登录";
    [self.uvWeChat addSubview:lblWeChat];
    [lblWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.uvWeChat.mas_centerX);
        make.centerY.mas_equalTo(self.uvWeChat.mas_centerY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onBtnLoginClicked {
    AppDelegate *app = APP;
//    [app jpushConfigInitAndLogin];
    
    [APP setupTabViewController];
}

#pragma mark 文字的点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSLog(@"didSelectLinkWithTransitInformation :%@",components);
    
    if ([[components objectForKey:@"actionStr"] isEqualToString:@"现在注册"]) {
        [self setupRegister];
    } else {
        [self setupLogin];
    }
}

- (void)setupLogin {
    NSString *strTips = @"还没有账号？现在注册";
    _attrLabel.text = strTips;
    
    //设置需要点击的文字的颜色大小
    [_attrLabel setText:strTips afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //得到需要点击的文字的位置
        NSRange selRange=[strTips rangeOfString:@"现在注册"];
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"0x007AFF"] CGColor] range:selRange];
        return mutableAttributedString;
    }];
    
    // 添加点击事件
    NSRange selRange = [strTips rangeOfString:@"现在注册"];
    [_attrLabel addLinkToTransitInformation:@{@"actionStr":@"现在注册"} withRange:selRange];
    
    self.title = @"登录";
    
    _btnVerCode.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _uvSNS.alpha = 1;
    }];
}

- (void)setupRegister {
    
    NSString *strTips = @"已有账号？现在登录";
    _attrLabel.text = strTips;
    
    //设置需要点击的文字的颜色大小
    [_attrLabel setText:strTips afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //得到需要点击的文字的位置
        NSRange selRange=[strTips rangeOfString:@"现在登录"];
        //设置可点击文本的颜色
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"0x007AFF"] CGColor] range:selRange];
        return mutableAttributedString;
    }];
    
    //给  强者通常平静如水   添加点击事件
    NSRange selRange = [strTips rangeOfString:@"现在登录"];
    [_attrLabel addLinkToTransitInformation:@{@"actionStr":@"现在登录"} withRange:selRange];
    
    self.title = @"注册";
    
    _btnVerCode.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _uvSNS.alpha = 0;
    }];
    
//    _uvSNS.hidden = YES;
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
