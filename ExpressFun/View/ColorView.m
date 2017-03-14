//
//  ColorView.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/14.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ColorView.h"



@interface ColorView ()
  @property (strong, nonatomic) SureColorBlock        sureColorBlock;
@end

@implementation ColorView
{
    NSArray *colorArray;
}

- (instancetype)initWithSubView:(UIView *)subView sureBlock:(SureColorBlock)sureInputBlock
{
    self = [super init];
    if (self) {
        self.sureColorBlock = sureInputBlock;
        self.frame = CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 30);
        [subView addSubview:self];
        
        colorArray = @[[UIColor blackColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],[UIColor whiteColor]];
        
        [self initializeUserInterface];
    }
    return self;
}
- (void)initializeUserInterface{
    float buttonWidth = (SCREEN_WIDTH-100)/9;
    for (int i=1; i<=colorArray.count; i++) {
        UIButton *colorButton = [[UIButton alloc]initWithFrame:CGRectMake(10*i+buttonWidth*(i-1), 10, buttonWidth, 30)];
        colorButton.backgroundColor = colorArray[i-1];
        colorButton.tag = i;
        colorButton.layer.borderColor = [UIColor whiteColor].CGColor;
        colorButton.layer.borderWidth = 1;
        [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:colorButton];
    }
}


//选中颜色
- (void)chooseColor:(UIButton *)sender{
    if(self.sureColorBlock){
        self.sureColorBlock(colorArray[sender.tag-1]);
    }
    [self removeFromSuperview];
}

@end
