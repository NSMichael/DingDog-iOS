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

@interface Tab4_RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textFieldName;

@property (nonatomic, strong) NSString *nameStr, *contentStr;

@property (nonatomic, strong) NSMutableArray *timelinePics;
@property (nonatomic, assign) NSInteger photoCount;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
}

- (void)onBtnDeletePhoto:(id)sender {
    
}

@end
