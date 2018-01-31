//
//  ReleaseDynamicVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ReleaseDynamicVC.h"
#import "UIImage+UIImageExt.h"


@interface ReleaseDynamicVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITextView *tv;
@property(nonatomic,strong) UILabel *remind;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,strong) NSString *imgurl;


@end

@implementation ReleaseDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 124)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(20, 14, kScreenWidth-40, view.height-28)];
    _tv.font = [UIFont systemFontOfSize:16];
    [view addSubview:_tv];
    _tv.delegate = self;
//    _tv.backgroundColor = [UIColor redColor];
    
    _remind = [UILabel labelWithframe:CGRectMake(3, 10, 200, 17) text:@"请输入内容" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
    [_tv addSubview:_remind];
    
    UIButton *addBtn = [UIButton buttonWithframe:CGRectMake(20, view.bottom+20, 78, 78) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group" selected:nil];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(headImgAction) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    
    UIButton *delBtn = [UIButton buttonWithframe:CGRectMake(addBtn.right-15, addBtn.top-15, 30, 30) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group-1" selected:nil];
    [self.view addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    delBtn.hidden = YES;
    self.delBtn = delBtn;
    
    if (self.img) {
        [addBtn setImage:self.img forState:UIControlStateNormal];
        delBtn.hidden = NO;

    }
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, addBtn.bottom+20, kScreenWidth-40, 44) text:@"确定上传" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)delAction
{
    [self.addBtn setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
    self.delBtn.hidden = YES;
    self.imgurl = nil;
    
}

//右上角按钮点击事件
//保存
- (void)saveAction
{
    
    [self.view endEditing:YES];
    
    if (_tv.text.length == 0) {
        [self.view makeToast:@"请输入内容"];
        return;
    }
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic  setValue:_tv.text forKey:@"text"];
    [paramDic  setValue:self.imgurl forKey:@"imgurl"];

    [AFNetworking_RequestData requestMethodPOSTUrl:Addblog dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        if (self.img) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }
        else {
            [self.navigationController popViewControllerAnimated:YES];

        }
        
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
