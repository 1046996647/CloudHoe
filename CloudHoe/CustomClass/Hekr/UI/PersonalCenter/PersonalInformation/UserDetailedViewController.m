//
//  UserDetailedViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserDetailedViewController.h"
#import <HekrAPI.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "UserNameViewController.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
#import "Tool.h"
#import "AgeView.h"
#import "UserImageViewController.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
//#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
@interface UserDetailedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserNameDelegate,UIActionSheetDelegate,AgeDelegata>



@end

@implementation UserDetailedViewController
{
    UITableView *_tableView;
    NSArray *_dataArr;
    UIImageView *_userLogo;
    UILabel *_nameLabel;
    UILabel *_ageLabel;
    //    NSString *_name;
    UISegmentedControl *_sex;
    NSString *_newName;
    AgeView *_ageView;
    UIView *_ageBgView;
    NSMutableArray *_priArr;
    NSString *_newAge;
    UIImagePickerController *_picker;
    NSMutableDictionary *_dataDic;
    NSString *_fileCDNUrl;
    BOOL _isToast;
    BOOL _isChangePhoto;
    BOOL _isChangeSex;
}

- (instancetype)initWithData:(NSMutableDictionary *)data{
    self = [super init];
    if (self) {
        _dataDic = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    _isChangeSex = YES;
    // Do any additional setup after loading the view.
    //     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.view.backgroundColor = getViewBackgroundColor();
    _priArr = [NSMutableArray new];
    for (NSInteger i = 1; i <= 100; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)i];
        [_priArr addObject:str];
    }
    _dataArr = @[NSLocalizedString(@"头像", nil),NSLocalizedString(@"用户名", nil),NSLocalizedString(@"性别", nil),NSLocalizedString(@"年龄", nil)];
    
    
    [self initNavView];
    [self createTableView];
//    [self refreshUserPage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UserDetail"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserDetail"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"个人信息" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];

}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)save{
//    [GiFHUD dismiss];
//    [GiFHUD showWithOverlay];
//    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
//    if (_isChangePhoto == YES) {
//        
//        NSData *imageData = UIImageJPEGRepresentation(_userLogo.image,0.8);
//        if ([imageData length]/1000 > 1024) {
//            [GiFHUD dismiss];
//            [self.view.window makeToast:NSLocalizedString(@"图片过大，请重新选择", nil) duration:1.0 position:@"center"];
//            return;
//        }
//
//        
//        [manager POST:@"http://user.openapi.hekr.me/user/file" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            DDLogInfo(@"[上传用户头像]：%@",responseObject);
//            _fileCDNUrl = responseObject[@"fileCDNUrl"];
//            [self postAction];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [GiFHUD dismiss];
//            if (_isToast == YES) {
//                return;
//            }
//            _isToast = YES;
//            [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.0];
//            [self.view.window makeToast:NSLocalizedString(@"上传失败，请重试", nil) duration:1.0 position:@"center"];
//        }];
//
//    }else{
//        [self postAction];
//    }
//    
//    
//    
//}

//- (void)postAction{
//    NSString *str;
//    if (_sex.selectedSegmentIndex == 0) {
//        str = @"MAN";
//    }else if(_sex.selectedSegmentIndex == 1){
//        str = @"WOMAN";
//    }else{
//        str = @"UNKNOWN";
//    }
//    
//    NSDictionary *dic;
//    
//    if (_fileCDNUrl) {
//        dic = @{@"firstName":@"",
//                @"lastName":_nameLabel.text,
//                @"gender" : str,
//                @"extraProperties":@{@"age":_ageLabel.text},
//                @"description":@"就是我",
//                @"avatarUrl":@{@"small":_fileCDNUrl},};
//    }else{
//       dic = @{@"firstName":@"",
//          @"lastName":_nameLabel.text,
//          @"gender" : str,
//          @"extraProperties":@{@"age":_ageLabel.text},
//          @"description":@"就是我"};
//    }
//    
//
//    
//    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
//    [manager PUT:@"http://user.openapi.hekr.me/user/profile"
//      parameters:dic
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             DDLogInfo(@"[上传用户信息]：%@",responseObject);
//             [GiFHUD dismiss];
//             [self.navigationController popViewControllerAnimated:YES];
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             [GiFHUD dismiss];
//             if ([APIError(error) isEqualToString:@"0"]) {
//                 [self.view.window makeToast:NSLocalizedString(@"保存失败", nil) duration:1.0 position:@"center"];
//             }else{
//                 [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
//                 
//             }
//            
//         }];
//    
//}


//- (void)getUserDataFormUrl{
//    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
//    [manager GET:@"http://user.openapi.hekr.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLogInfo(@"[获取用户信息]：%@",responseObject);
//        _dataDic = responseObject;
//        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"kHekrUserProfile"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [self refreshUserPage];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        _userLogo.image = [UIImage imageNamed:@"icon_user_default"];
//        _nameLabel.text = NSLocalizedString(@"游客", nil);
//        _ageLabel.text = @"21";
//        _sex.selectedSegmentIndex = 0;
//        
//        if((_dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"])){
//            [self refreshUserPage];
//        }
//        
//        if (_isToast == YES) {
//            return;
//        }
//        _isToast = YES;
//        [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.0];
//        [self.view.window makeToast:NSLocalizedString(@"信息拉取失败", nil) duration:1.0 position:@"center"];
//
//    }];
//}

//- (void)refreshUserPage{
//    if (_dataDic[@"avatarUrl"] && ![_dataDic[@"avatarUrl"] isKindOfClass:[NSNull class]]) {
//        NSString *smallimage = _dataDic[@"avatarUrl"][@"small"];
//        [_userLogo sd_setImageWithURL:[NSURL URLWithString:smallimage] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
//    }else{
//        _userLogo.image = [UIImage imageNamed:@"icon_user_default"];
//    }
//    
//    if (_dataDic[@"lastName"] && ![_dataDic[@"lastName"] isKindOfClass:[NSNull class]]) {
//        _nameLabel.text = _dataDic[@"lastName"];
//    }else{
//        _nameLabel.text = NSLocalizedString(@"游客", nil);
//    }
//    if (_dataDic[@"age"] && ![_dataDic[@"age"] isKindOfClass:[NSNull class]]) {
//        NSString *str = [NSString stringWithFormat:@"%@",_dataDic[@"age"]];
//        _ageLabel.text = str;
//    }else{
//        _ageLabel.text = @"21";
//    }
//    if (_dataDic[@"gender"] && ![_dataDic[@"gender"] isKindOfClass:[NSNull class]]) {
//        if ([_dataDic[@"gender"] isEqualToString:@"MAN"]) {
//            _sex.selectedSegmentIndex = 0;
//        }else if([_dataDic[@"gender"] isEqualToString:@"WOMAN"]){
//            _sex.selectedSegmentIndex = 1;
//        }
//    }
//}

- (void)toastDismiss{
    if (_isToast == YES) {
        _isToast = NO;
    }
}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 260)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    UIButton *button = [UIButton buttonWithTitle:@"退出登录" image:nil titleColor:rgb(80, 80, 82) frame:CGRectMake(0, CGRectGetMaxY(_tableView.frame)+Vrange(40), self.view.frame.size.width, 60) target:self action:@selector(outClick)];
//    button.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:button];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame), ScreenWidth, 0.5)];
//    label.backgroundColor = rgb(209, 209, 209);
//    [self.view addSubview:label];
    
}

