//
//  BaseViewController.m
//  vdangkou
//
//  Created by 耿功发 on 15/3/5.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "BaseViewController.h"
#import "ACPDownloadView.h"
#import "ACPIndeterminateGoogleLayer.h"
#import "UIImage+Common.h"
#import "CustomBadge.h"
#import "DGActivityIndicatorView.h"

@interface BaseViewController ()
{
    ACPDownloadView *downloadView;
    
    DGActivityIndicatorView *activityIndicatorView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorViewBG;
    
    NSLog(@"当前打开的类是：%@", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = kColorTheme;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.tintColor = kColorTheme;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tabBarItemClicked{
    SLOG(@"\ntabBarItemClicked : %@", NSStringFromClass([self class]));
}

#pragma mark - UI
-(CGRect)appFrameWithoutTabbar
{
    CGRect winFrame = kScreen_Bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGRect frame = CGRectMake(0, 0, kScreen_Width, winFrame.size.height - statusBarFrame.size.height - navigationBarFrame.size.height);
    return frame;
}

/**
 判断那个覆盖状态栏的statusbar的通知，是否正在显示中
 */
- (BOOL)isJDStatusBarVisiable{
    return [JDStatusBarNotification isVisible];
}

/**
 与showBlankView配对，隐藏一个空白页面
 */
- (void)hideBlankView{
    if(self.blankPage){
        [self.blankPage removeFromSuperview];
        self.blankPage = nil;
    }
}




#pragma mark - Navigation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSArray *ctrs = self.navigationController.viewControllers;
    UIViewController *lastCtr = (UIViewController *)ctrs.lastObject;
    if ([lastCtr isKindOfClass:[viewController class]]) {
        return;
    }
    
    [self.navigationController pushViewController:viewController animated:animated];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

-(void)setLeftBarWithBtn:(NSString *)title imageName:(NSString *)imageName action:(SEL)action badge:(NSString*)badge
{
    if(!badge || [[badge trimWhitespace] isEqualToString:@""] || [[badge trimWhitespace] isEqualToString:@"0"]){
        UIButton *button = [self buildButton:title imageName:imageName action:action aAlignment:NavigationBarItemType_Left];
        
        UIBarButtonItem *items1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = 10;
        self.navigationItem.leftBarButtonItems = @[items1];
    }else{
        UIBarButtonItem *items1 = [self barButtonViewWithBadgeWithText:title action:action badgeString:badge];
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -20;
        self.navigationItem.leftBarButtonItems = @[negativeSeperator, items1];
    }
}

-(void)setRightBarWithBtn:(NSString *)title imageName:(NSString *)imageName action:(SEL)action badge:(NSString*)badge
{
    if(!badge || [[badge trimWhitespace] isEqualToString:@""] || [[badge trimWhitespace] isEqualToString:@"0"]){
        UIButton *button = [self buildButton:title imageName:imageName action:action aAlignment:NavigationBarItemType_Left];
        
        UIBarButtonItem *items1 = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        self.navigationItem.rightBarButtonItems = @[negativeSeperator,items1];
    }else{
        UIBarButtonItem *items1 = [self barButtonViewWithBadgeWithText:title action:action badgeString:badge];
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        self.navigationItem.rightBarButtonItems = @[items1,negativeSeperator];
    }
}

- (UIButton *)buildButton:(NSString *)title imageName:(NSString *)imageName action:(SEL)action aAlignment:(NavigationBarItemType)aAlignment{
    
    CGFloat width = 0.0f;
    CGSize size = CGSizeZero;
    if (title) {
        
        NSDictionary *titleAttributes;
        
        if ([title isEqualToString:@"更多"]) {
            titleAttributes = @{
                                              NSFontAttributeName: kFontB16,
                                              NSForegroundColorAttributeName: kColorWhite
                                              };
        } else {
            titleAttributes = @{
                                              NSFontAttributeName: kFontB16,
                                              NSForegroundColorAttributeName: kColorWithRGB(254, 114, 45)
                                              };
        }
        
        
        size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 21)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:titleAttributes
                                   context:nil].size;
        
        width += size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    if ([title isEqualToString:@"更多"]) {
        [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithHexString:@"0xFF871F"] forState:UIControlStateNormal];
    }
    [button setTitleColor:kColorWithRGBA(254, 114, 45, 0.2) forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = kFontB16;
    
    UIImage *image = nil;
    if (imageName) {
        image = [UIImage imageNamed:imageName];
        switch (aAlignment) {
            case NavigationBarItemType_Bg:
            {
                width = MAX(width,image.size.width);
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
                break;
            case NavigationBarItemType_Left:
            {
                width += image.size.width + 5;
                
                [button setImage:image forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
                break;
            case NavigationBarItemType_Right:
            {
                width += image.size.width + 5;
                [button setImage:image forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
                break;
                
            default:
                break;
        }
    }
    
    if (image)
    {
        [button setFrame:CGRectMake(0, 0, MAX((width),40), MAX(30, image.size.height))];
    }
    else
    {
        [button setFrame:CGRectMake(0, 0, MAX((width),40),30)];
    }
    
    if (action)
    {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

- (UIBarButtonItem *)backButton{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    return backItem;
}

- (void)goBack_Swizzle
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackButton:(id)target action:(SEL)action{
    
    self.navigationItem.hidesBackButton = YES;
    _leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBackButton setFrame:CGRectMake(0, 0, 50, 44)];
    [_leftBackButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_leftBackButton setTitle:@"返回" forState:UIControlStateNormal];
    _leftBackButton.titleLabel.font = kFont17;
    [_leftBackButton.titleLabel sizeToFit];
    [_leftBackButton setTitleColor:[UIColor colorWithHexString:@"0xf89a38"] forState:UIControlStateNormal];
    [_leftBackButton setImage:[UIImage imageNamed:@"icon_navBack"] forState:UIControlStateNormal];
    [_leftBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_leftBackButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:_leftBackButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


#pragma mark loading..
- (void)showLoadingLayer{
    if(downloadView)
        return;
    
    CGRect appFrame = self.view.frame;
    CGFloat x = appFrame.size.width/2 - 20;
    CGFloat y = appFrame.size.height/2 - 40;
    
    downloadView = [[ACPDownloadView alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    downloadView.backgroundColor = kColorClear;
    downloadView.tintColor = [UIColor orangeColor];
    
    ACPIndeterminateGoogleLayer *layer = [ACPIndeterminateGoogleLayer new];
    [layer updateColor:[UIColor blueColor]];
    layer.layer.lineWidth = 2.;
    [downloadView setIndeterminateLayer:layer];
    [self.view addSubview:downloadView];
    [downloadView setIndicatorStatus:ACPDownloadStatusIndeterminate];
}

- (void)hideLoadingLayer{
    [downloadView removeFromSuperview];
    downloadView = nil;
}

- (void)showMBProgressHUD {
    [self hideMBProgressHUD];
    
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.color = kColorClear;
    _progressHUD.activityIndicatorColor = kColorTheme;
    
}

- (void)hideMBProgressHUD {
    if (self.progressHUD) {
        [self.progressHUD removeFromSuperview];
    }
}

- (void)showLoadingView {
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeCookieTerminator tintColor:kColorTheme];
    CGFloat width = self.view.bounds.size.width / 5.0f;
    CGFloat height = self.view.bounds.size.height / 7.0f;
    
    activityIndicatorView.frame = CGRectMake((kScreen_Width-width)/2, (kScreen_Height_Content-height)/2, width, height);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}

- (void)hideLoadingView {
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView = nil;
}


#pragma mark - 内部使用
//获取带badge的barButtonView的view
- (UIBarButtonItem *)barButtonViewWithBadgeWithText:(NSString*)text action:(SEL)action badgeString:(NSString*)badgeString;
{
    UIImage *imageLeft = [UIImage imageWithColor:[UIColor clearColor]];
    UIButton* aButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:imageLeft forState:UIControlStateNormal];
    aButton.frame=CGRectMake(0, 0 , 68, 30);
    [aButton setTitle:text forState:UIControlStateNormal];
    [aButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    if ([text isEqualToString:@"更多"]) {
        [aButton setTitleColor:kColorWhite forState:UIControlStateNormal];
    } else {
        [aButton setTitleColor:[UIColor colorWithHexString:@"0xFF871F"] forState:UIControlStateNormal];
    }
    
    [aButton setTitleColor:kColorWithRGBA(254, 114, 45, 0.2) forState:UIControlStateHighlighted];
    [aButton.titleLabel setFont:kFontB16];
    [aButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    CustomBadge *badge=[CustomBadge customBadgeWithString:badgeString
                                          withStringColor:[UIColor whiteColor]
                                           withInsetColor:[UIColor redColor]
                                           withBadgeFrame:YES
                                      withBadgeFrameColor:[UIColor whiteColor]
                                                withScale:0.8
                                              withShining:YES];
    badge.badgeShadowHide = YES;
    [badge setFrame:CGRectMake(aButton.width - badge.width + badge.width/3, -5, badge.frame.size.width, badge.frame.size.height)];
    badge.userInteractionEnabled=NO;
    
    [aButton addSubview:badge];
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    return aItem;
    
}

#pragma mark - 关闭键盘
- (void)hideKeyboard{
    [self.view endEditing:YES];
}

// 导航栏透明
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
