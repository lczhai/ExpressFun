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

- (instancetype)initWithSourceImage:(UIImage *)image;


@end
