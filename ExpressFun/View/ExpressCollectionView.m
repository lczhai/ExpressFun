//
//  ExpressCollectionView.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/13.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ExpressCollectionView.h"

@implementation ExpressCollectionView
{
    NSString *pageName;
    int pageSize;
    
    int hotPageIndex;
    int newestPageIndex;
}
@synthesize newestSource;//最新数据
@synthesize hotSource;//热门数据
@synthesize luckSource;//手气数据
@synthesize mineSource;//我的数据




- (instancetype)initWithFrame:(CGRect)frame withKeyword:(NSString *)keyword
{
    self = [super initWithFrame:frame];
    if (self) {
        pageName = keyword;
        pageSize = 12;
        hotPageIndex = 0;
        newestPageIndex = 0;
        
        //初始化
        mineSource = [[NSMutableArray alloc]init];
        
        [self loadData:keyword];
        
       

        
        
        //创建网格布局对象
        self.fl = [[UICollectionViewFlowLayout alloc]init];
        //设置滑动方向为竖直滑动
        self.fl.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        // 创建集合视图对象
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:self.fl];
        
        //注册cell
        if([keyword isEqualToString:@"goodluck"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData:keyword];
            }];
        }else if ([keyword isEqualToString:@"recommend"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                newestPageIndex = 0;
                [hotSource removeAllObjects];
                [self loadData:keyword];
            }];
            _collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
                hotPageIndex = newestPageIndex + pageSize;
                [self loadData:keyword];
            }];
        }
        else if ([keyword isEqualToString:@"hot"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                hotPageIndex= 0;
                [hotSource removeAllObjects];
                [self loadData:keyword];
            }];
            _collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
                hotPageIndex = hotPageIndex + pageSize;
                [self loadData:keyword];
            }];
        }
        else if([keyword isEqualToString:@"mine"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
        }
        
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
    
    if([keyword isEqualToString:@"goodluck"]){
        [DataControl netGetRequestWithRequestCode:0 URL:@"/goodluck" parameters:nil callBackDelegate:self];
    }else if ([keyword isEqualToString:@"recommend"]){
        NSString *urlString = [NSString stringWithFormat:@"/list/recommend?begin=%d&offset=%d",newestPageIndex,pageSize];
        [DataControl netGetRequestWithRequestCode:2 URL:urlString parameters:nil callBackDelegate:self];
    }
    else if ([keyword isEqualToString:@"hot"]){
        NSLog(@"热门数据");
        NSString *urlString = [NSString stringWithFormat:@"/list/hot?begin=%d&offset=%d",hotPageIndex,pageSize];
        [DataControl netGetRequestWithRequestCode:2 URL:urlString parameters:nil callBackDelegate:self];
    }
    else{
        NSLog(@"我的制作");
    }
}


//网络请求成功回调
-(void)callBackWithData:(id)data requestCode:(int)requestCode{
    if(requestCode == 0){
         luckSource == nil ? luckSource = [[NSMutableArray alloc]init] : [luckSource removeAllObjects];
        [luckSource addObjectsFromArray:data];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];

    }else if (requestCode == 1){
        newestSource == nil ? newestSource = [[NSMutableArray alloc]init] : [newestSource removeAllObjects];
        [newestSource addObjectsFromArray:data];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }else if (requestCode == 2){
        hotSource == nil ? hotSource = [[NSMutableArray alloc]initWithArray:data] : [hotSource addObjectsFromArray:data];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }else{
        NSLog(@"");
    }
}

//网络请求失败回调
- (void)callBackWithErrorCode:(int)code message:(NSString *)message innerError:(NSError *)error requestCode:(int)requestCode{
    [SVProgressHUD showErrorWithStatus:message];
}



























#pragma mark --cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([pageName isEqualToString:@"goodluck"]){
        return luckSource.count;
    }else if ([pageName isEqualToString:@"recommend"]){
        return newestSource.count;
    }
    else if ([pageName isEqualToString:@"hot"]){
        return hotSource.count;
    }else{
        return 10;
    }
}
#pragma mark --section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//初始化cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([pageName isEqualToString:@"goodluck"]){
        return [self showCell:@"goodluck" collectionView:collectionView indexPath:indexPath withArray:luckSource];
    }else if ([pageName isEqualToString:@"recommend"]){
        return [self showCell:@"recommend" collectionView:collectionView indexPath:indexPath withArray:newestSource];
    }
    else if ([pageName isEqualToString:@"hot"]){
        return [self showCell:@"hot" collectionView:collectionView indexPath:indexPath withArray:hotSource];
    }else{
        ExpressCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mine" forIndexPath:indexPath];
        
        cell.imgView.image = [UIImage imageNamed:@"placehoder"];
        cell.text.text = @"小明库尔";
        return cell;
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/2.3, self.frame.size.height/3.5);
}


#pragma mark --选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([pageName isEqualToString:@"goodluck"]){
        NSString *urlString =[[luckSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _block(urlString);
    }else if ([pageName isEqualToString:@"recommend"]){
        NSString *urlString =[[newestSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _block(urlString);
    }
    else if ([pageName isEqualToString:@"hot"]){
        NSString *urlString =[[hotSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _block(urlString);
    }else{
        NSString *urlString =[[mineSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _block(urlString);
    }
    #pragma clang diagnostic pop
}


#pragma mark --生成cell
- (ExpressCollectionCell *)showCell:(NSString *)idfer collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath  withArray:(NSArray *)dataSource
{
    ExpressCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idfer forIndexPath:indexPath];
    
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *urlString =[[dataSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    #pragma clang diagnostic pop
    NSURL *imgUrl =[NSURL URLWithString:urlString] ;
    [cell.imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placehoder"]];
    cell.text.text = [dataSource[indexPath.row] objectForKey:@"name"];
    return cell;
}

@end
