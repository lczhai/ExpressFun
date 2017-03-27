//
//  CommonMarco.h
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

///  APP KEY
#define APP_KEY_WEIXIN            @"wx00145d7ef1189927"

#define APP_KEY_QQ                @"1106043198"  //表趣

#define APP_KEY_WEIBO             @"2752862027"//表趣

#define APP_KEY_WEIBO_RedirectURL @"http://www.sina.com"

///  分享图片
#define SHARE_IMG [UIImage imageNamed:@"singledog"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5

///  Common size
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size


/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;


#endif





//Share 接入步骤
//
//一，将定义好的ThreeParty文件夹拖入工程（包含微博，微信，qq的SDK）
//
//二，导入相关的FrameWork
//ImageIO.framework
//libz.tbd
//libsqlite3.tbd
//libstdc++.tbd
//CoreTelephony.framework
//CoreGraphics.framework
//SystemConfiguration.framework
//libiconv.tbd
//Security.framework
//
//三，导入Schem的白名单
//<key>LSApplicationQueriesSchemes</key>
//<array>
//<!-- 微信 URL Scheme 白名单-->
//<string>wechat</string>
//<string>weixin</string>
//
//<!-- 新浪微博 URL Scheme 白名单-->
//<string>sinaweibohd</string>
//<string>sinaweibo</string>
//<string>sinaweibosso</string>
//<string>weibosdk</string>
//<string>weibosdk2.5</string>
//
//<!-- QQ、Qzone URL Scheme 白名单-->
//<string>mqqapi</string>
//<string>mqq</string>
//<string>mqqOpensdkSSoLogin</string>
//<string>mqqconnect</string>
//<string>mqqopensdkdataline</string>
//<string>mqqopensdkgrouptribeshare</string>
//<string>mqqopensdkfriend</string>
//<string>mqqopensdkapi</string>
//<string>mqqopensdkapiV2</string>
//<string>mqqopensdkapiV3</string>
//<string>mqzoneopensdk</string>
//<string>wtloginmqq</string>
//<string>wtloginmqq2</string>
//<string>mqqwpa</string>
//<string>mqzone</string>
//<string>mqzonev2</string>
//<string>mqzoneshare</string>
//<string>wtloginqzone</string>
//<string>mqzonewx</string>
//<string>mqzoneopensdkapiV2</string>
//<string>mqzoneopensdkapi19</string>
//<string>mqzoneopensdkapi</string>
//<string>mqqbrowser</string>
//<string>mttbrowser</string>
//
//<!-- 人人 URL Scheme 白名单-->
//<string>renrenios</string>
//<string>renrenapi</string>
//<string>renren</string>
//<string>renreniphone</string>
//
//<!-- 来往 URL Scheme 白名单-->
//<string>laiwangsso</string>
//
//<!-- 易信 URL Scheme 白名单-->
//<string>yixin</string>
//<string>yixinopenapi</string>
//
//<!-- instagram URL Scheme 白名单-->
//<string>instagram</string>
//
//<!-- whatsapp URL Scheme 白名单-->
//<string>whatsapp</string>
//
//<!-- line URL Scheme 白名单-->
//<string>line</string>
//
//<!-- Facebook URL Scheme 白名单-->
//<string>fbapi</string>
//<string>fb-messenger-api</string>
//<string>fbauth2</string>
//<string>fbshareextension</string>
//</array>
//
//四：修改other link flag
//修改为   -ObjC
//
//五：Appdelegate 初始化SDK及响应回调方法
//#import "WXApi.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WeiboSDK.h"
//遵守协议  <TencentSessionDelegate,WeiboSDKDelegate,WXApiDelegate>
////初始化第三方库
//- (void)init3rdParty
//{
//    [WXApi registerApp:@"wx00145d7ef1189927"];
//    
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:@"4109726756"];
//    
//    TencentOAuth *tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1105241898" andDelegate:self];
//    
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([[url absoluteString] hasPrefix:@"tencent"]) {
//        
//        return [TencentOAuth HandleOpenURL:url];
//        
//    }else if([[url absoluteString] hasPrefix:@"wb"]){
//        
//        return [WeiboSDK handleOpenURL:url delegate:self];
//        
//    }
//    else if([[url absoluteString] hasPrefix:@"WX"]){
//        
//        return [WXApi handleOpenURL:url delegate:self];
//        
//    }
//    
//    return NO;
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    if ([WXApi handleOpenURL:url delegate:self]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    else if([WeiboSDK handleOpenURL:url delegate:self])
//    {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }
//    else
//    {
//        return [TencentOAuth HandleOpenURL:url];
//    }
//}
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    
//}
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    
//}
//
//
//
//
//
//六，开始分享
//1.在目标页面添加分享按钮，事件如下（请先创建XMShareView）
//self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
//
////title
//self.shareView.shareTitle = NSLocalizedString(pwdLabel.text, nil);
////内容
//self.shareView.shareText = NSLocalizedString(linkLabel.text, nil);
////链接
//self.shareView.shareUrl = @"test.3dker.cn/share/detail?share_id=573d3718727c22280093167d";
//[self.view addSubview:self.shareView];
//
//2 .单独分享到，微信好友，朋友圈及微博
//（1）.到微博（请导入头文件）
//XMShareWeiboUtil *util = [XMShareWeiboUtil sharedInstance];
//util.shareTitle = self.shareTitle;
//util.shareText = self.shareText;
//util.shareUrl = self.shareUrl;
//[util shareToWeibo];
//
//（2）到微信好友（请导入头文件）
//XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
//util.shareTitle = self.shareTitle;
//util.shareText = self.shareText;
//util.shareUrl = self.shareUrl;
//[util shareToWeixinSession];
//
//（3）到微信朋友圈（请导入头文件）
//XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
//util.shareTitle = self.shareTitle;
//util.shareText = self.shareText;
//util.shareUrl = self.shareUrl;
//
//[util shareToWeixinTimeline];
//
//
//