- (void)showUserImage{
    UserImageViewController *userImgViewController = [[UserImageViewController alloc]initWithUserImg:_userLogo.image];
    [self presentViewController:userImgViewController animated:YES completion:nil];
}


//- (void)outClick{

//}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userdetailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userdetailCell"];
    }
    cell.backgroundColor = getCellBackgroundColor();
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.textColor = getTitledTextColor();
    cell.textLabel.font = getListTitleFont();
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger count = indexPath.row;
    switch (count) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _userLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 10, 60, 60)];
            _userLogo.layer.cornerRadius = 30;
            _userLogo.clipsToBounds = YES;
            _userLogo.userInteractionEnabled = YES;
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserImage)];
            [_userLogo addGestureRecognizer:tgr];
            if (_dataDic[@"avatarUrl"] && ![_dataDic[@"avatarUrl"] isKindOfClass:[NSNull class]]) {
                NSString *smallimage = _dataDic[@"avatarUrl"][@"small"];
                [_userLogo sd_setImageWithURL:[NSURL URLWithString:smallimage] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
            }else{
                _userLogo.image = [UIImage imageNamed:@"icon_user_default"];
            }
            [cell.contentView addSubview:_userLogo];
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogo.frame)-200, 10, 200, 40)];
            _nameLabel.textAlignment = NSTextAlignmentRight;
            _nameLabel.textColor = getDescriptiveTextColor();
            _nameLabel.font = getDescTitleFont();
            if (_dataDic[@"lastName"] && ![_dataDic[@"lastName"] isKindOfClass:[NSNull class]]) {
                _nameLabel.text = _dataDic[@"lastName"];
            }else{
                _nameLabel.text = NSLocalizedString(@"游客", nil);
            }

            [cell.contentView addSubview:_nameLabel];
        }
            break;
        case 2:
        {
            _sex = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"男",nil),NSLocalizedString(@"女",nil)]];
            _sex.frame = CGRectMake(CGRectGetMaxX(_userLogo.frame)-80, 15, 100, 30);
            _sex.layer.cornerRadius = 15;
            _sex.layer.borderWidth = 1;
            _sex.clipsToBounds = YES;
