//
//  UIDefinition.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/9.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

// 尺寸
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_IPHONE_X (kScreen_Width == 375.f && kScreen_Height == 812.f ? YES : NO)

#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))

#define HEIGHT_BUTTON_BOTTOM    44 //界面底部按钮的高度
#define HEIGHT_NAVIGATION_BAR   44
// 状态栏高度
//#define HEIGHT_STATUSBAR     (IOS7_SDK_AVAILABLE?20:0)
#define HEIGHT_STATUSBAR    (kDevice_IPHONE_X ? 44.f : 20.f)

#define HEIGHT_TABBAR       (kDevice_IPHONE_X ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin            (kDevice_IPHONE_X ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight   (kDevice_IPHONE_X ? 88.f : 64.f)

// 显示主题内容界面高度
#define kScreen_Height_Content  [UIScreen mainScreen].bounds.size.height - HEIGHT_NAVIGATION_BAR - HEIGHT_STATUSBAR

#define kPurchaseListPageSize   20

#define kPaddingLeftWidth 15.0
#define kMySegmentControl_Height 44.0

// 字体
#define  kBackButtonFontSize 16
#define  kNavTitleFontSize 19
// 在cell中的字体
#define  kFontTitleInCell  kFont13
#define  kFontDetailInCell  kFont12
// 在一般界面中的字体
#define  kFontTitleMain     kFont15
#define  kFontTitleSub      kFont14
#define  kFontDetailInfo    kFont13
#define  kFontTips          kFont12

#define kFontTableCellTitle kFont14
#define kFontTableCellValue kFont14

#define kFont10     [UIFont systemFontOfSize:10]
#define kFont11     [UIFont systemFontOfSize:11]
#define kFont12     [UIFont systemFontOfSize:12]
#define kFont13     [UIFont systemFontOfSize:13]
#define kFont14     [UIFont systemFontOfSize:14]
#define kFont15     [UIFont systemFontOfSize:15]
#define kFont16     [UIFont systemFontOfSize:16]
#define kFont17     [UIFont systemFontOfSize:17]
#define kFont18     [UIFont systemFontOfSize:18]
#define kFont20     [UIFont systemFontOfSize:20]

#define kFontB10    [UIFont boldSystemFontOfSize:10]
#define kFontB11    [UIFont boldSystemFontOfSize:11]
#define kFontB12    [UIFont boldSystemFontOfSize:12]
#define kFontB13    [UIFont boldSystemFontOfSize:13]
#define kFontB14    [UIFont boldSystemFontOfSize:14]
#define kFontB15    [UIFont boldSystemFontOfSize:15]
#define kFontB16    [UIFont boldSystemFontOfSize:16]
#define kFontB17    [UIFont boldSystemFontOfSize:17]
#define kFontB18    [UIFont boldSystemFontOfSize:18]
#define kFontB20    [UIFont boldSystemFontOfSize:20]

#define kImageWithURLWidthHeight(url, width, height)  [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d/format/jpg", url, width, height]

// 颜色
#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]
#define kColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:a]
#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

// 主旋律色调
// 以前的主题测是0xf99934 2016.03.15 修改成0xFF871F
#define kColorTheme                 [UIColor colorWithHexString:@"0x1E90FF" andAlpha:1.]
#define kColorTheme_Selected        [UIColor colorWithHexString:@"0xfca447" andAlpha:1.]
// 主旋律的灰色，用于分割线之类的地方
#define kColorTheme_lightGray       [UIColor colorWithRed:210/255. green:210/255. blue:210/255. alpha:1.0]
#define kColorTheme_lightGray_01    [UIColor colorWithHexString:@"0xc8c8c8"]
// 主题橙
#define kColorOrange               [UIColor colorWithHexString:@"0xF96D36" andAlpha:1.]

#define kColorSeparatorDark         [UIColor colorWithHexString:@"0xd7d3d1" andAlpha:1.]
#define kColorSeparatorLight        [UIColor colorWithHexString:@"0xebe9e8" andAlpha:1.]

#define kColorSeparatorInWhiteLight        [UIColor colorWithHexString:@"0xE9E9E9" andAlpha:1.]

//#define kColorViewBG                [UIColor colorWithRed:241./255. green:240./255. blue:238./255. alpha:1.0]

#define kColorViewBG                [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]
#define kColorTableBG               [UIColor colorWithRed:241./255. green:240./255. blue:238./255. alpha:1.0]
#define kColorTableSectionBg        [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]
#define kColorTableCellTitle        [UIColor colorWithRed:38/255. green:31/255. blue:28/255. alpha:1.0]
#define kColorTableCellValue        [UIColor colorWithRed:136/255. green:133/255. blue:131/255. alpha:1.0]
#define kColorOfLine                [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0]
#define kColorInvalid               [UIColor colorWithRed:215/255. green:211/255. blue:209/255. alpha:1.0]

#define kAppColorRed [UIColor colorWithRed:203/255. green:0/255. blue:15/255. alpha:1]

#define kColorClear [UIColor clearColor]
#define kColorBlack10 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define kColorWhite [UIColor whiteColor]
#define kColorWhite90 [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]

// 字体颜色
#define kColorFont                  [UIColor colorWithHexString:@"0x282828"]
#define kColorFontHelp1             [UIColor colorWithHexString:@"0x8F8D8C"]

#define kColorBlack                 [UIColor colorWithHexString:@"0x202020"]
#define kColorGray                  [UIColor colorWithHexString:@"0x888888"]

// 链接颜色
#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x1E90FF"].CGColor}
#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[kColorWithRGB(200, 100, 30) CGColor]}

// 图像
#define JPEGQULITY 0.7
#define IMG_PLACEHOLDER_PRODUCT     [UIImage imageNamed:@"list_image_default"]
#define IMG_PLACEHOLDER_SUPPLIER    [UIImage imageNamed:@"list_image_default"]
#define IMG_PLACEHOLDER_STORE       [UIImage imageNamed:@"store"]
#define IMG_PLACEHOLDER_SCROLLVIEW  [UIImage imageNamed:@"scroll_image_default"]
#define IMG_PLACEHOLDER_CONTACT     [UIImage imageNamed:@"avatar_default"]

#define IMAGE_PLACEHOLDER_AVATAR    [UIImage imageNamed:@"avatar_default"]
