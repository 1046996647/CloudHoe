//
//  SuggestViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SuggestViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "Tool.h"
#import "GiFHUD.h"
#import "TZImagePickerController.h"
#import <SHAlertViewBlocks.h>
#import <Photos/Photos.h>
#import "SuggestImageCell.h"
#import "ImagePreviewViewController.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface SuggestViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SuggestImageCellDelegate, ImagePreviewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UITextField *phoneText;
@property (nonatomic, strong)UILabel *placeLabel;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *imageUrl;
@property (nonatomic, assign)NSInteger imageNum;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, assign)BOOL isToast;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    _imageArray = [NSMutableArray new];
    _imageUrl = [NSMutableArray new];
    _imageNum = 0;
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTableView];
//    [self createPostButton];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [MobClick beginLogPageView:@"Suggest"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Suggest"];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"反馈建议", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"反馈建议" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CoverViewRectMake style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = [self createTableHeaderView];
    _tableView.tableFooterView = [self createtableFooterView];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableTapAction)];
    [_tableView addGestureRecognizer:tgr];
    [self.view addSubview:_tableView];
}

- (UIView *)createTableHeaderView{
    CGSize size = [self sizeWithText:NSLocalizedString(@"Hekr的每一个进步，离不开您的反馈", nil) maxSize:CGSizeMake(self.view.frame.size.width - 10, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, Vrange(240))];
    _textView.backgroundColor = getViewBackgroundColor();
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    _textView.textColor = getInputTextColor();
    _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width, size.height)];
    _placeLabel.numberOfLines = 0;
    _placeLabel.text = NSLocalizedString(@"Hekr的每一个进步，离不开您的反馈", nil);
    _placeLabel.font = [UIFont systemFontOfSize:15];
    _placeLabel.textColor = getPlaceholderTextColor();
    [_textView addSubview:_placeLabel];
    return _textView;
}

- (UIView *)createtableFooterView{
    CGFloat gap = (ScreenWidth - Hrange(710))/2;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Vrange(180)+31)];
    view.backgroundColor = getViewBackgroundColor();
    UILabel *label1 = [self createLabel:CGRectMake(0, 0, Width, 1)];
    label1.alpha = 0.5;
    [view addSubview:label1];
    
    _phoneText = [self createTextField:CGRectMake(gap, 0.5, Vrange(710), Vrange(100))];
    _phoneText.keyboardType = UIKeyboardTypeDecimalPad;
    [view addSubview:_phoneText];
    
    UILabel *label2 = [self createLabel:CGRectMake(0, CGRectGetMaxY(_phoneText.frame), Width, 1)];
    label2.alpha = 0.5;
    [view addSubview:label2];
    
    UIButton *btn = [self createPostButton:CGRectMake(0, 0, sHrange(320), sVrange(40))];
    btn.center = CGPointMake(Width/2, CGRectGetMaxY(label2.frame)+30+sVrange(20));
    [view addSubview:btn];
    
    return view;
}

- (UITextField *)createTextField:(CGRect)rect{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.textColor = getInputTextColor();
    textField.backgroundColor = getViewBackgroundColor();
    textField.placeholder = NSLocalizedString(@"联系电话选填，便于我们与您联系", nil);
    [textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [textField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = [UIFont systemFontOfSize:15];
    return textField;
}

- (UILabel *)createLabel:(CGRect)rect{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor = getCellLineColor();
    return label;
}

- (UIButton *)createPostButton:(CGRect)rect{
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"提交", nil) frame:rect target:self action:@selector(suggestAction)];
//    button.frame = rect;
//    [button setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.backgroundColor = rgb(6, 164, 240);
//    button.layer.cornerRadius = Vrange(80)/2;
//    [button addTarget:self action:@selector(suggestAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [_placeLabel setHidden:NO];
    }else{
        [_placeLabel setHidden:YES];
    }
}

- (void)suggestAction{
    [self resignfirstResponder];
    if (_textView.text.length > 0) {
        [GiFHUD showWithOverlay];
        if (_imageArray.count == 0) {
            [self suggestPost];
        }else{
            [self imagePost:_imageNum];
        }
    }else{
        if (_isToast == YES) {
            return;
        }
        _isToast = YES;
        [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.0];
        [self.view.window makeToast:NSLocalizedString(@"请输入您宝贵的意见", nil) duration:1.0 position:@"center"];
    }
}
- (void)toastDismiss{
    if (_isToast == YES) {
        _isToast = NO;
    }
}

