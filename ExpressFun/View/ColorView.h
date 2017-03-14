//
//  ColorView.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/14.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureColorBlock)(UIColor * color);


@interface ColorView : UIView


- (instancetype)initWithSubView:(UIView *)subView sureBlock:(SureColorBlock)sureInputBlock;


@end
