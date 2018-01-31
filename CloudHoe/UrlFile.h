//
//  UrlFile.h
//  Recruitment
//
//  Created by ZhangWeiLiang on 2017/9/13.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#ifndef UrlFile_h
#define UrlFile_h

// 服务器
#define BaseUrl  @"http://106.14.218.31:3322/index.php"

// 本地
//#define BaseUrl  @"http://192.168.2.114/index.php"

// 登录
#define Login  [NSString stringWithFormat:@"%@/api/User/Login",BaseUrl]

// 短信验证码
#define GetCode  [NSString stringWithFormat:@"%@/api/User/getCode",BaseUrl]

// 获取用户信息
#define GetUserInfo  [NSString stringWithFormat:@"%@/api/User/getUserInfo",BaseUrl]

// 用户基本信息设置
#define SetUserInfo  [NSString stringWithFormat:@"%@/api/User/editdata",BaseUrl]

// 用户头像修改与上传
#define HeadImg  [NSString stringWithFormat:@"%@/api/User/HeadImg",BaseUrl]

// 用户发布（个人）日志
#define Addblog  [NSString stringWithFormat:@"%@/api/User/addblog",BaseUrl]

// 添加植物
#define Add  [NSString stringWithFormat:@"%@/api/Garden/add",BaseUrl]


// 当前用户更多日志 查询
#define Getmylog  [NSString stringWithFormat:@"%@/api/Log/getmylog",BaseUrl]

// 日志评论
#define Comment  [NSString stringWithFormat:@"%@/api/Log/comment",BaseUrl]

// 评论详情页
#define Comdetails  [NSString stringWithFormat:@"%@/api/Log/comdetails",BaseUrl]

// 日志评论 添加
#define Addcom  [NSString stringWithFormat:@"%@/api/Log/addcom",BaseUrl]

// 评论下的 评论添加（回复）
#define Comadd  [NSString stringWithFormat:@"%@/api/Log/comadd",BaseUrl]

// 日志点赞
#define Clike  [NSString stringWithFormat:@"%@/api/Log/clike",BaseUrl]

// 用户上传日志图片
#define Uploadimg  [NSString stringWithFormat:@"%@/api/User/uploadimg",BaseUrl]

// 热门动态
#define GetHotblog  [NSString stringWithFormat:@"%@/api/Log/getlog",BaseUrl]

// 用户花园
#define Plants  [NSString stringWithFormat:@"%@/api/Garden/plants",BaseUrl]

// 获取当前用户所有植物
#define Getplant  [NSString stringWithFormat:@"%@/api/Garden/getplant",BaseUrl]

// 添加（关注好友）
#define Addfriend  [NSString stringWithFormat:@"%@/api/User/addfriend",BaseUrl]

// 获取互相关注好友列表
#define Myfriends  [NSString stringWithFormat:@"%@/api/User/myfriends",BaseUrl]

// 待确认关注（未关注）用户列表
#define Addlist  [NSString stringWithFormat:@"%@/api/User/addlist",BaseUrl]

// 忽略未关注人
#define Stop  [NSString stringWithFormat:@"%@/api/User/stop",BaseUrl]


// 添加（关注好友）
#define Addfriend  [NSString stringWithFormat:@"%@/api/User/addfriend",BaseUrl]

// 删除互相关注好友
#define Delmyfriends  [NSString stringWithFormat:@"%@/api/User/delmyfriends",BaseUrl]




#endif /* UrlFile_h */
