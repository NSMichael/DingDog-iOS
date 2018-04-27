//
//  CustomerDetailViewController.m
//  DingDog-iOS
//
//  Created by james on 18/06/07.
//  Copyright © 2018年 耿功发. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "UserTagListCell.h"
#import "EditInfoViewController.h"
#import "ChangeTagViewController.h"

@interface CustomerDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) UIImageView *imgAvatar;

@property (nonatomic, strong) CustomerModel *customerModel;

@end

@implementation CustomerDetailViewController

- (instancetype)initWithCustomerModel:(CustomerModel *)model {
    self = [super init];
    if (self) {
        _customerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rdv_tabBarController.tabBar.hidden = YES;
    
    [self initSceneUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:kNotification_customerInfoUpdategSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateProfile:(NSNotification *)notify {
    _customerModel = [notify object];
    [self.mTableView reloadData];
}

- (void)initSceneUI {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [UIView new];
        [self.view addSubview:_mTableView];
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_mTableView registerClass:[UserTagListCell class] forCellReuseIdentifier:UserTagListCellIdentifier];
        
        _mTableView.tableHeaderView = [self configHeaderView];
    }
}

- (UIView *)configHeaderView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 180)];
        
        _imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-80)/2, 24, 80, 80)];
        _imgAvatar.layer.cornerRadius = 40;
        _imgAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _imgAvatar.clipsToBounds = YES;
        [_headerView addSubview:_imgAvatar];
        
        _lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, kScreen_Width - 40, 22)];
        _lblUserName.font = kFont18;
        _lblUserName.textAlignment = NSTextAlignmentCenter;
        _lblUserName.textColor = [UIColor colorWithHexString:@"0x000000"];
        [_headerView addSubview:_lblUserName];
    }
    
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_customerModel.headimgurl] placeholderImage:nil];
    _lblUserName.text = _customerModel.nickname ? : @"";
    
    return _headerView;
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UserTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTagListCellIdentifier forIndexPath:indexPath];
        [cell configCellDataWithCustomerModel:_customerModel];
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFont13;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
        cell.textLabel.text = @"城市";
        
        cell.detailTextLabel.font = kFont14;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
        cell.detailTextLabel.text = _customerModel.province ? : @"";
        
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFont13;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x8A8A8F"];
        cell.textLabel.text = @"电话";
        
        cell.detailTextLabel.font = kFont14;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
        cell.detailTextLabel.text = _customerModel.memo ? : @"";
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static UserTagListCell *cell;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!cell) {
                cell = [[UserTagListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserTagListCellIdentifier];
            }
        });
        [cell configCellDataWithCustomerModel:_customerModel];
        return [cell calculateCellHeightInAutolayoutMode:cell tableView:tableView];
    } else {
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ChangeTagViewController *vc = [[ChangeTagViewController alloc] initWithModel:_customerModel];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        EditInfoViewController *vc = [[EditInfoViewController alloc] initWithModel:_customerModel EditInfoType:EditInfoType_City];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        EditInfoViewController *vc = [[EditInfoViewController alloc] initWithModel:_customerModel EditInfoType:EditInfoType_Phone];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
