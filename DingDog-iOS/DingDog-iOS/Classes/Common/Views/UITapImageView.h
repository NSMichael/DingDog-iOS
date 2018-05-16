//
//  UITapImageView.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/10.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView

- (void)addTapBlock:(void(^)(id obj))tapAction;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder tapBlock:(void(^)(id obj))tapAction;

@end
