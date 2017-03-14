//
//  XMShareWechatUtil.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareWechatUtil.h"
#import "WXApi.h"

@implementation XMShareWechatUtil


- (void)shareToWeixinSession
{
    
    [self shareToWeixinBase:WXSceneSession];
    
}

- (void)shareToWeixinTimeline
{
    
    [self shareToWeixinBase:WXSceneTimeline];
    
}

- (void)shareToWeixinBase:(enum WXScene)scene
{
    
    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = self.shareTitle;
//    message.description = self.shareText;
    [message setThumbImage:self.shareImage];
//    [message setThumbImage:SHARE_IMG];

    WXImageObject *imgObject = [WXImageObject object];
    imgObject.imageData =  UIImagePNGRepresentation(self.shareImage);
    message.mediaObject = imgObject;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    
    
    [WXApi sendReq:req];
    
}


+ (instancetype)sharedInstance
{
    
    static XMShareWechatUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[XMShareWechatUtil alloc] init];
        
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
