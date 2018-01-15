//
//  SettingVC.m
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/7/19.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "NavigationController.h"
//#import "registerVC.h"
#import "UIImage+UIImageExt.h"
#import "InfoChangeController.h"
#import "BRPickerView.h"
#import "NSStringExt.h"
#import "SexVC.h"


@interface PersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *leftDataList;
@property(nonatomic,strong) NSArray *rightDataList;
@property(nonatomic,strong) UIImageView *headImg;


@end

@implementation PersonalCenterVC

- (UITableView *)tableView
{
    if (!_tableView) {
        //列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshNotification" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftDataList = @[@[@""],
                          @[@"昵称",@"性别",@"生日"],
                          @[@"标签"],
                          @[@"简介"],
                          ];
    


    [self.view addSubview:self.tableView];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.person = [InfoCache unarchiveObjectWithFile:Person];
    
    //    if (self.person.name.length == 0) {
    //        self.person.name = @"未设置";
    //    }
    //    if (self.person.birthday.length == 0) {
    //        self.person.birthday = @"请选择生日日期";
    //    }
    self.rightDataList = @[@[@"更换头像"],
                           @[self.person.nikename,self.person.sex,self.person.birthday],
                           @[self.person.tab],
                           @[self.person.introduce],
                           ];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.leftDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftDataList[section] count];
//    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 56;

    }

    if (indexPath.section == 3) {
        
        CGSize size = [NSString textHeight:self.person.introduce font:SystemFont(14) width:kScreenWidth-100];
        if (size.height+30>46) {
            return size.height+30;

        }
        
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取单元格
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {

        [self headImgAction];

    }
    if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            InfoChangeController *vc = [[InfoChangeController alloc] init];
            vc.title = @"昵称";
            vc.text = cell.detailTextLabel.text;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
        if (indexPath.row == 1) {
            SexVC *vc = [[SexVC alloc] init];
            vc.title = @"修改性别";
            vc.sex = self.person.sex;
            [self.navigationController pushViewController:vc animated:YES];
            
        }

        if (indexPath.row == 2) {
    
            NSString *birth = nil;
//            if (![cell.detailTextLabel.text isEqualToString:@"请选择生日日期"]) {
//                birth = cell.detailTextLabel.text;
//            }
            birth = cell.detailTextLabel.text;
            [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:birth minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:NO resultBlock:^(NSString *selectValue) {
    
                NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
                [paramDic  setObject:selectValue forKey:@"birthday"];
    
                [AFNetworking_RequestData requestMethodPOSTUrl:SetUserInfo dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
    
                    self.person.birthday = selectValue;
                    [InfoCache archiveObject:self.person toFile:Person];
                    
                    self.rightDataList = @[@[@"更换头像"],
                                           @[self.person.nikename,self.person.sex,self.person.birthday],
                                           @[self.person.tab],
                                           @[self.person.introduce],
                                           ];
                    [_tableView reloadData];
        
    
                } failure:^(NSError *error) {
    
                    NSLog(@"%@",error);
    
    
                }];
            }];
    
        }

    }
    
    if (indexPath.section == 2) {
        InfoChangeController *vc = [[InfoChangeController alloc] init];
        vc.title = @"标签";
        vc.text = cell.detailTextLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    if (indexPath.section == 3) {
        InfoChangeController *vc = [[InfoChangeController alloc] init];
        vc.title = @"简介";
        vc.text = cell.detailTextLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        if (indexPath.section != 2) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        }

    }
    
    if (indexPath.row == 0) {
        
        if (!self.headImg) {
            UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, (56-45)/2, 45, 45)];
            headImg.layer.cornerRadius = headImg.height/2.0;
            headImg.layer.masksToBounds = YES;
            [cell.contentView addSubview:headImg];
            self.headImg = headImg;
//            headImg.backgroundColor = [UIColor redColor];
        }
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.person.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];

    }
    

    cell.textLabel.text = self.leftDataList[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.detailTextLabel.text = self.rightDataList[indexPath.section][indexPath.row];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
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
    
    [AFNetworking_RequestData uploadImageUrl:HeadImg dic:paramDic data:data Succed:^(id responseObject) {
        
        self.person.headimg = responseObject[@"data"][@"headimg"];
        [InfoCache archiveObject:self.person toFile:Person];
        
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"headimg"]]];
        
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




@end
