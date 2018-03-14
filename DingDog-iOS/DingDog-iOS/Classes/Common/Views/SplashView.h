//
//  SplashView.h
//  vdangkou
//
//  Created by 耿功发 on 15/3/19.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashView : UIView

+ (instancetype)splashView;

- (void)startAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler;

///
- (void)beginAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler;

- (void)endAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler;

@end
