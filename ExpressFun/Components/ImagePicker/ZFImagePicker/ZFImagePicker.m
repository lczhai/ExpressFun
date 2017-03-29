//
//  ZFImagePicker.m
//  ZFImagePicker
//
//  Created by 张锋 on 16/5/9.
//  Copyright © 2016年 张锋. All rights reserved.
//

#import "ZFImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ZFImagePicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation ZFImagePicker

- (void)alertWithMessage:(NSString *)message :(void(^)())confirm
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm();
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createSubviews
{
    self.delegate = self;
	
	
    if (self.isEdit) {
        self.allowsEditing = YES;//设置图片可以被编辑
    }else{
        self.allowsEditing = NO;
    }
    
    if (self.sType == SourceTypeCamera) {
        // 相机
        // 是否支持拍照
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        // 摄像头是否可用
        BOOL isRearSupport = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront];
        if (!isRearSupport || !isCameraSupport) {
            [self alertWithMessage:@"无法使用摄像头，请检测摄像头是否可用或者有权限访问！" :^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        
        
        //判断是否是真机
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            return;
        }else
        {
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        
        
    }else if (self.sType == SourceTypeLibrary) {
        // 是否有权限访问相册
        BOOL isSystemSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        if (!isSystemSupport) {
            [self alertWithMessage:@"无法访问相册，请设置程序访问相册权限！" :^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
       }
	   else if (self.sType == SourceTypeAlbum) {
        // 是否有权限访问相册
        BOOL isSystemSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        if (!isSystemSupport) {
            [self alertWithMessage:@"无法访问相册，请设置程序访问相册权限！" :^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    if (self.isFaceIdentify || self.isCardIdentify) {
        //创建叠加层
        NSString *imageName = self.isCardIdentify? @"card.png" : @"header.png";
        UIImage *overLayImag=[UIImage imageNamed:imageName];
        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
        if (self.isCardIdentify) {
            //身份证
            bgImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-380)/2, 200, 300);
        }else {
            //人脸
            bgImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-230)/2, ([UIScreen mainScreen].bounds.size.height-440)/2, 230, 364);
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        [self.view addSubview:bgImageView];
    }
	
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image;
    NSString *type;
    NSString *name;
    NSString *extension;
    
    if (self.isEdit) {

        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (self.isSave) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    type = [self typeForImageData:data];
    
    NSArray *array = [type componentsSeparatedByString:@"/"];
    if ([array count]==2) {
        extension = [array lastObject];
    }else{
        extension = @"jpeg";
    }
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    name = [NSString stringWithFormat:@"/%.f.%@", timeStamp,extension];
    
    if (self.pickImage) {
        self.pickImage(image, type, name);
    }
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(imagePickerDidFinishWithImage:andType:)]) {
        [self.pickerDelegate imagePickerDidFinishWithImage:image andType:type];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/** 获取图片类型 */
- (NSString *)typeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            
        case 0x89:
            return @"image/png";
            
        case 0x47:
            return @"image/gif";
            
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}

@end
