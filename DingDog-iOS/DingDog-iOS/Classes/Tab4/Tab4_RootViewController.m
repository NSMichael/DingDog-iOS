//
//  Tab4_RootViewController.m
//  DingDog-iOS
//
//  Created by 耿功发 on 2018/3/13.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab4_RootViewController.h"
#import "GroupSendModel.h"
#import "BaseNavigationController.h"
#import "GroupSendListViewController.h"
#import "SZTextView.h"
#import "CreateMessageCmd.h"
#import "PreviewViewController.h"

@interface Tab4_RootViewController ()<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *uvTextFieldName;
@property (nonatomic, strong) UITextField *textFieldName;

@property (nonatomic, strong) NSString *nameStr, *contentStr, *imageKeyStr;

@property (nonatomic, strong) SZTextView *szTextView;

@property (nonatomic, strong) UIToolbar *myToolbar;

@end

@implementation Tab4_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群发";
    
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self initializeUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)initializeUI {
    
    _uvTextFieldName = [UIView new];
    [self.view addSubview:_uvTextFieldName];
    [self.uvTextFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(45);
    }];
    
    _textFieldName = [UITextField new];
    _textFieldName.delegate = self;
    _textFieldName.font = kFont14;
    _textFieldName.placeholder = @"请输入文章标题";
    _textFieldName.inputAccessoryView = self.myToolbar;
    [_textFieldName addTarget:self action:@selector(textFieldNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uvTextFieldName addSubview:_textFieldName];
    [self.textFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvTextFieldName).offset(0);
        make.left.equalTo(self.uvTextFieldName).offset(15);
        make.right.equalTo(self.uvTextFieldName).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    UIImageView *imgFieldNameLine = [UIImageView new];
    imgFieldNameLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
    [self.uvTextFieldName addSubview:imgFieldNameLine];
    [imgFieldNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFieldName.mas_bottom);
        make.left.and.right.equalTo(self.uvTextFieldName);
        make.height.mas_offset(0.5);
    }];
    
    _szTextView = [SZTextView new];
    _szTextView.font = kFont15;
    _szTextView.delegate = self;
    _szTextView.placeholder = @"请输入文章内容";
    _szTextView.inputAccessoryView = self.myToolbar;
    _szTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:_szTextView];
    [self.szTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uvTextFieldName.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(200);
    }];
}

- (UIToolbar *)myToolbar {
    if (!_myToolbar) {
        CGRect tempFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        _myToolbar = [[UIToolbar alloc] initWithFrame:tempFrame];
        _myToolbar.barStyle = UIBarStyleDefault;
        _myToolbar.translucent = NO;
        
        UIImage *photoImg = [UIImage imageNamed:@"icon-img"];
        UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithImage:photoImg style:UIBarButtonItemStylePlain target:self action:@selector(photoItemClicked:)];
        
        _myToolbar.items = @[photoItem];
    }
    return _myToolbar;
}

#pragma mark - click event

- (void)onRightBarButtonClicked:(id)sender {
    
    if (self.nameStr.length == 0) {
        [self showHudTipStr:@"请输入文章标题"];
        return;
    }
    
    if (self.contentStr.length == 0) {
        [self showHudTipStr:@"请输入文章内容"];
        return;
    }
    
    if (self.imageKeyStr.length == 0) {
        [self showHudTipStr:@"请上传图片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.nameStr forKey:@"title"];
    [params setObject:self.contentStr forKey:@"content"];
    [params setObject:self.imageKeyStr forKey:@"images"];
    
    WS(weakSelf);
    [NetworkAPIManager message_createWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                if ([cmd isKindOfClass:[CreateMessageCmd class]]) {
                    CreateMessageCmd *msgCmd = (CreateMessageCmd *)cmd;
                    NSLog(@"%@", msgCmd);
                    
                    PreviewViewController *vc = [[PreviewViewController alloc] initWithCreateMessageCmd:msgCmd];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
    
    /*
     GroupSendListViewController *vc = [[GroupSendListViewController alloc] init];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
     [weakSelf presentViewController:nav animated:YES completion:nil];
     */
    
}

- (void)photoItemClicked:(id)sender
{
    [self.view endEditing:YES];
    
    WS(weakSelf);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([DeviceAuthHelper checkCameraAuthorizationStatus]) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && (sourceType == UIImagePickerControllerSourceTypeCamera)) {
                
                [weakSelf showAlertViewControllerWithText:@"本设备不支持拍照功能，请从相册选取"];
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            [weakSelf presentViewController:picker animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([DeviceAuthHelper checkPhotoLibraryAuthorizationStatus]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:picker animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showLoadingView];
    
    UIImage *userIconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (userIconImage.size.width > IMG_WIDTH_PERFECT) {
        CGFloat resizeRatio = IMG_WIDTH_PERFECT / userIconImage.size.width;
        CGSize newSize = CGSizeMake(IMG_WIDTH_PERFECT, resizeRatio * userIconImage.size.height);
        userIconImage = [userIconImage resizeImageWithNewSize:newSize];
    }
    
    // 保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(userIconImage, self, nil, NULL);
    }
    
    WS(weakSelf)
    [[UploadManager GetInstance] uploadImgWithRestype:RES_IMG_GroupSend img:userIconImage block:^(NSString *keystr, NSError *error) {
        
        [weakSelf hideLoadingView];
        
        if (error) {
            if ([error code] == ERRORCODE_ForbiddenUser) {
                [weakSelf showStatusBarErrorWithString:[error domain]];
            } else {
                [weakSelf showStatusBarErrorWithString:TIP_NETWORKERROR];
            }
            
        } else {
            
            [self showHudTipStr:@"图片上传成功"];
            self.imageKeyStr = keystr;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextField delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldNameValueChanged:(id)sender {
    NSString *text = self.textFieldName.text;
    self.nameStr = text;
}

#pragma mark UITextView delegates

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = self.szTextView.text;
    self.contentStr = text;
}

@end
