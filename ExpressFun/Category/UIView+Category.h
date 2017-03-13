//
//  InputView.h
//  ZYHandleImage
//
//  Created by liuchuang on 17/3/10.
//  Copyright © 2017年 liuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

//界面转换图片（截图）

-(UIImage *)convertViewToImage;

- (UIImage *)screenshotWithRect:(CGRect)rect;

- (UIImage *)screenshot;

@end
