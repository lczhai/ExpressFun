//
//  ZFButton.m
//  ZFImagePicker
//
//  Created by 张锋 on 16/5/13.
//  Copyright © 2016年 张锋. All rights reserved.
//

#import "ZFSheetButton.h"

@implementation ZFSheetButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithWhite:0.950
                                             alpha:1.000];
}

// 务必将boundsExtension设置为70，如果boundsExtension<70可能会触发点击事件
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGFloat boundsExtension = 70.0f;
    CGRect outerBounds = CGRectInset(self.bounds, -1 * boundsExtension, -1 * boundsExtension);
    
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:self]);
    if(touchOutside) {
        BOOL previousTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:self]);
        if(!previousTouchInside) {
            // NSLog(@"Sending UIControlEventTouchDragOutside");
            self.backgroundColor = [UIColor whiteColor];
            [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
        }
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}

@end
