//
//  AddBotanyVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/8.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "AddBotanyVC.h"
#import "UIImage+UIImageExt.h"


@interface AddBotanyVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITextView *tv;
@property(nonatomic,strong) UITextField *tf;
@property(nonatomic,strong) UILabel *remind;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,strong) NSString *imgurl;
@end

@implementation AddBotanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 124+44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _tf = [UITextField textFieldWithframe:CGRectMake(22, 0, kScreenWidth-20-20, 44) placeholder:@"植物名称" font:[UIFont systemFontOfSize:16] leftView:nil backgroundColor:@"#FFFFFF"];
    [_tf setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_tf setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
//    _password.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_tf];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _tf.bottom, kScreenWidth, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [view addSubview:line];

    
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(20, line.bottom, kScreenWidth-40, 124-28)];
    _tv.font = [UIFont systemFontOfSize:16];
    [view addSubview:_tv];
    _tv.delegate = self;
    //    _tv.backgroundColor = [UIColor redColor];
    
    _remind = [UILabel labelWithframe:CGRectMake(3, 10, 200, 17) text:@"植物介绍" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
    [_tv addSubview:_remind];
    
    UIButton *addBtn = [UIButton buttonWithframe:CGRectMake(20, view.bottom+20, 78, 78) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group" selected:nil];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(headImgAction) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;


    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, addBtn.bottom+20, kScreenWidth-40, 44) text:@"保存" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delAction
{
    [self.addBtn setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
    self.delBtn.hidden = YES;
    self.imgurl = nil;
    
}

//右上角按钮点击事件
//保存
- (void)okAction
{
    if (_tv.text.length == 0) {
        [self.view makeToast:@"植物介绍"];
        return;
    }
    
    //键盘收起
    [_tv resignFirstResponder];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic  setValue:_tf.text forKey:@"plantname"];
    [paramDic  setValue:self.imgurl forKey:@"plantimg"];
    [paramDic  setValue:_tv.text forKey:@"introduce"];

    [AFNetworking_RequestData requestMethodPOSTUrl:Add dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];

        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}


- (void)headImgAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 创建相册控制器
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        // 设置代理对象
        pickerController.delegate = self;
        // 设置选择后的图片可以被编辑
        //            pickerController.allowsEditing=YES;
        
        // 判断当前设备是否有摄像头
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            
            // 设置类型
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        
        // 跳转页面，该行代码必须放最后
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 创建相册控制器
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        // 设置代理对象
        pickerController.delegate = self;
        // 设置选择后的图片可以被编辑
        //            pickerController.allowsEditing=YES;
        // 设置类型
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置为静态图像类型
        pickerController.mediaTypes = @[@"public.image"];
        // 跳转到相册页面
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //通过判断picker的sourceType，如果是拍照则保存到相册去
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    NSData *data = [UIImage imageOrientation:img];
    
    [AFNetworking_RequestData uploadImageUrl:Uploadimg dic:paramDic data:data name:@"headimg" Succed:^(id responseObject) {
        
        [self.addBtn setImage:img forState:UIControlStateNormal];
        self.delBtn.hidden = NO;
        self.imgurl = responseObject[@"data"][@"headimg"];
        
        //            [self.userBtn sd_setImageWithURL:[NSURL URLWithString:responseObject[@"img"]] forState:UIControlStateNormal];
        
        
    } failure:^(NSError *error) {
        
    }];
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

/**
 内容发生改变编辑 自定义文本框placeholder
 有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可
 @param textView textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length < 1) {
        self.remind.hidden = NO;
    }
    else {
        self.remind.hidden = YES;
        
    }
    
}

@end
