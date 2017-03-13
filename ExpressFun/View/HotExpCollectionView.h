//
//  HotExpCollectionView.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/13.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HotExpCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NetWorkCallbackDelegate>


@property (nonatomic,copy) void (^block)(NSString *str);

//定义集合视图
@property  UICollectionView *collectionView;
//定义网格布局
@property (nonatomic) UICollectionViewFlowLayout *fl;
//数据源
@property (nonatomic) NSMutableArray *hotSource;



- (instancetype)initWithFrame:(CGRect)frame withKeyword:(NSString *)keyword
;


@end