//            _sex.layer.borderColor = [[UIColor colorWithRed:2/255.0 green:153/255.0 blue:237/255.0 alpha:1.0] CGColor];
//            _sex.tintColor = [UIColor colorWithRed:2/255.0 green:153/255.0 blue:237/255.0 alpha:1.0];
            _sex.layer.borderColor = getButtonBackgroundColor().CGColor;
            _sex.tintColor = getButtonBackgroundColor();

            [_sex addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventValueChanged];
            if (_dataDic[@"gender"] && ![_dataDic[@"gender"] isKindOfClass:[NSNull class]]) {
                if ([_dataDic[@"gender"] isEqualToString:@"MAN"]) {
                    _sex.selectedSegmentIndex = 0;
                }else if([_dataDic[@"gender"] isEqualToString:@"WOMAN"]){
                    _sex.selectedSegmentIndex = 1;
                }
            }
            [cell.contentView addSubview:_sex];
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogo.frame)-200, 10, 200, 40)];
            _ageLabel.textAlignment = NSTextAlignmentRight;
            _ageLabel.textColor = getDescriptiveTextColor();
            _ageLabel.font = getDescTitleFont();
            if (_dataDic[@"age"] && ![_dataDic[@"age"] isKindOfClass:[NSNull class]]) {
                NSString *str = [NSString stringWithFormat:@"%@",_dataDic[@"age"]];
                _ageLabel.text = str;
            }else{
                _ageLabel.text = @"21";
            }
            [cell.contentView addSubview:_ageLabel];
        }
            break;
        default:
            break;
    }
    CGRect rect;
    if (indexPath.row == 0) {
        rect = CGRectMake(0, 80-0.5, ScreenWidth, 0.5);
    }else{
        rect = CGRectMake(0, 60-0.5, ScreenWidth, 0.5);
    }
    UILabel *downLabel = [[UILabel alloc]initWithFrame:rect];
    downLabel.backgroundColor = getCellLineColor();
    [cell.contentView addSubview:downLabel];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.row;
    switch (count) {
        case 0:
        {
            
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照",nil),NSLocalizedString(@"从手机相册选择",nil), nil];
            sheet.tag=100;
            [sheet showInView:self.view];
            
        }
            break;
        case 1:
        {
            UserNameViewController *username = [[UserNameViewController alloc]initWIthName:_nameLabel.text];
            username.delegate = self;
            [self.navigationController pushViewController:username animated:YES];
        }
            break;
        case 3:
        {
            
            _ageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            _ageBgView.backgroundColor = [UIColor blackColor];
            _ageBgView.alpha = 0;
            [self.view.window addSubview:_ageBgView];
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ageMove)];
            [_ageBgView addGestureRecognizer:tgr];
            
            _ageView = [[AgeView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, Vrange(370)+Vrange(80)) ageArray:_priArr labelString:_ageLabel.text];
            _ageView.backgroundColor = getCellBackgroundColor();
            _ageView.delegate = self;
            [self.view.window addSubview:_ageView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _ageBgView.alpha = 0.4;
                _ageView.transform = CGAffineTransformMakeTranslation(0, -(Vrange(370)+Vrange(80)));
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)ageMove{
    [UIView animateWithDuration:0.3 animations:^{
        _ageBgView.alpha = 0;
        _ageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _ageBgView = nil;
        [_ageBgView removeFromSuperview];
        _ageView = nil;
        [_ageView removeFromSuperview];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 60;
    }
}

- (void)changeSex:(UISegmentedControl *)btn{
    _sex.userInteractionEnabled = NO;
    NSString *str;
    if (btn.selectedSegmentIndex == 0) {
        str = @"MAN";
    }else{
        str = @"WOMAN";
    }
    [GiFHUD disMiss];
    [GiFHUD showWithOverlay:self.view];
    NSDictionary *dic = @{@"gender" : str};
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager PUT:@"http://user.openapi.hekr.me/user/profile"
      parameters:dic
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             DDLogInfo(@"[保存年龄]：%@",responseObject);
             [GiFHUD disMiss];
             [_dataDic setValue:str forKey:@"gender"];
             [self.delegate saveUserInfo:_dataDic];
             [self performSelector:@selector(willChangeSex) withObject:nil afterDelay:1.0];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [GiFHUD disMiss];
             [self performSelector:@selector(willChangeSex) withObject:nil afterDelay:1.0];
             if ([APIError(error) isEqualToString:@"0"]) {
                 [self.view.window makeToast:NSLocalizedString(@"保存失败", nil) duration:1.0 position:@"center"];
             }else{
                 [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                 
             }
             
         }];
}

