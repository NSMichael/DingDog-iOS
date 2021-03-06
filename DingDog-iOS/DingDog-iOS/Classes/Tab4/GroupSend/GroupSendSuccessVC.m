//
//  GroupSendSuccessVC.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/16.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "GroupSendSuccessVC.h"
#import "CustomerModel.h"

@interface GroupSendSuccessVC () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *uvTagName;
@property (nonatomic, strong) UITextField *textFieldTagName;

@property (nonatomic, strong) UILabel *lblTip;
@property (nonatomic, strong) UIView *uvAvatar;

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *tempArray;

@property (nonatomic, strong) CreateMessageCmd *createMessageCmd;

@end

@implementation GroupSendSuccessVC

- (instancetype)initWithAllCustomerArray:(NSMutableArray *)allArray CreateMessageCmd:(CreateMessageCmd *)cmd {
    self = [super init];
    if (self) {
        _createMessageCmd = cmd;
        _selectedArray = allArray;
        _tempArray = [NSMutableArray array];
        if (allArray.count > 10) {
            for (int i = 0; i < 10; i++) {
                CustomerModel *model = allArray[i];
                if (model) {
                    [_tempArray addObject:model];
                }
            }
        } else {
            _tempArray = allArray;
        }
        
        [self sendMessageMulti];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sendMessageMulti {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_createMessageCmd.msgid forKey:@"msgid"];
    
    NSMutableString *useridsStr = [NSMutableString string];
    if (_selectedArray.count > 0) {
        for (int i = 0; i < _selectedArray.count; i++) {
            CustomerModel *model = _selectedArray[i];
            if (model) {
                [useridsStr appendString:model.member_id];
                
                if (i < (_selectedArray.count-1)) {
                    [useridsStr appendString:@","];
                }
            }
        }
        
        [params setObject:useridsStr forKey:@"userids"];
    }
    
    WS(weakSelf);
    [NetworkAPIManager message_multiSendWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_groupSendSuccess object:nil];
                [weakSelf initScene];
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
}

- (void)onLeftBarButtonClicked:(id)sender {
    [self toRootViewController];
}

- (void)toRootViewController {
    WS(weakSelf);
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.onGronpSendSuccessBlocked) {
            weakSelf.onGronpSendSuccessBlocked();
        }
    }];
}

- (void)initScene {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-168)/2, 24, 168, 64)];
        _topView.backgroundColor = [UIColor colorWithRGB:0xEFEFEF];
        _topView.layer.cornerRadius = 10;
        _topView.layer.masksToBounds = YES;
        [self.view addSubview:_topView];
        
        UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(31, 20, 24, 24)];
        imgIcon.image = [UIImage imageNamed:@"icon-readed"];
        [_topView addSubview:imgIcon];
        
        UILabel *lblSuccess = [[UILabel alloc] initWithFrame:CGRectMake(69, 22, 70, 20)];
        lblSuccess.font = kFont17;
        lblSuccess.textColor = [UIColor colorWithRGB:0x007AFF];
        lblSuccess.text = @"群发成功";
        [_topView addSubview:lblSuccess];
    }
    
    if (!_uvTagName) {
        _uvTagName = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreen_Width, 49)];
        [self.view addSubview:_uvTagName];
        
        UIImageView *imgLine1 = [UIImageView new];
        imgLine1.frame = CGRectMake(20, 0, kScreen_Width-40, 0.5);
        imgLine1.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_uvTagName addSubview:imgLine1];
        
        _textFieldTagName = [UITextField new];
        _textFieldTagName.frame = CGRectMake(20, 0.5, kScreen_Width-40, 48);
        _textFieldTagName.delegate = self;
        _textFieldTagName.font = kFont13;
        _textFieldTagName.placeholder = @"输入标签名称";
        _textFieldTagName.returnKeyType = UIReturnKeyGo;
        _textFieldTagName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textFieldTagName.textAlignment = NSTextAlignmentCenter;
        [_uvTagName addSubview:_textFieldTagName];
        
        UIImageView *imgLine2 = [UIImageView new];
        imgLine2.frame = CGRectMake(20, 48.5, kScreen_Width-40, 0.5);
        imgLine2.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_uvTagName addSubview:imgLine2];
    }
    
    if (!_lblTip) {
        _lblTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 208, kScreen_Width-40, 20)];
        _lblTip.font = kFont15;
        _lblTip.textAlignment = NSTextAlignmentCenter;
        _lblTip.textColor = [UIColor colorWithRGB:0x454553];
        _lblTip.text = [NSString stringWithFormat:@"为本次群发的%ld人添加新标签", _selectedArray.count];
        [self.view addSubview:_lblTip];
    }
    
    if (!_uvAvatar) {
        _uvAvatar = [[UIView alloc] initWithFrame:CGRectMake(0, 250, kScreen_Width, 30)];
        [self.view addSubview:_uvAvatar];
        
        CGFloat firstX = (kScreen_Width - _tempArray.count * 30) / 2;
        
        if (_tempArray.count > 0) {
            for (int i = 0; i <_tempArray.count; i++) {
                CustomerModel *model = _tempArray[i];
                UIImageView *imgAvatar = [[UIImageView alloc] init];
                imgAvatar.frame = CGRectMake(firstX + i *30, 0, 30, 30);
                imgAvatar.layer.cornerRadius = 15;
                imgAvatar.layer.masksToBounds = YES;
                imgAvatar.layer.borderWidth = 3;
                imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
                [imgAvatar sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:nil];
                [_uvAvatar addSubview:imgAvatar];
            }
        }
    }
}

#pragma mark UITextField delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        
        [textField resignFirstResponder];
        
        if (textField.text.length == 0) {
            [self showHudTipStr:@"标签名称不能为空"];
            return false;
        } else {
            [self createTagWithCustomerArray];
        }
    }
    return true;
}

- (void)createTagWithCustomerArray {
    
    NSMutableString *tempString = [NSMutableString string];
    for (int i = 0; i < _selectedArray.count; i++) {
        CustomerModel *model = _selectedArray[i];
        
        [tempString appendString:model.member_id];
        
        if (i < (_selectedArray.count-1)) {
            [tempString appendString:@","];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tempString forKey:@"userids"];
    [params setObject:_textFieldTagName.text forKey:@"tagname"];
    
    WS(weakSelf);
    [NetworkAPIManager customer_tagCreateWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                NSString *msgStr = cmd.message;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_createTagSuccess object:nil];
                    [weakSelf toRootViewController];
                }]];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
}


@end
