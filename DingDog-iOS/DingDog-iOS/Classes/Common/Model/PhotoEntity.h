//
//  
//  AutomaticCoder
//  图片
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PhotoEntity : MTLModel<MTLJSONSerializing,NSCopying>

//server端的定义
@property (nonatomic,strong) NSNumber *order;
@property (nonatomic,strong) NSNumber *resourceId;  //资源id , 例如：如果是 type=1（店铺），那么resourceId就表示店铺的StoreId,如果type=2,resourceId就表示产品的ProductId,
@property (nonatomic,strong) NSNumber *pictureID;   //图片编号
@property (nonatomic,strong) NSString *url;         //连接
@property (nonatomic,strong) NSNumber *type;        //类型(1:店铺;2:产品,3:产品-色卡,1000:马龙)
@property (nonatomic,strong) NSString *title;       //图片名称
@property (nonatomic,strong) NSNumber *sequence;    //排序规则


//本地增加，用于在编辑时复用本对象；
@property (nonatomic,assign) BOOL       isLocal;
@property (nonatomic,strong) NSString  *imgfilePath;


//自定义内容,用于在添加到上传队列时使用
@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) NSString *resKey;


-(instancetype)initWithLocalImg:(UIImage*)img photoName:(NSString*)mPhotoName;

-(instancetype)initWithServerImgUrl:(NSString*)imgUrl photoName:(NSString*)mPhotoName;

+ (instancetype)photoEntityWithImage:(UIImage *)image;

@end
