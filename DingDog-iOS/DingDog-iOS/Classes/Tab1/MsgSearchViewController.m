//
//  MsgSearchViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "MsgSearchViewController.h"
#import "MessageListCell.h"

@interface MsgSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;

@end

@implementation MsgSearchViewController

-(void)setResults:(NSArray *)results {
    NSLog(@"%s",__FUNCTION__);
    _results = results;
    [self.mTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_mTableView];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        [_mTableView registerClass:[MessageListCell class] forCellReuseIdentifier:MessageListCellIdentifier];
        
        _mTableView.tableFooterView = [UIView new];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _mTableView;
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageListCellIdentifier forIndexPath:indexPath];
    
    MessageModel *model = self.results[indexPath.row];
    [cell configCellDataWithMessageModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static MessageListCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cell) {
            cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageListCellIdentifier];
        }
    });
    MessageModel *model = self.results[indexPath.row];
    [cell configCellDataWithMessageModel:model];
    return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
