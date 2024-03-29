//
//  EXPHeader.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/12.
//  Copyright © 2017年 翟留闯. All rights reserved.
//


#ifndef EXPHeader_h
#define EXPHeader_h



#endif /* EXPHeader_h */


//宏定义
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BaseUrl  @"https://backblog.me/api"
#define DateBaseChange @"DateBaseChange"
#define imgIds  @"localimgIds"


//头文件导入
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "RootViewController.h" //首页
#import "ProcessViewController.h"//图片处理页
#import "NetWorkCallbackDelegate.h"
#import "DataControl.h"
#import "InputView.h"
#import "UIImage+Category.h"
#import "UIView+Category.h"
#import "ShareExpressionViewController.h"//表情完成分享页
#import "AppDelegate.h"
#import "ExpressModel+CoreDataClass.h"
#import "SearchViewController.h"





//view
#import "ExpressCollectionView.h"
#import "ExpressCollectionCell.h"
#import "ColorView.h"//选择颜色




//组件
#import "AFNetworking.h" //afn
#import "MJRefresh.h" //loading
#import "SVProgressHUD.h" //toast
#import "UIImageView+WebCache.h"//img
#import "Masonry.h" //auto layout
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "ZFImagePicker.h"//弹出image视图
#import "ZFActionSheet.h"//照相机选择组件



//分享Api
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"
#import "XMShareView.h"



