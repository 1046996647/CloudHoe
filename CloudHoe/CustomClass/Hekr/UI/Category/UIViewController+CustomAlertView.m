//
//  UIViewController+CustomAlertView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/12.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "UIViewController+CustomAlertView.h"
#import "Tool.h"

@implementation UIViewController (CustomAlertView)

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback{
    [self showOneActionAlertWithTitle:@"提示" msg:msg actionText:@"我知道了" actionCallback:callback];
}

-(void)showAlertPromptWithTitle:(NSString *_Nonnull)title actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback{
    [self showOneActionAlertWithTitle:title msg:@"" actionText:@"我知道了" actionCallback:callback];
}

-(void)showOneActionAlertWithTitle:(NSString *)title msg:(NSString *_Nonnull)msg actionText:(NSString *_Nonnull)actionText actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(msg, nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(actionText, nil) style:UIAlertActionStyleDefault handler:callback];
    @try {
        [action setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertNoTitleWithMsg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback{
    
    [self showAlert:nil msg:msg leftText:leftText leftCallback:leftCallback rightText:rightText rigthCallback:rigthCallback];
}

-(void)showAlertNoMsgWithTitle:(NSString *_Nonnull)title leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback{
    
    [self showAlert:title msg:@"" leftText:leftText leftCallback:leftCallback rightText:rightText rigthCallback:rigthCallback];
}

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg ensureText:(NSString *_Nonnull)text callback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))callback{
    [self showAlert:@"温馨提示" msg:msg leftText:@"取消" leftCallback:nil rightText:text rigthCallback:callback];
}

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback{
    
    [self showAlert:@"温馨提示" msg:msg leftText:leftText leftCallback:leftCallback rightText:rightText rigthCallback:rigthCallback];
}

-(void)showAlert:(NSString *_Nullable)title msg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(msg, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(leftText, nil) style:UIAlertActionStyleDefault handler:leftCallback];
    @try {
        [left setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(rightText, nil) style:UIAlertActionStyleDefault handler:rigthCallback];
    @try {
        [right setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    [alert addAction:left];
    [alert addAction:right];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertTextFieldWithTitle:(NSString *_Nullable)title msg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action,UIAlertController * _Nonnull alert))rigthCallback  tfCallback:(void (^_Nonnull)(UITextField * _Nonnull textField))tfCallback{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(msg, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(leftText, nil) style:UIAlertActionStyleDefault handler:leftCallback];
    @try {
        [left setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(rightText, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        rigthCallback(action,alert);
    }];
    @try {
        [right setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    [alert addAction:left];
    [alert addAction:right];
    
    [alert addTextFieldWithConfigurationHandler:tfCallback];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
