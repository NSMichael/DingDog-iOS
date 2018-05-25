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
#import "GetCaptchaCmd.h"
#import "UserCmd.h"
#import "RCloudTokenModel.h"

#define MAXLENGTH_11    11

@interface LoginViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, assign) LoginType loginType;

@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) UIView *uvPhoneNumber;
@property (nonatomic, strong) UILabel *lblPhoneNumber;
@property (nonatomic, strong) UITextField *txtPhoneNumber;

@property (nonatomic, strong) UIImageView *imgPictureCodeLine;
@property (nonatomic, strong) UIView *uvPictureCode;
@property (nonatomic, strong) UILabel *lblPictureCode;
@property (nonatomic, strong) UITextField *txtPictureCode;
@property (nonatomic, strong) UIImageView *imgPictureCode;

@property (nonatomic, strong) UIImageView *imgPasswordLine;
@property (nonatomic, strong) UIView *uvPassword;
@property (nonatomic, strong) UILabel *lblPassword;
@property (nonatomic, strong) UITextField *txtPassword;

@property (nonatomic, strong) UIButton *btnVerCode;

@property (nonatomic, strong) UIButton *btnLogin;

@property (nonatomic, strong) TTTAttributedLabel *attrLabel;

@property (nonatomic, strong) UIView *uvSNS;
@property (nonatomic, strong) UIView *uvWeChat;

@property (nonatomic, strong) NSString *mobileStr, *passwordStr, *pictureCode;
@property (nonatomic, assign) NSInteger refreshCount;

@end

@implementation LoginViewController

- (instancetype)initWithLoginType:(LoginType)type {
    self = [super init];
    if (self) {
        _loginType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshCount = 1;
    
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
        make.centerY.mas_equalTo(self.uvPhoneNumber.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];
    
    _txtPhoneNumber = [UITextField new];
    _txtPhoneNumber.delegate = self;
    _txtPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    _txtPhoneNumber.font = kFont13;
    _txtPhoneNumber.placeholder = @"请输入手机号";
    _txtPhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtPhoneNumber.textAlignment = NSTextAlignmentLeft;
    [_txtPhoneNumber addTarget:self action:@selector(textPhoneValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uvPhoneNumber addSubview:_txtPhoneNumber];
    [self.txtPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPhoneNumber);
        make.left.equalTo(self.lblPhoneNumber.mas_right).offset(8);
        make.right.equalTo(self.uvPhoneNumber.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *imgPhoneLine = [UIImageView new];
    imgPhoneLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvPhoneNumber addSubview:imgPhoneLine];
    [imgPhoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblPhoneNumber.mas_bottom).offset(14);
        make.left.and.right.equalTo(self.uvPhoneNumber);
        make.height.mas_offset(0.5);
    }];
    
    // 图形验证码
    _uvPictureCode = [UIView new];
    [self.view addSubview:_uvPictureCode];
    [self.uvPictureCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPhoneNumber.mas_bottom).offset(14);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    _lblPictureCode = [UILabel new];
    _lblPictureCode.font = kFont13;
    _lblPictureCode.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
    _lblPictureCode.text = @"图形码";
    [self.uvPictureCode addSubview:_lblPictureCode];
    [self.lblPictureCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvPictureCode);
        make.centerY.mas_equalTo(self.uvPictureCode.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];
    
    _txtPictureCode = [UITextField new];
    _txtPictureCode.delegate = self;
    _txtPictureCode.font = kFont13;
    _txtPictureCode.placeholder = @"请输入图形验证码";
    _txtPictureCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtPictureCode.textAlignment = NSTextAlignmentLeft;
    [_txtPictureCode addTarget:self action:@selector(textPictureCodeValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uvPictureCode addSubview:_txtPictureCode];
    [self.txtPictureCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPictureCode);
        make.left.equalTo(self.lblPictureCode.mas_right).offset(8);
        make.right.equalTo(self.uvPictureCode.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    _imgPictureCode = [UIImageView new];
    [self.uvPictureCode addSubview:_imgPictureCode];
    [self.imgPictureCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.uvPictureCode.mas_centerY);
        make.right.equalTo(self.uvPictureCode.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];
    
    _imgPictureCodeLine = [UIImageView new];
    _imgPictureCodeLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvPictureCode addSubview:_imgPictureCodeLine];
    [self.imgPictureCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblPictureCode.mas_bottom).offset(14);
        make.left.and.right.equalTo(self.uvPictureCode);
        make.height.mas_offset(0.5);
    }];
    
    UITapGestureRecognizer *tapPicCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPictureCodeTapped)];
    [self.uvPictureCode addGestureRecognizer:tapPicCode];
    
    _uvPictureCode.hidden = YES;
    
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
    _lblPassword.text = @"验证码";
    [self.uvPassword addSubview:_lblPassword];
    [self.lblPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uvPassword);
        make.centerY.mas_equalTo(self.uvPassword.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];
    
    _txtPassword = [UITextField new];
    _txtPassword.delegate = self;
    _txtPassword.font = kFont13;
    _txtPassword.placeholder = @"请输入验证码";
    _txtPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtPassword.textAlignment = NSTextAlignmentLeft;
    [_txtPassword addTarget:self action:@selector(textPasswordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uvPassword addSubview:_txtPassword];
    [self.txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPassword);
        make.left.equalTo(self.lblPassword.mas_right).offset(8);
        make.right.equalTo(self.uvPassword.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    _btnVerCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnVerCode.titleLabel setFont:kFont14];
    [_btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnVerCode setTitleColor:[UIColor colorWithHexString:@"0x007AFF"] forState:UIControlStateNormal];
    [_btnVerCode addTarget:self action:@selector(onBtnVerCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.uvPassword addSubview:_btnVerCode];
    [self.btnVerCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.uvPassword.mas_right).offset(-13);
        make.centerY.mas_equalTo(self.uvPassword.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
//    _btnVerCode.hidden = YES;
    
    _imgPasswordLine = [UIImageView new];
    _imgPasswordLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvPassword addSubview:_imgPasswordLine];
    [self.imgPasswordLine mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWXTapped)];
    [self.uvWeChat addGestureRecognizer:tap];
    
    if (_loginType == LoginType_bind) {
        self.title = @"绑定手机号";
        
        _attrLabel.hidden = YES;
        _uvSNS.hidden = YES;
        
    } else {
        self.title = @"登录";
    }
    
    //跳转到主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:kNotification_weChatLogin object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getPictureCodeWithRefreshCount:_refreshCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_weChatLogin object:nil];
}