- (void)willChangeSex{
    _sex.userInteractionEnabled = YES;
}

-(void)ageNum:(NSString *)str{
    [UIView animateWithDuration:0.3 animations:^{
        _ageBgView.alpha = 0;
        _ageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _ageLabel.text = str ;
        _ageBgView = nil;
        [_ageBgView removeFromSuperview];
        _ageView = nil;
        [_ageView removeFromSuperview];
        
        [GiFHUD disMiss];
        [GiFHUD showWithOverlay:self.view];
        NSDictionary *dic = @{@"extraProperties":@{@"age":str}};
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager PUT:@"http://user.openapi.hekr.me/user/profile"
          parameters:dic
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 DDLogInfo(@"[保存年龄]：%@",responseObject);
                 [GiFHUD disMiss];
                 [_dataDic setValue:str forKey:@"age"];
                 [self.delegate saveUserInfo:_dataDic];
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [GiFHUD disMiss];
                 if ([APIError(error) isEqualToString:@"0"]) {
                     [self.view.window makeToast:NSLocalizedString(@"保存失败", nil) duration:1.0 position:@"center"];
                 }else{
                     [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                     
                 }
                 
             }];
    }];
    
    
}


- (void)saveUserName:(NSString *)name{
    NSString *nameString = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _nameLabel.text = nameString;
    [GiFHUD disMiss];
    [GiFHUD showWithOverlay:self.view];
    NSDictionary *dic = @{@"lastName":nameString};
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager PUT:@"http://user.openapi.hekr.me/user/profile"
      parameters:dic
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             DDLogInfo(@"[保存用户名]：%@",responseObject);
             [GiFHUD disMiss];
             [_dataDic setValue:nameString forKey:@"lastName"];
             [self.delegate saveUserInfo:_dataDic];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [GiFHUD disMiss];
             if ([APIError(error) isEqualToString:@"0"]) {
                 [self.view.window makeToast:NSLocalizedString(@"保存失败", nil) duration:1.0 position:@"center"];
             }else{
                 [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                 
             }
             
         }];

}


#pragma mark - 相机相册delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _isChangePhoto = YES;
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _userLogo.image = image;
    [_picker dismissViewControllerAnimated:YES completion:nil];
    [GiFHUD disMiss];   
    [GiFHUD showWithOverlay:self.view];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    NSData *imageData = UIImageJPEGRepresentation(_userLogo.image,0.8);
    if ([imageData length]/1000 > 1024) {
        [GiFHUD disMiss];
        [self.view.window makeToast:NSLocalizedString(@"图片过大，请重新选择", nil) duration:1.0 position:@"center"];
        return;
    }
    
    [manager POST:@"http://user.openapi.hekr.me/user/file" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[上传用户头像]：%@",responseObject);
        _fileCDNUrl = responseObject[@"fileCDNUrl"];
        [self changePhoto];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD disMiss];
        if (_isToast == YES) {
            return;
        }
        _isToast = YES;
        [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.0];
        [self.view.window makeToast:NSLocalizedString(@"上传失败，请重试", nil) duration:1.0 position:@"center"];
    }];

}

- (void)changePhoto{
    NSDictionary *dic = @{@"avatarUrl":@{@"small":_fileCDNUrl},};
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager PUT:@"http://user.openapi.hekr.me/user/profile"
      parameters:dic
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             DDLogInfo(@"[保存用户头像]：%@",responseObject);
             [GiFHUD disMiss];
             [_dataDic setValue:@{@"small":_fileCDNUrl} forKey:@"avatarUrl"];
             [self.delegate saveUserInfo:_dataDic];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [GiFHUD disMiss];
             if ([APIError(error) isEqualToString:@"0"]) {
                 [self.view.window makeToast:NSLocalizedString(@"保存失败", nil) duration:1.0 position:@"center"];
             }else{
                 [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                 
             }
             
         }];
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

#pragma mark -delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==100) {
        if (buttonIndex==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                _picker = [[UIImagePickerController alloc]init];
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.delegate = self;
                _picker.allowsEditing = YES;
                [self presentViewController:_picker animated:YES completion:nil];
            }else{
                DDLogVerbose(@"没有摄像头！");
            }
        }
        else if (buttonIndex==1)
        {
            _picker = [[UIImagePickerController alloc]init];
            _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            [self presentViewController:_picker animated:YES completion:nil];
        }
    }
}

@end
