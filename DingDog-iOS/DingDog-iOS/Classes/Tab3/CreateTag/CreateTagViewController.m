//
//  CreateTagViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CreateTagViewController.h"
#import "CustomerModel.h"

@interface CreateTagViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lblTag;
@property (nonatomic, strong) UITextField *textFieldTagName;
@property (nonatomic, strong) UIImageView *imgLine;

@property (nonatomic, strong) NSString *tagNameStr;

@end

@implementation CreateTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新建";
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    _lblTag = [UILabel new];
    _lblTag.text = @"标签";
    _lblTag.font = kFont14;
    _lblTag.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_lblTag];
    [self.lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 14));
    }];
    
    _textFieldTagName = [UITextField new];
    _textFieldTagName.delegate = self;
    _textFieldTagName.font = kFont13;
    _textFieldTagName.placeholder = @"请输入标签名称";
    _textFieldTagName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldTagName.textAlignment = NSTextAlignmentLeft;
    [_textFieldTagName addTarget:self action:@selector(textTagNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textFieldTagName];
    [self.textFieldTagName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.mas_equalTo(self.lblTag.mas_right).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    _imgLine = [UIImageView new];
    _imgLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.view addSubview:_imgLine];
    [self.imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblTag.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_offset(0.5);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITextField delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textTagNameValueChanged:(id)sender {
    
    NSString *text = self.textFieldTagName.text;
    
    self.tagNameStr = text;
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    
    [self.textFieldTagName resignFirstResponder];
    
    if (self.tagNameStr.length == 0) {
        [self showHudTipStr:@"标签名称不能为空"];
        return;
    }
    
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
    [params setObject:_tagNameStr forKey:@"tagname"];
    
    WS(weakSelf);
    [NetworkAPIManager customer_tagCreateWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [self showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                NSString *msgStr = cmd.message;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_createTagSuccess object:nil];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [self showHudTipStr:msgStr];
                }
            }];
        }
    }];
    
    
}

@end
