//
//  CXMProgressView.m
//  MBProgressHud_Demo
//
//  Created by 陈小明 on 2016/12/12.
//  Copyright © 2016年 bitauto. All rights reserved.
//

#import "CXMProgressView.h"
#import "AppDelegate.h"

#define HUD_TAG 30023

@interface CXMProgressView()

@property (nonatomic, strong) MBProgressHUD *hudInsteracne;
@end


@implementation CXMProgressView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)makeCustomHUD{
    [self.class dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *showView;
        
        if([[self.class getCurrentViewController] isKindOfClass:[UIWindow class]]) {
            showView = (UIWindow*)[self.class getCurrentViewController];
        } else {
            showView = [self.class getCurrentViewController].view;
        }
        
        self.hudInsteracne = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        self.hudInsteracne.label.numberOfLines = 0;
    });
}

- (void)showHudWithAnmiationText:(NSString*)anmiationText detailLabel:(NSString*)detailLabel{
    
    if(self.hudInsteracne == nil){
        [self makeCustomHUD];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hudInsteracne != nil){
            self.hudInsteracne.label.text = anmiationText;
            self.hudInsteracne.detailsLabel.text = detailLabel;
        }
    });
}

- (void)hiddenInstanceHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.class dismissLoading];
        [self.hudInsteracne hideAnimated:YES];
    });
}

+ (void)showTextWithCircle:(NSString *)aText{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *showView;
        
        if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
            showView = (UIWindow*)[self getCurrentViewController];
        }else{
            showView = [self getCurrentViewController].view;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.label.numberOfLines = 0;
        hud.label.text = aText;
    });
}

+ (void)showText:(NSString *)aText{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       UIView *showView;
        
       if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
           showView = (UIWindow*)[self getCurrentViewController];
       }else{
           showView = [self getCurrentViewController].view;
       }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    });
}

+ (void)dismissLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [MBProgressHUD hideHUDForView:app.window animated:YES];
        
        UIView *showView;
        
        if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
            showView = (UIWindow*)[self getCurrentViewController];
            [MBProgressHUD hideHUDForView:showView animated:YES];
        }else{
            showView = [self getCurrentViewController].view;
            [MBProgressHUD hideHUDForView:showView animated:YES];
            NSArray *subArr = [self getCurrentViewController].view.subviews;
            
            for(UIView *view in subArr){
                  if([view isKindOfClass:[MBProgressHUD class]]){
                      [MBProgressHUD hideHUDForView:view animated:YES];
                  }
              }
        }
    });
}

+ (void)showErrorText:(NSString *)aText{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       UIView *showView;
        
       if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
           showView = (UIWindow*)[self getCurrentViewController];
       }else{
           showView = [self getCurrentViewController].view;
       }
        
        UIImage *image = [[UIImage imageNamed:@"progressView_error@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView =complateView;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    });
}

+ (void)showSuccessText:(NSString *)aText{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *showView;
        
        if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
            showView = (UIWindow*)[self getCurrentViewController];
        }else{
            showView = [self getCurrentViewController].view;
        }
        
        UIImage *image = [[UIImage imageNamed:@"progressView_success@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView =complateView;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    });
}

+ (NSTimeInterval)displayDurationForString:(NSString*)string{
    
    if(string && string.length > 0){
        if(((float)string.length*0.06 + 0.5) > 2 && ((float)string.length*0.06 + 0.5) < 3.5){
            return (float)string.length*0.06 + 0.5;
        }
        
        return 2.0; // MAX((float)string.length*0.06 + 0.5, 2.0);
    }

    return 1;
}

+ (void)showText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *showView;
        
        if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
            showView = (UIWindow*)[self getCurrentViewController];
        }else{
            showView = [self getCurrentViewController].view;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        
        NSTimeInterval time = [self displayDurationForString:aText];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if(complete == nil){
                    return ;
                }
                complete();
            });
        });
    });
}

+ (void)showErrorText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *showView;
        
        if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
            showView = (UIWindow*)[self getCurrentViewController];
        }else{
            showView = [self getCurrentViewController].view;
        }
        
        UIImage *image = [[UIImage imageNamed:@"progressView_error@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = complateView;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        
        NSTimeInterval time = [self displayDurationForString:aText];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                if(complete ==nil){
                    return ;
                }
                complete();
            });
        });
    });
}

+ (void)showSuccessText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       UIView *showView;
        
       if([[self getCurrentViewController] isKindOfClass:[UIWindow class]]){
           showView = (UIWindow*)[self getCurrentViewController];
       }else{
           showView = [self getCurrentViewController].view;
       }
        
        UIImage *image = [[UIImage imageNamed:@"progressView_success@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView =complateView;
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        NSTimeInterval time = [self displayDurationForString:aText];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                if(complete ==nil){
                    return ;
                }
                complete();
            });
        });
    });
}

+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
   
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
       
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
   
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }

    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
    }else if([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

@end