// 获取验证码
- (void)onBtnVerCodeClick {
    
    if (!self.mobileStr || [self.mobileStr isEqualToString:@""] || self.mobileStr.length != 11) {
        [self showHudTipStr:@"手机号输入有误"];
        return;
    }
    
    if (self.pictureCode.length == 0) {
        _refreshCount += 1;
        _uvPictureCode.hidden = NO;
        
        [self.uvPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.uvPictureCode.mas_bottom).offset(14);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(40);
        }];
        
        [self getPictureCodeWithRefreshCount:_refreshCount];
    } else {
        WS(weakSelf);
        [NetworkAPIManager register_getSMSWithMobile:self.mobileStr Captcha:self.pictureCode andBlock:^(BaseCmd *cmd, NSError *error) {
            if (error) {
                [weakSelf showHudTipStr:TIP_NETWORKERROR];
            } else {
                [cmd errorCheckSuccess:^{
                    [weakSelf showHudTipStr:@"验证码已发送，请注意查收!"];
                } failed:^(NSInteger errCode) {
                    if (errCode == 0) {
                        NSString *msgStr = cmd.message;
                        [weakSelf showHudTipStr:msgStr];
                    }
                }];
            }
        }];
    }
}

// 登录、注册
- (void)onBtnLoginClicked {
    
    [self.view endEditing:YES];
    
    if (!self.mobileStr || [self.mobileStr isEqualToString:@""] || self.mobileStr.length != 11) {
        [self showHudTipStr:@"手机号输入有误"];
        return;
    }
    
    if (_loginType == LoginType_register) {
        if (!self.pictureCode || [self.pictureCode isEqualToString:@""]) {
            [self showHudTipStr:@"请输入图形验证码"];
            return;
        }
    }
    
    if (!self.passwordStr || [self.passwordStr isEqualToString:@""]) {
        [self showHudTipStr:@"请输入验证码"];
        return;
    }
    
    if (_loginType == LoginType_bind) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.mobileStr forKey:@"mobile"];
        
        WS(weakSelf);
        [NetworkAPIManager bind_mobileWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
            if (error) {
                [weakSelf showHudTipStr:TIP_NETWORKERROR];
            } else {
                [cmd errorCheckSuccess:^{
                    [weakSelf showHudTipStr:@"绑定成功"];
                    [weakSelf getProfile];
                } failed:^(NSInteger errCode) {
                    if (errCode == 0) {
                        NSString *msgStr = cmd.message;
                        [weakSelf showAlertViewControllerWithText:msgStr];
                    }
                }];
            }
        }];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.mobileStr forKey:@"mobile"];
        [params setObject:self.passwordStr forKey:@"vcode"];
        [params setObject:@"iOS" forKey:@"platform"];
        
        WS(weakSelf);
        [NetworkAPIManager site_fastloginWithParams:params andBlock:^(UserCmd *cmd, NSError *error) {
            if (error) {
                [weakSelf showHudTipStr:TIP_NETWORKERROR];
            } else {
                [cmd errorCheckSuccess:^{
                    if ([cmd isKindOfClass:[UserCmd class]]) {
                        UserCmd *userCmd = (UserCmd *)cmd;
                        NSLog(@"%@", userCmd);
                        
                        [weakSelf loginIMWithUserCmd:userCmd];
                    }
                } failed:^(NSInteger errCode) {
                    if (errCode == 0) {
                        NSString *msgStr = cmd.message;
                        [weakSelf showHudTipStr:msgStr];
                    }
                }];
            }
        }];
    }
}

