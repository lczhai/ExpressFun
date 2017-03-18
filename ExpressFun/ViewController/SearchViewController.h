//
//  SearchViewController.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/18.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NetWorkCallbackDelegate>

@property (nonatomic,copy) void (^block)(NSString *str,NSString *name);


//定义集合视图
@property  UICollectionView *_collectionView;
//定义网格布局
@property (nonatomic) UICollectionViewFlowLayout *fl;
//数据源
@property (nonatomic) NSMutableArray *searchSource;



@end
