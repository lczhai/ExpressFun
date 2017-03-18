//
//  ExpressCollectionCell.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/13.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ExpressCollectionCell.h"

@implementation ExpressCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        //加阴影--任海丽编辑
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset=CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity=0.8;//阴影透明度，默认0
        self.layer.shadowRadius=4;//阴影半径，默认3


    
        
        self.imgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame)-22, CGRectGetWidth(self.frame)-10, 20)];
        self.text.backgroundColor = [UIColor grayColor];
        self.text.alpha = 0.7;
        self.text.layer.cornerRadius = 2;
        self.text.layer.masksToBounds = YES;
        self.text.textColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
    }
    return self;
}



@end
