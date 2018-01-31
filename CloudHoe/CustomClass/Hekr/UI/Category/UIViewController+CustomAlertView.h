//
//  UIViewController+CustomAlertView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/12.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CustomAlertView)

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback;

-(void)showAlertPromptWithTitle:(NSString *_Nonnull)title actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback;

-(void)showOneActionAlertWithTitle:(NSString *)title msg:(NSString *_Nonnull)msg actionText:(NSString *_Nonnull)actionText actionCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))callback;

-(void)showAlertNoTitleWithMsg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback;

-(void)showAlertNoMsgWithTitle:(NSString *_Nonnull)title leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback;

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg ensureText:(NSString *_Nonnull)text callback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))callback;

-(void)showAlertPromptWithMsg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback;

-(void)showAlert:(NSString *_Nullable)title msg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action))rigthCallback;

-(void)showAlertTextFieldWithTitle:(NSString *_Nullable)title msg:(NSString *_Nonnull)msg leftText:(NSString *_Nonnull)leftText leftCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))leftCallback rightText:(NSString *_Nonnull)rightText rigthCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action,UIAlertController * _Nonnull alert))rigthCallback  tfCallback:(void (^_Nonnull)(UITextField * _Nonnull textField))tfCallback;


@end
