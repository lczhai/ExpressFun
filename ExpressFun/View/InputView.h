//
//  inputView.h
//  PictureProcessing
//
//  Created by 翟留闯 on 2017/3/10.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
typedef void(^SureInputBlock)(NSString * text);

@interface InputView : UIView

- (instancetype)initWithSubView:(UIView *)subView sureBlock:(SureInputBlock)sureInputBlock;

@end
