//
//  EditInfoViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/4/24.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lblTag;
@property (nonatomic, strong) UITextField *textFieldTagName;
@property (nonatomic, strong) UIImageView *imgLine;

@property (nonatomic, strong) NSString *valueStr;

@property (nonatomic, assign) EditInfoType editType;
@property (nonatomic, strong) CustomerModel *customerModel;

@end

@implementation EditInfoViewController

- (instancetype)initWithModel:(CustomerModel *)model EditInfoType:(EditInfoType)type {
    self = [super init];
    if (self) {
        _customerModel = model;
        _editType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    _lblTag = [UILabel new];
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
    
    if (_editType == EditInfoType_City) {
        self.title = @"修改城市";
        _lblTag.text = @"城市";
        _textFieldTagName.placeholder = @"请输入城市名称";
        _textFieldTagName.keyboardType = UIKeyboardTypeDefault;
        _textFieldTagName.text = _customerModel.province;
    } else {
        self.title = @"修改电话";
        _lblTag.text = @"电话";
        _textFieldTagName.placeholder = @"请输入电话号码";
        _textFieldTagName.keyboardType = UIKeyboardTypePhonePad;
        _textFieldTagName.text = _customerModel.memo;
    }
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
    
    self.valueStr = text;
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    
    [self.textFieldTagName resignFirstResponder];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_customerModel.member_id forKey:@"userid"];
    
    NSArray *tagArray = _customerModel.tagArray;
    if (tagArray.count > 0) {
        NSMutableString *muStr = [NSMutableString string];
        for (int i = 0; i < tagArray.count; i++) {
            [muStr appendString:tagArray[i]];
            if (i < (tagArray.count - 1)) {
                [muStr appendString:@","];
            }
        }
        [params setObject:muStr forKey:@"tags"];
    } else {
        [params setObject:@"" forKey:@"tags"];
    }
    
    if (_editType == EditInfoType_City) {
        [params setObject:self.valueStr forKey:@"province"];
        [params setObject:_customerModel.memo forKey:@"memo"];
    } else {
        [params setObject:_customerModel.province forKey:@"province"];
        [params setObject:self.valueStr forKey:@"memo"];
    }
    
    WS(weakSelf);
    [NetworkAPIManager customer_profileUpdateWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                [weakSelf showHudTipStr:@"修改成功"];
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
