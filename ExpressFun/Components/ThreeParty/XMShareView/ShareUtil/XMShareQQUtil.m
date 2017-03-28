//
//  XMShareQQUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareQQUtil.h"

@implementation XMShareQQUtil



- (void)shareToQQ
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_SESSION];
    
}

- (void)shareToQzone
{
    
    [self shareToQQBase:SHARE_QQ_TYPE_QZONE];
    
}

- (void)shareToQQBase:(SHARE_QQ_TYPE)type
{
    
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:APP_KEY_QQ andDelegate:self];
    
//    NSString *utf8String = self.shareUrl;
//    NSString *theTitle = self.shareTitle;
//    NSString *description = self.shareText;
    NSData *imageData = UIImageJPEGRepresentation(self.shareImage, SHARE_IMG_COMPRESSION_QUALITY);
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                               previewImageData:imageData
                                                          title:nil
                                                   description :nil];
    
    
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    if (type == SHARE_QQ_TYPE_SESSION) {
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
    }else{
        
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }
}


+ (instancetype)sharedInstance
{
    
    static XMShareQQUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareQQUtil alloc] init];
        
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
