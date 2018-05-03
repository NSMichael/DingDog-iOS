//
//  ChangeTagViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "ChangeTagViewController.h"
#import "ChangeUserTagCell.h"
#import "TagListCmd.h"

@interface ChangeTagViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) CustomerModel *customerModel;

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textFieldAdd;

@end

@implementation ChangeTagViewController

- (instancetype)initWithModel:(CustomerModel *)model {
    self = [super init];
    if (self) {
        _customerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改标签";
    
    [self setLeftBarWithBtn:@"取消" imageName:nil action:@selector(onLeftBarButtonClicked:) badge:@"0"];
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self initSceneUI];
    [self getCustomerTagList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (void)initSceneUI {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellEditingStyleNone;
        [self.view addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_mTableView registerClass:[ChangeUserTagCell class] forCellReuseIdentifier:ChangeUserTagCellIdentifier];
        
        _mTableView.tableHeaderView = [self configHeaderView];
    }
}

- (UIView *)configHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        
        _textFieldAdd = [[UITextField alloc] initWithFrame:CGRectMake(16, 10, kScreenWidth-32, 36)];
        _textFieldAdd.delegate = self;
        _textFieldAdd.textColor = [UIColor colorWithHexString:@"0xC8C7CD"];
        _textFieldAdd.font = kFont14;
        _textFieldAdd.returnKeyType = UIReturnKeyDone;
        _textFieldAdd.layer.masksToBounds = YES;
        _textFieldAdd.layer.cornerRadius = 18;
        _textFieldAdd.layer.borderWidth = 1;
        _textFieldAdd.layer.borderColor = [UIColor colorWithHexString:@"0xC8C7CC"].CGColor;
        _textFieldAdd.backgroundColor = [UIColor colorWithHexString:@"0xF7F7F7"];
        _textFieldAdd.placeholder = @"新建标签";
        [_headerView addSubview:_textFieldAdd];
        
        UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(22, 7, 30, 22)];
        lblLeft.text = @"#";
        lblLeft.textColor = [UIColor colorWithHexString:@"0xC8C7CD"];
        lblLeft.font = kFont14;
        lblLeft.textAlignment = NSTextAlignmentCenter;
        _textFieldAdd.leftView = lblLeft;
        _textFieldAdd.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _headerView;
}

#pragma mark UITextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textFieldAdd resignFirstResponder];
    if (_textFieldAdd.text.length > 0) {
        [self addNewCustomerTag];
    }
    
    return YES;
}

- (void)addNewCustomerTag {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_customerModel.member_id forKey:@"userids"];
    [params setObject:_textFieldAdd.text forKey:@"tagname"];
    
    WS(weakSelf);
    [NetworkAPIManager customer_tagCreateWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                NSMutableArray *arr = [NSMutableArray arrayWithArray:weakSelf.customerModel.tagArray];
                [arr addObject:weakSelf.textFieldAdd.text];
                weakSelf.customerModel.tagArray = arr;
                
                weakSelf.textFieldAdd.text = @"";
                [weakSelf showHudTipStr:@"添加成功"];
                [weakSelf getCustomerTagList];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_customerAddTagSuccess object:weakSelf.customerModel];
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - click event

- (void)onLeftBarButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightBarButtonClicked:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ChangeUserTagCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
    NSArray *arrSelected = [cell.tagView allSelectedTags];
    NSLog(@"%@", arrSelected);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_customerModel.member_id forKey:@"userid"];
    
    NSArray *tagArray = arrSelected;
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
    
    [params setObject:_customerModel.memo forKey:@"memo"];
    [params setObject:_customerModel.province forKey:@"province"];
    
    WS(weakSelf);
    [NetworkAPIManager customer_profileUpdateWithParams:params andBlock:^(BaseCmd *cmd, NSError *error) {
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                NSString *msgStr = cmd.message;
                [weakSelf showHudTipStr:msgStr];

                _customerModel.tagArray = arrSelected;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_customerInfoUpdategSuccess object:_customerModel];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            } failed:^(NSInteger errCode) {
                if (errCode == 0) {
                    NSString *msgStr = cmd.message;
                    [weakSelf showHudTipStr:msgStr];
                }
            }];
        }
    }];
}

#pragma mark - Network

- (void)getCustomerTagList {
    WS(weakSelf);
    [NetworkAPIManager customer_tagList:^(BaseCmd *cmd, NSError *error) {
        [weakSelf.mTableView.headRefreshControl endRefreshing];
        if (error) {
            [weakSelf showHudTipStr:TIP_NETWORKERROR];
        } else {
            [cmd errorCheckSuccess:^{
                
                if ([cmd isKindOfClass:[TagListCmd class]]) {
                    TagListCmd *tagCmd = (TagListCmd *)cmd;
                    _tagArray = [NSMutableArray arrayWithArray:tagCmd.itemArray];
                    [weakSelf.mTableView reloadData];
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

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangeUserTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ChangeUserTagCellIdentifier forIndexPath:indexPath];
    [cell configCellDataWithCustomerModel:_customerModel AllTagArray:_tagArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ChangeUserTagCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[ChangeUserTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangeUserTagCellIdentifier];
        }
    });
    [cell configCellDataWithCustomerModel:_customerModel AllTagArray:_tagArray];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
