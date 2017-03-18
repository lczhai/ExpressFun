//
//  ProcessViewController.h
//  PictureProcessing
//
//  Created by 翟留闯 on 2017/3/10.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^HandleImageBlock)(UIImage * newImage);


@interface ProcessViewController : UIViewController

//- (instancetype)initWithSourceImage:(UIImage *)image handleImageBlock:(HandleImageBlock)imageBlock;
@property (strong, nonatomic) UIImage                   * sourceImage;//原图片
@property (strong,nonatomic)  NSString                  * sourceImageName;//图片原名称
@property (strong,nonatomic)  NSString                  *imageId;//数据库中的图片id

- (instancetype)initWithSourceImage:(UIImage *)image;


@end
