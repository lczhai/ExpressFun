//
//  HotExpCollectionView.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/13.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "HotExpCollectionView.h"

@implementation HotExpCollectionView
@synthesize hotSource;//热门数据




- (instancetype)initWithFrame:(CGRect)frame withKeyword:(NSString *)keyword
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadData:keyword];
        
        
        
        
        
        //创建网格布局对象
        self.fl = [[UICollectionViewFlowLayout alloc]init];
        //设置滑动方向为竖直滑动
        self.fl.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        // 创建集合视图对象
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:self.fl];
        
        //注册cell
        [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:@"hot"];
        
        //定义每个UICollectionView 横向的间距
        self.fl.minimumLineSpacing = 40;
        //定义每个UICollectionView 的边距距
        self.fl.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);//上左下右
        
        
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


#pragma mark --加载数据
- (void)loadData:(NSString *)keyword{
    
    //requestCode:  0：手气不错  1：新品发售  2：热门搞笑  3：个人制造
        //携带参数发送网络请求
        [DataControl netGetRequestWithRequestCode:2 URL:@"/list/hot" parameters:nil callBackDelegate:self];
}


//网络请求成功回调
-(void)callBackWithData:(id)data requestCode:(int)requestCode{
    if(hotSource == nil){
        hotSource = [[NSMutableArray alloc]initWithArray:data];
    }else{
        [hotSource removeAllObjects];
        [hotSource addObjectsFromArray:data];
    }
    [self.collectionView reloadData];
}

//网络请求失败回调
- (void)callBackWithErrorCode:(int)code message:(NSString *)message innerError:(NSError *)error requestCode:(int)requestCode{
    [SVProgressHUD showErrorWithStatus:message];
}












#pragma mark --cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return hotSource.count;
}
#pragma mark --section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//初始化cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hot" forIndexPath:indexPath];
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *urlString =[[hotSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    #pragma clang diagnostic pop
    NSURL *imgUrl =[NSURL URLWithString:urlString] ;
    [cell.imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placehoder"]];
    cell.text.text = [hotSource[indexPath.row] objectForKey:@"name"];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width/2.3, self.collectionView.frame.size.height/3.5);
}


#pragma mark --选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _block(@"32132");
}



@end
