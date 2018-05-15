#import "LYPopNavigationController.h"
#import <objc/runtime.h>

@interface UIGestureRecognizer (Injection)
@end

@implementation UIGestureRecognizer (Injection)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(@"_shouldBegin"));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(ly_gestureShouldBegin));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (BOOL)ly_gestureShouldBegin {
    BOOL shouldBegin = [self ly_gestureShouldBegin];
    
    if (![self isMemberOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")]) return shouldBegin;
    
    UIResponder *nextViewController = self.view;
    while (![nextViewController isKindOfClass:UIViewController.class]) {
        nextViewController = nextViewController.nextResponder;
    }
    
    if ([nextViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *)nextViewController;
        
        if (navigationController.popHandler) {
            return navigationController.popHandler(navigationController.navigationBar, navigationController.topViewController.navigationItem);
        } else {
            if ([navigationController.topViewController respondsToSelector:@selector(navigationBar:shouldPopItem:)]) {
                
                return [(id<LYNavigationBackItemProtocol>)navigationController.topViewController navigationBar:navigationController.navigationBar shouldPopItem:navigationController.topViewController.navigationItem];
            }
        }
    }
    
    return shouldBegin;
}
@end

@implementation UINavigationController (Injection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Inject "-navigationBar:shouldPopItem:"
        Method originalMethod = class_getInstanceMethod(self, @selector(navigationBar:shouldPopItem:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(ly_navigationBar:shouldPopItem:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (BOOL)ly_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {

    BOOL shouldPopItemAfterPopViewController = [[self valueForKey:@"_isTransitioning"] boolValue];
    
    if (shouldPopItemAfterPopViewController) {
        return [self ly_navigationBar:navigationBar shouldPopItem:item];
    }
    
    if (self.popHandler) {
        BOOL shouldPopItemAfterPopViewController = self.popHandler(navigationBar, item);
        
        if (shouldPopItemAfterPopViewController) {
            return [self ly_navigationBar:navigationBar shouldPopItem:item];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [[self.navigationBar subviews] lastObject].alpha = 1;
        }];
        
        return shouldPopItemAfterPopViewController;
    } else {
        UIViewController *viewController = [self topViewController];
        
        if ([viewController respondsToSelector:@selector(navigationBar:shouldPopItem:)]) {
            
            BOOL shouldPopItemAfterPopViewController = [(id<LYNavigationBackItemProtocol>)viewController navigationBar:navigationBar shouldPopItem:item];
            
            if (shouldPopItemAfterPopViewController) {
                return [self ly_navigationBar:navigationBar shouldPopItem:item];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                [[self.navigationBar subviews] lastObject].alpha = 1;
            }];
            
            return shouldPopItemAfterPopViewController;
        }
    }
    
    return [self ly_navigationBar:navigationBar shouldPopItem:item];
}

#pragma mark - Getters&Setters
- (LYNavigationItemPopHandler)popHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPopHandler:(LYNavigationItemPopHandler)popHandler {
    objc_setAssociatedObject(self, @selector(popHandler), [popHandler copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
