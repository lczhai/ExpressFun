//
//  ExpressCollectionView.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/13.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NetWorkCallbackDelegate,UIApplicationDelegate>

@property (nonatomic,copy) void (^block)(NSString *str,NSString *name);

//定义集合视图
@property  UICollectionView *collectionView;
//定义网格布局
@property (nonatomic) UICollectionViewFlowLayout *fl;
//数据源
@property (nonatomic) NSMutableArray *luckSource;
@property (nonatomic) NSMutableArray *newestSource;
@property (nonatomic) NSMutableArray *hotSource;
@property (nonatomic) NSMutableArray *mineSource;



- (instancetype)initWithFrame:(CGRect)frame withKeyword:(NSString *)keyword
;


@end