- (void)imagePost:(NSInteger)num{
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    [manager POST:@"http://user.openapi.hekr.me/user/file" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_imageArray[num], 0.4) name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[意见反馈上传图片]：%@",responseObject);
        [_imageUrl addObject:responseObject[@"fileCDNUrl"]];
        if (num == _imageArray.count - 1) {
            [self suggestPost];
        }else{
            _imageNum ++;
            [self imagePost:_imageNum];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (num == _imageArray.count - 1) {
            [self suggestPost];
        }else{
            _imageNum ++;
            [self imagePost:_imageNum];
        }
    }];
}

- (void)suggestPost{
    NSString *content = [NSString stringWithFormat:@"%@ Tel:%@",_textView.text,_phoneText.text];
    NSString *imageUrl = [_imageUrl componentsJoinedByString:@","];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    [manager POST:@"http://console.openapi.hekr.me/external/feedback" parameters:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"],@"title":@"蜂鸟iOS反馈",@"content":content,@"images":imageUrl} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[意见反馈]：%@",responseObject);
        [GiFHUD dismiss];
        DDLogVerbose(@"%@",responseObject);
        
        [self showAlertPromptWithTitle:@"感谢您的宝贵意见" actionCallback:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        if ([APIError(error) isEqualToString:@"0"]) {
            [self showAlertPromptWithTitle:@"提交失败"  actionCallback:nil];
        }else{
            [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
        }
        
    }];

}



- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"无法使用相机",nil) message:NSLocalizedString(@"请在iPhone的”设置-隐私-相机“中允许访问相机",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"设置",nil), nil];
//        [alert show];
        
        [self showAlert:@"无法使用相机" msg:NSLocalizedString(@"请在iPhone的”设置-隐私-相机“中允许访问相机",nil) leftText:@"取消" leftCallback:nil rightText:@"设置" rigthCallback:^(UIAlertAction * _Nonnull action) {
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
            }
        }];
        
    } else { // 调用相机
        if (_imagePickerVc == nil) {
            _imagePickerVc = [UIImagePickerController new];
            _imagePickerVc.delegate = self;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

//打开相机
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_imageArray addObject:image];
        [_tableView reloadData];
    }
}

//打开相册
- (void)addImg{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照",nil),NSLocalizedString(@"从手机相册选择",nil), nil];
//    [sheet showInView:self.view];
    
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *left = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    @try {
        [left setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    [alert addAction:left];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushTZImageView];
    }];
    @try {
        [right setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
    [alert addAction:right];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    @try {
        [cancel setValue:getButtonBackgroundColor() forKey:@"_titleTextColor"];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)pushTZImageView{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 - _imageArray.count delegate:nil];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [_imageArray addObjectsFromArray:photos];
        [_tableView reloadData];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//预览图片
- (void)imgPreview:(NSInteger)count{
    ImagePreviewViewController *previewVc = [[ImagePreviewViewController alloc]initWithImage:_imageArray selectCount:count];
    previewVc.delegata = self;
    [self.navigationController pushViewController:previewVc animated:YES];
}

- (void)deleteImage{
    [_tableView reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImageView];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
        }
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuggestImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestCell"];
    if (cell == nil) {
        cell = [[SuggestImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"suggestCell"];
    }else{
        for (UIImageView *img in cell.contentView.subviews) {
            if ([img isKindOfClass:[UIImageView class]]) {
                [img removeFromSuperview];
            }

        }
    }
    cell.delegata = self;
    cell.backgroundColor = getViewBackgroundColor();
    [cell setImageArray:_imageArray];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat gap = 10;
    CGFloat height = (Width - 5 * gap) / 4;
    if (_imageArray.count < 4) {
        return height + 2 * gap;
    }else if (_imageArray.count<8){
        return height * 2 + 3 * gap;
    }else{
        return height * 3 + 4 * gap;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resignfirstResponder];
}

- (void)tableTapAction{
    [self resignfirstResponder];
}

- (void)resignfirstResponder{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    if ([_phoneText isFirstResponder]) {
        [_phoneText resignFirstResponder];
    }
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
