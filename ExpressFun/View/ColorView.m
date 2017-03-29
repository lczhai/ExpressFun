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

//初始化选择颜色视图
- (instancetype)initWithSubView:(UIView *)subView sureBlock:(SureColorBlock)sureInputBlock
{
    self = [super init];
    if (self) {
        self.sureColorBlock = sureInputBlock;
        self.frame = CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 80);
        [subView addSubview:self];
        colorArray = @[[UIColor blackColor],[UIColor grayColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],[UIColor whiteColor]];
        
        [self initializeUserInterface];
    }
    return self;
}

//初始化并声明颜色按钮
- (void)initializeUserInterface{
    float buttonWidth = (SCREEN_WIDTH-90)/(colorArray.count/2);
    for (int i=0; i<2; i++) {
        
        
        for(int j=1;j<=colorArray.count/2;j++){
            UIButton *colorButton = [[UIButton alloc]initWithFrame:CGRectMake(15*j+buttonWidth*(j-1), 10+40*i, buttonWidth, 30)];
            colorButton.backgroundColor = colorArray[(j-1)+(i*(colorArray.count/2))];
            colorButton.tag = j+(i*(colorArray.count/2)) ;
            colorButton.layer.borderColor = [UIColor whiteColor].CGColor;
            colorButton.layer.borderWidth = 1;
            colorButton.layer.masksToBounds = YES;
            colorButton.layer.cornerRadius = 15;
            [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:colorButton];
        }
        
        
        
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
