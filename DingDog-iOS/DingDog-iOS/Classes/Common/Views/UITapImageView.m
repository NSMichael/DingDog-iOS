//
//  UITapImageView.m
//  vdangkou
//
//  Created by 耿功发 on 15/3/10.
//  Copyright (c) 2015年 9tong. All rights reserved.
//

#import "UITapImageView.h"

@interface UITapImageView ()

@property (nonatomic, copy) void (^tapAction)(id);

@end

@implementation UITapImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)tap {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

- (void)addTapBlock:(void (^)(id))tapAction {
    self.tapAction = [tapAction copy];
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder tapBlock:(void(^)(id obj))tapAction {
    [self sd_setImageWithURL:url placeholderImage:placeholder];
    [self addTapBlock:tapAction];
}

@end
