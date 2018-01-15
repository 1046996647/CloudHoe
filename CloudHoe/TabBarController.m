//
//  TabBarController.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "CDTabBar.h"

#import "HomeVC.h"
#import "GardenVC.h"
#import "DynamicStateVC.h"
#import "HoeFriendVC.h"

#import "LGPhoto.h"
#import "ReleaseDynamicVC.h"


@interface TabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>



@end

@implementation TabBarController

+ (void)initialize{
    /**
     * 设置 TabBarItem的字体大小与颜色，可参考UIButton
     */
    
    NSMutableDictionary * tabDic=[NSMutableDictionary dictionary];
    tabDic[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    tabDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary * selectedTabDic=[NSMutableDictionary dictionary];
    selectedTabDic[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    selectedTabDic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#50DBD1"];
    
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:tabDic forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:selectedTabDic forState:(UIControlStateSelected)];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"#FEFEFE"];
    //    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    //    [self.tabBar setShadowImage:[[UIImage alloc]init]];
//    self.delegate = self;
    
    [self setChildViewController:[[HomeVC alloc]init] Title:@"首页" Image:@"shouye-1" SelectedImage:@"shouye-2"];
    [self setChildViewController:[[GardenVC alloc]init] Title:@"花园" Image:@"huayuan1" SelectedImage:@"huayuan2"];
    
    [self setChildViewController:[[DynamicStateVC alloc]init] Title:@"动态" Image:@"动态-1" SelectedImage:@"动态-2"];
    
    [self setChildViewController:[[HoeFriendVC alloc]init] Title:@"锄友" Image:@"wode1" SelectedImage:@"wode2"];
    
    CDTabBar *tabBar = [[CDTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar setDidMiddBtn:^{
        
        ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
        // 拍照最多个数
        cameraVC.maxCount = 1;
        // 单拍
        cameraVC.cameraType = ZLCameraSingle;
        cameraVC.callback = ^(NSArray *cameras){
            
            if (cameras.count > 0) {
                
                //在这里得到拍照结果
                //数组元素是ZLCamera对象
                ZLCamera *canamerPhoto = cameras[0];
                UIImage *image = canamerPhoto.photoImage;
                
                ReleaseDynamicVC *vc = [[ReleaseDynamicVC alloc] init];
                vc.title = @"发布";
                vc.img = image;
                
                NavigationController *nav = [[NavigationController alloc]initWithRootViewController:vc];
                
                [self presentViewController:nav animated:YES completion:nil];
                
            }

        };
        [cameraVC showPickerVc:self];

    }];
    
    
    
}


/**
 *  初始化控制器
 */
- (void)setChildViewController:(UIViewController*)childVC Title:(NSString*)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage
{
    /**
     *  添加 tabBarItem 上的文字和图片
     */
    childVC.title=title;
    childVC.tabBarItem.image=[UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:childVC];
    //    nav.delegate = self;
    [self addChildViewController:nav];
    
}

@end
