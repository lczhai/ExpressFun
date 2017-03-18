//
//  ShareExpressionViewController.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/14.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ShareExpressionViewController.h"

@interface ShareExpressionViewController ()

@end

@implementation ShareExpressionViewController
{
    UIImageView *showImageView;
    XMShareView *shareView;
}
@synthesize completeImage;




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保存/分享";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self initUi];//初始化试图
    
}

- (void)initUi{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:@selector(goHomePage:)];
    
    showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.15, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
    showImageView.image = completeImage;
    showImageView.contentMode = UIViewContentModeRedraw;
    //    showImageView.layer.cornerRadius = SCREEN_WIDTH/4;
    showImageView.layer.cornerRadius = 25;
    showImageView.layer.masksToBounds = YES;
    showImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    showImageView.layer.borderWidth = 2;
    [self.view addSubview:showImageView];
    
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(showImageView.frame)+30, SCREEN_WIDTH*0.6, 50)];
    [saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor orangeColor];
    saveButton.layer.cornerRadius = saveButton.frame.size.height/2;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveToLocal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(saveButton.frame)+20, SCREEN_WIDTH*0.6, 50)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor orangeColor];
    shareButton.layer.cornerRadius = saveButton.frame.size.height/2;
    shareButton.layer.masksToBounds = YES;
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareToFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    
    
    
    
    
}

#pragma mark --分享给朋友
- (void)shareToFriends:(id)sender{
    //1.在目标页面添加分享按钮，事件如下（请先创建XMShareView）
    shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
    shareView.image = completeImage;
    [self.view addSubview:shareView];
}



#pragma mark --保存到本地
- (void)saveToLocal:(id)sender
{
    [self loadImageFinished:completeImage];
}

#pragma mark -- 加载处理完成的图片
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

#pragma mark --将完成的图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [SVProgressHUD showErrorWithStatus:@"保存失败啦~~~~(>_<)~~~~"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"已放入相册啦(*^__^*)"];
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


#pragma mark --回到首页
- (void)goHomePage:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
