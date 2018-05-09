//
//  InTagSelectedViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "InTagSelectedViewController.h"
#import "ChangeUserTagCell.h"
#import "TagListCmd.h"

@interface InTagSelectedViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *lblInTags;

@property (nonatomic, strong) NSArray *selectedArray;

@end

@implementation InTagSelectedViewController

- (instancetype)initWithCurrentSelectedTagArray:(NSArray *)arr {
    self = [super init];
    if (self) {
        _selectedArray = arr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"群发";
    
    [self setRightBarWithBtn:@"完成" imageName:nil action:@selector(onRightBarButtonClicked:) badge:@"0"];
    
    [self initSceneUI];
    [self getCustomerTagList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Click Events

- (void)onRightBarButtonClicked:(id)sender {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.inTagSelectedBlock) {
            weakSelf.inTagSelectedBlock(weakSelf.selectedArray);
        }
    }];
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
        
        UILabel *lblIn = [UILabel new];
        lblIn.frame = CGRectMake(15, 10, 50, 18);
        lblIn.text = @"IN";
        lblIn.font = kFont16;
        lblIn.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:lblIn];
        
        UILabel *lblInTip = [UILabel new];
        lblInTip.frame = CGRectMake(15, 28, 50, 18);
        lblInTip.text = @"包含条件";
        lblInTip.font = kFont10;
        lblInTip.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:lblInTip];
        
        _lblInTags = [UILabel new];
        _lblInTags.frame = CGRectMake(80, 8, kScreen_Width-80-15, 40);
        _lblInTags.textAlignment = NSTextAlignmentLeft;
        _lblInTags.font = kFont14;
        _lblInTags.numberOfLines = 2;
        [_headerView addSubview:_lblInTags];
        
        UIImageView *imgSeparatorLine2 = [UIImageView new];
        imgSeparatorLine2.frame = CGRectMake(0, 49.5, kScreen_Width, 0.5);
        imgSeparatorLine2.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"0xBCBCBC"]];
        [_headerView addSubview:imgSeparatorLine2];
    }
    
    _lblInTags.text = [self getSelectedTagTextWithArray:_selectedArray];
    
    return _headerView;
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

#pragma mark - TTGTextTagCollectionView delegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config {
    NSArray *currentSelectedArray =  [textTagCollectionView allSelectedTags];
    self.selectedArray = currentSelectedArray;
    
    _lblInTags.text = [self getSelectedTagTextWithArray:currentSelectedArray];
}

- (NSMutableString *)getSelectedTagTextWithArray:(NSArray *)arr {
    NSMutableString *muStr = [NSMutableString string];
    if (arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            [muStr appendString:arr[i]];
            if (i < (arr.count - 1)) {
                [muStr appendString:@";"];
            }
        }
    }
    return muStr;
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
    cell.tagView.delegate = self;
    [cell configCellDataWithAllTagArray:_tagArray SelectedTagArray:_selectedArray];
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
    [cell configCellDataWithAllTagArray:_tagArray SelectedTagArray:_selectedArray];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
