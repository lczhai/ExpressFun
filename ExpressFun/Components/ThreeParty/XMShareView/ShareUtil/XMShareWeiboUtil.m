//
//  XMShareWeiboUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareWeiboUtil.h"
#import "AppDelegate.h"

@implementation XMShareWeiboUtil

- (void)shareToWeibo
{
    
    [self shareToWeiboBase];
    
}

- (void)shareToWeiboBase
{
    
    WBMessageObject *message = [WBMessageObject message];
//    message.text = self.description;

    
    
    // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
    


    
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = APP_KEY_WEIBO_RedirectURL;
//    authRequest.scope = @"all";
//    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//    [WeiboSDK sendRequest:request];
    
    
    

    
}

- (WBMessageObject *)messageToShare
{
    
    WBMessageObject *message = [WBMessageObject message];
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = self.shareTitle;
//    webpage.description = self.shareText;
//    //  可改为自定义图片
//    webpage.thumbnailData = UIImageJPEGRepresentation(SHARE_IMG, SHARE_IMG_COMPRESSION_QUALITY);
//    webpage.webpageUrl = self.shareUrl;
//    
//    message.mediaObject = webpage;
//    return message;
    
    
    
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = self.shareTitle;
//    webpage.description = self.shareText;
//    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//    if ([[self.shareUrl substringToIndex:3] isEqualToString:@"http"]) {
//        webpage.webpageUrl = self.shareUrl;
//        
//        
//        message.text = [NSString stringWithFormat:@"%@,  %@",self.shareTitle,self.shareUrl];
//    }
//    else
//    {
//        webpage.webpageUrl = [NSString stringWithFormat:@"http://%@",self.shareUrl];
//        message.text = [NSString stringWithFormat:@"%@,  %@",self.shareTitle,webpage.webpageUrl];
//
//    }
//    message.mediaObject = webpage;
    
    
    
//    message.text = @"为什么漫威有特殊的选角技巧？ -26个回答，1221人关注，http://www.zhihu.com/question/32765767 (想看更多？下载知乎App:http://weibo.com/p/100404711598)";
//    
    
    
        if ([[self.shareUrl substringToIndex:3] isEqualToString:@"http"]) {
    
    
            message.text = [NSString stringWithFormat:@"%@,  %@",self.shareTitle,self.shareUrl];
        }
        else
        {
            message.text = [NSString stringWithFormat:@"分享一个文件 ：%@,  %@   (想了解更多？请到3d客:http://3dker.cn)",self.shareTitle,[NSString stringWithFormat:@"http://%@",self.shareUrl]];
    
        }

    
    
    return message;
    
    
}


+ (instancetype)sharedInstance
{
    
    static XMShareWeiboUtil* util;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareWeiboUtil alloc] init];
        
    });
    return util;
    
}

- (instancetype)init
{
    
    static id obj=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        obj = [super init];
        if (obj) {
            
        }
        
    });
    self=obj;
    return self;
    
}

@end
