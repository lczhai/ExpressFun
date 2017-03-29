//
//  ZFImagePicker.h
//  ZFImagePicker
//
//  Created by 张锋 on 16/5/9.
//  Copyright © 2016年 张锋. All rights reserved.
//  部分代码参考了http://www.cnblogs.com/kenshincui/p/4186022.html

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeLibrary = 0, // 图库
    SourceTypeAlbum,  // 最近保存的照片
    SourceTypeCamera, // 相机
};
/**
 *  照片选取结果回调
 *
 *  @param image 图片
 *  @param type  图片类型
 *  @param name  名称(本地时间戳+图片扩展名格式，注意这个参数并不是照片实际名称，只是为了方便用AFN上传图片方便之用)
 */
typedef void (^didPickImage) (UIImage *image,NSString *type,NSString *name);

@protocol ZFImagePickerDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param image 拍摄/获取到的图片
 *  @param type  拍摄/获取到的图片类型
 */
- (void)imagePickerDidFinishWithImage:(UIImage *)image andType:(NSString *)type;
@end

@interface ZFImagePicker : UIImagePickerController;
/**
 *  图片来源
 */
@property (nonatomic, assign) SourceType sType;
/**
 *  是否是人脸识别界面
 */
@property (nonatomic, assign) BOOL isFaceIdentify;
/**
 *  是否是身份证识别界面
 */
@property (nonatomic, assign) BOOL isCardIdentify;
/**
 *  是否允许编辑
 */
@property (nonatomic, assign) BOOL isEdit;
/**
 *  拍摄完成后是否保存
 */
@property (nonatomic, assign) BOOL isSave;
/**
 *  结果回调
 */
@property (nonatomic, copy) didPickImage pickImage;
/**
 *  设置代理
 */
@property (nonatomic, weak) id<ZFImagePickerDelegate> pickerDelegate;

@end