- (void)loginIMWithUserCmd:(UserCmd *)userCmd {
    
    if (userCmd.token.length > 0) {
        [[MyAccountManager sharedManager] saveToken:userCmd.token];
    }
    
    [[MyAccountManager sharedManager] saveUserProfile:userCmd];
    [[AppManager GetInstance] onLoginSuccess];//执行系统级的登录任务
    
    [APP setupTabViewController];
    
    //登录
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.identifier = userCmd.memberId ? : @"";
    login_param.userSig = userCmd.qcloud_token;
    login_param.appidAt3rd = kSdkAppId;
    
    [[TIMManager sharedInstance] login:login_param succ:^{
        NSLog(@"Login Succ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"Login Failed: %d->%@", code, msg);
    }];
}

- (void)getProfile {
    WS(weakSelf);
    [NetworkAPIManager get_myProfileInfoWithParams:nil andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[UserCmd class]]) {
                    UserCmd *userCmd = (UserCmd *)cmd;
                    NSLog(@"%@", userCmd);
                    
                    if (userCmd.token.length > 0) {
                        [[MyAccountManager sharedManager] saveToken:userCmd.token];
                    }
                    
                    [[MyAccountManager sharedManager] saveUserProfile:userCmd];
                    [[AppManager GetInstance] onLoginSuccess];//执行系统级的登录任务
                    
                    [APP setupTabViewController];
                }
            } failed:^(NSInteger errCode) {
                
            }];
        }
    }];
}

- (void)onPictureCodeTapped {
    _refreshCount += 1;
    [self getPictureCodeWithRefreshCount:_refreshCount];
}

#pragma mark 网络相关

- (void)getPictureCodeWithRefreshCount:(NSInteger)count {
    
    [NetworkAPIManager register_getCaptchaWithRefresh:count andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [self showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[GetCaptchaCmd class]]) {
                    GetCaptchaCmd *captchaCmd = (GetCaptchaCmd *)cmd;
                    [_imgPictureCode sd_setImageWithURL:[NSURL URLWithString:captchaCmd.urlPic] placeholderImage:nil];
                }
            } failed:^(NSInteger errCode) {
                
            }];
        }
    }];
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
    
    _pictureCode = @"";
    _uvPictureCode.hidden = YES;
    [self.uvPassword mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvPhoneNumber.mas_bottom).offset(14);
    }];
    
    _loginType = LoginType_login;
    
    _lblPassword.text = @"验证码";
    
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
    
//    _btnVerCode.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _uvSNS.alpha = 1;
    }];
}

- (void)setupRegister {
    
    _loginType = LoginType_register;
    
    _lblPassword.text = @"验证码";
    
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
    
//    _btnVerCode.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _uvSNS.alpha = 0;
    }];
    
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
    
    self.mobileStr = text;
    
    self.txtPhoneNumber.text = text;
}

- (void)textPictureCodeValueChanged:(id)sender {
    NSString *text = self.txtPictureCode.text;
    
    self.pictureCode = text;
    
    self.txtPictureCode.text = text;
}

- (void)textPasswordValueChanged:(id)sender {
    
    NSString *text = self.txtPassword.text;
    
    self.passwordStr = text;
    
    self.txtPassword.text = text;
}

#pragma mark - 第三方登录

- (void)onWXTapped {
    
    AppDelegate *app = APP;
    app.weChatType = WeChatType_Login;
    
    NSLog(@"%s",__func__);
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)wechatDidLoginNotification:(NSNotification *)notification {
    NSString *code = [notification.userInfo objectForKey:@"code"];
    [self getWechatAccessTokenWithCode:code];
}

- (void)getWechatAccessTokenWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    kAPPSTORE_WECHAT_APPID, kAPPSTORE_WECHAT_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
            }
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *unionid = [dic objectForKey:@"unionid"];
                [self loginByWeChatWithOpenId:openId UnionId:unionid];
            }
        });
        
    });
}

- (void)loginByWeChatWithOpenId:(NSString *)openId UnionId:(NSString *)unionId {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:openId forKey:@"openid"];
    [params setObject:unionId forKey:@"unionid"];
    [params setObject:@"iOS" forKey:@"platform"];
    
    WS(weakSelf);
    [NetworkAPIManager login_weChatWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                [APP setupTabViewController];
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showAlertViewControllerWithText:msgStr];
                }
            }];
        }
    }];
}

@end
