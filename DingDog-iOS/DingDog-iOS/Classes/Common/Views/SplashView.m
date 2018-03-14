//
//  SplashView.m
//  vdangkou
//  闪屏(启动屏之后的画面) 
//  Created by 耿功发 on 15/3/19.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "SplashView.h"

@interface SplashView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation SplashView

+ (instancetype)splashView {
    return [[self alloc] initWithBackgroundImage:[UIImage imageNamed:@"StartImage"]];
}

- (instancetype)initWithBackgroundImage:(UIImage *)bgImage {
    self = [super initWithFrame:kScreen_Bounds];
    if (self) {
        
        self.backgroundColor = kColorWhite;
        
        _bgImageView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        _bgImageView.alpha = 0.0;
        _bgImageView.image = bgImage;
        [self addSubview:_bgImageView];
        
    }
    return self;
}

- (void)startAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler {
    [kKeyWindow addSubview:self];
    [kKeyWindow bringSubviewToFront:self];
    _bgImageView.alpha = 0.0;
    self.alpha = 1.0;
    
    @weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        @strongify(self);
        self.bgImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            @strongify(self);
            self.bgImageView.alpha = 0.0;
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self removeFromSuperview];
            if (completionHandler) {
                completionHandler(self);
            }
        }];
        
    }];
}

//=====
- (void)beginAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler {
    
    /*
    [kKeyWindow addSubview:self];
    [kKeyWindow bringSubviewToFront:self];
    
    
    _bgImageView.alpha = 0.0;
    self.alpha = 1.0;
    
    @weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        @strongify(self);
        self.bgImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler(self);
        }
    }];
     */
    if (completionHandler) {
        completionHandler(self);
    }
}


- (void)endAnimationWithCompletionBlock:(void(^)(SplashView * splashView))completionHandler {
    [kKeyWindow bringSubviewToFront:self];
    self.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        self.bgImageView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeFromSuperview];
        if (completionHandler) {
            completionHandler(self);
        }
    }];
    
    
}
@end
