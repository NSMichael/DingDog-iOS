//
//  Tab4_RootViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "Tab4_RootViewController.h"
#import "TimeLineTextCell.h"
#import "TimeLineImageCell.h"
#import "TZImagePickerController.h"
#import "QiniuSDK.h"
#import "PYPhotoBrowser.h"
#import "CreateMessageCmd.h"
#import "PreviewViewController.h"

@interface Tab4_RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textFieldName;

@property (nonatomic, strong) NSString *nameStr, *contentStr;

@property (nonatomic, strong) NSMutableArray *timelinePics;

@end

@implementation Tab4_RootViewController

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = kColorWhite;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_mTableView registerClass:[TimeLineTextCell class] forCellReuseIdentifier:TimeLineTextCellIdentifier];
        [_mTableView registerClass:[TimeLineImageCell class] forCellReuseIdentifier:TimeLineImageCellIdentifier];
        
        _mTableView.tableHeaderView = [self configHeaderView];
    }
    return _mTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"群发";
    
    [self setRightBarWithBtn:@"下一步" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.timelinePics = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupSendSuccess:) name:kNotification_groupSendSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)groupSendSuccess:(NSNotification *)notify {
    [self.timelinePics removeAllObjects];
    self.nameStr = @"";
    self.textFieldName.text = @"";
    self.contentStr = @"";
    [self.mTableView reloadData];
}

- (UIView *)configHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 48)];
        
        _textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kScreen_Width-40, 48)];
        _textFieldName.delegate = self;
        _textFieldName.font = kFont15;
        _textFieldName.placeholder = @"请输入标题";
        _textFieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textFieldName.textAlignment = NSTextAlignmentLeft;
        [_textFieldName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textFieldName addTarget:self action:@selector(textFieldNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_headerView addSubview:_textFieldName];
        
        UIImageView *imgSeparatorLine = [UIImageView new];
        imgSeparatorLine.frame = CGRectMake(15, 47.5, kScreen_Width-15, 0.5);
        imgSeparatorLine.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_headerView addSubview:imgSeparatorLine];
    }
    
    return _headerView;
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
    
    if (self.timelinePics.count == 0) {
        [self showHudTipStr:@"请上传图片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.nameStr forKey:@"title"];
    [params setObject:self.contentStr forKey:@"content"];
    
    NSMutableString *imageKeyStr = [NSMutableString string];
    if (self.timelinePics.count > 0) {
        for (int i = 0; i < _timelinePics.count; i++) {
            PhotoEntity *entity = _timelinePics[i];
            if (entity) {
                [imageKeyStr appendString:entity.resKey];
                
                if (i < (_timelinePics.count-1)) {
                    [imageKeyStr appendString:@","];
                }
            }
        }
        
        [params setObject:imageKeyStr forKey:@"images"];
    }
    
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
                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                    [weakSelf presentViewController:nav animated:YES completion:nil];
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

#pragma mark UITextField delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldNameValueChanged:(id)sender {
    self.nameStr = self.textFieldName.text;
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    if (indexPath.row == 0) {
        TimeLineTextCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeLineTextCellIdentifier forIndexPath:indexPath];
        cell.textView.text = _contentStr;
        cell.textValueChangedBlock = ^(NSString *valueStr){
            @strongify(self);
            self.contentStr = valueStr;
        };
        return cell;
    } else if (indexPath.row == 1) {
        TimeLineImageCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeLineImageCellIdentifier forIndexPath:indexPath];
//        cell.backgroundColor = kColorGray;
        cell.imgEditView.mTarget = self;
        cell.imgEditView.mActionClick = @selector(onBtnTakePhotoClick:);
        cell.imgEditView.mActionDel = @selector(onBtnDeletePhoto:);
        
        [cell paintWithDefaultPhotoArray:self.timelinePics];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.row == 0) {
        cellHeight = [TimeLineTextCell cellHeight];
    } else if(indexPath.row == 1){
        cellHeight = 300;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

# pragma mark - ImgEditView delegate

- (void)onBtnTakePhotoClick:(id)sender {
    [self.view endEditing:YES];
    
    UIButton *bt = sender;
    if(bt.tag<self.timelinePics.count && bt.tag>=0){
        //显示照片
        NSMutableArray *photos = [NSMutableArray new];
        for(int i=0;i<self.timelinePics.count;i++){
            PhotoEntity *entity = self.timelinePics[i];
            if (entity.img) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:entity.img];
                [photos addObject:imageView];
            }
        }
        
        // 1. 创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        
        // 2.1 设置图片源(UIImageView)数组
        photoBroseView.sourceImgageViews = photos;
        // 2.2 设置初始化图片下标（即当前点击第几张图片）
        photoBroseView.currentIndex = bt.tag;
        
        // 3.显示(浏览)
        [photoBroseView show];
    } else {
        if (self.timelinePics.count < 9) {
            [self showActionSheetTakePhotoByMultiSelect];
        } else{
            [self showAlertViewControllerWithText:@"最多拍摄9张图片"];
        }
    }
}

- (void)onBtnDeletePhoto:(id)sender {
    UIButton *bt = sender;
    if (bt.tag < self.timelinePics.count) {
        [self.timelinePics removeObjectAtIndex:bt.tag];
    }
    
    [self.mTableView reloadData];
}

- (void) showActionSheetTakePhotoByMultiSelect {
    WS(weakSelf);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([DeviceAuthHelper checkCameraAuthorizationStatus]){
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
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    NSString *uploadToken = [[UploadManager GetInstance] getUploadToken];
    if (uploadToken) {
        WS(weakSelf);
        
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf showMBProgressHUD];
            
            UIImage *tmpImage = (UIImage *)obj;
            
            NSLog(@"%@",obj);
            NSLog(@"%ld",idx);
            
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            
            NSData *imgData;
            if (UIImagePNGRepresentation(obj) == nil) {
                imgData = UIImageJPEGRepresentation(obj, 1);
            } else {
                imgData = UIImagePNGRepresentation(obj);
            }
            
            [uploadManager putData:imgData key:nil token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
                
                if (idx == photos.count - 1) {
                    [weakSelf hideMBProgressHUD];
                }
                
                PhotoEntity *photo = [[PhotoEntity alloc] initWithLocalImg:tmpImage photoName:@""];

                if (info.error) {
                    NSLog(@"出错啦");
                } else {
                    NSLog(@"上传成功");
                    NSString *key = [resp valueForKey:@"key"];
                    if (key.length > 0) {
                        photo.resKey = key;
                        [weakSelf.timelinePics addObject:photo];
                        NSLog(@"%@", _timelinePics);
                        [weakSelf.mTableView reloadData];
                    }
                }

            } option:uploadOption];
        }];
    }
}

@end
