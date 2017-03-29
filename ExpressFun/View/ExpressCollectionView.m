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
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;//coredata上下文
}



@synthesize newestSource;//最新数据
@synthesize hotSource;//热门数据
@synthesize luckSource;//手气数据
@synthesize mineSource;//我的数据




- (instancetype)initWithFrame:(CGRect)frame withKeyword:(NSString *)keyword
{
    self = [super initWithFrame:frame];
    if (self) {
        
        appDelegate = (id)[UIApplication sharedApplication].delegate;
        pageName = keyword;
        pageSize = 12;
        hotPageIndex = 0;
        newestPageIndex = 0;
        
        //初始化
        mineSource = [[NSMutableArray alloc]init];
        
        [self loadData:keyword];
        [SVProgressHUD show];
        
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
        }else if ([keyword isEqualToString:@"newest"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
            _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                newestPageIndex = 0;
                [newestSource removeAllObjects];
                [self loadData:keyword];
            }];
            _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                newestPageIndex = newestPageIndex + pageSize;
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
            _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                hotPageIndex = hotPageIndex + pageSize;
                [self loadData:keyword];
            }];
        }
        else if([keyword isEqualToString:@"mine"]){
            [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:keyword];
        }
        
        //定义每个UICollectionView 横向的间距
        self.fl.minimumLineSpacing = 20;
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
    }else if ([keyword isEqualToString:@"newest"]){
        NSString *urlString = [NSString stringWithFormat:@"/list?begin=%d&offset=%d",newestPageIndex,pageSize];
        [DataControl netGetRequestWithRequestCode:1 URL:urlString parameters:nil callBackDelegate:self];
    }
    else if ([keyword isEqualToString:@"hot"]){
        NSString *urlString = [NSString stringWithFormat:@"/list/hot?begin=%d&offset=%d",hotPageIndex,pageSize];
        [DataControl netGetRequestWithRequestCode:2 URL:urlString parameters:nil callBackDelegate:self];
    }
    else{
        [self initDataBase];
        [self getAllDiyImage];
        
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
        newestSource == nil ? newestSource = [[NSMutableArray alloc]initWithArray:data] : [newestSource addObjectsFromArray:data];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }else if (requestCode == 2){
        hotSource == nil ? hotSource = [[NSMutableArray alloc]initWithArray:data] : [hotSource addObjectsFromArray:data];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
}

//网络请求失败回调
- (void)callBackWithErrorCode:(int)code message:(NSString *)message innerError:(NSError *)error requestCode:(int)requestCode{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:message];
}



























#pragma mark --cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([pageName isEqualToString:@"goodluck"]){
        return luckSource.count;
    }else if ([pageName isEqualToString:@"newest"]){
        return newestSource.count;
    }
    else if ([pageName isEqualToString:@"hot"]){
        return hotSource.count;
    }else{
        return mineSource.count;
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
    }else if ([pageName isEqualToString:@"newest"]){
        return [self showCell:@"newest" collectionView:collectionView indexPath:indexPath withArray:newestSource];
    }
    else if ([pageName isEqualToString:@"hot"]){
        return [self showCell:@"hot" collectionView:collectionView indexPath:indexPath withArray:hotSource];
    }else{
        ExpressCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mine" forIndexPath:indexPath];
        
            cell.imgView.image = [UIImage imageWithData:[mineSource[indexPath.row] valueForKey:@"imageData"]];
            cell.text.text = [mineSource[indexPath.row] valueForKey:@"imageName"];
        
        
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
        if([self isNull:luckSource[indexPath.row]]){
            [SVProgressHUD showErrorWithStatus:@"图坏啦~~~~(>_<)~~~~"];
        }else{
            NSString *urlString =[[luckSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _block(urlString,[luckSource[indexPath.row] objectForKey:@"name"]);
        }
        
    }else if ([pageName isEqualToString:@"newest"]){
        if([self isNull:newestSource[indexPath.row]]){
            [SVProgressHUD showErrorWithStatus:@"图坏啦~~~~(>_<)~~~~"];
        }else{
            NSString *urlString =[[newestSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _block(urlString,[newestSource[indexPath.row] objectForKey:@"name"]);
        }
    }
    else if ([pageName isEqualToString:@"hot"]){
        
        if([self isNull:hotSource[indexPath.row]]){
            [SVProgressHUD showErrorWithStatus:@"图坏啦~~~~(>_<)~~~~"];
        }else{
            NSString *urlString =[[hotSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _block(urlString,[hotSource[indexPath.row] objectForKey:@"name"]);
        }
    }else{
        _dataBlock([mineSource[indexPath.row] valueForKey:@"imageData"],[mineSource[indexPath.row] valueForKey:@"imageName"],[mineSource[indexPath.row] valueForKey:@"imageId"]);
    }
    #pragma clang diagnostic pop
}

#pragma mark --判断数组元素为空
- (BOOL)isNull:(NSDictionary *)obj{
    if(obj == nil || [obj isEqual:[NSNull null]]){
        return YES;
    }else{
        return NO;
    }
}



#pragma mark --生成cell
- (ExpressCollectionCell *)showCell:(NSString *)idfer collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath  withArray:(NSArray *)dataSource
{
    ExpressCollectionCell *cell;
    if(cell == nil){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:idfer forIndexPath:indexPath];
    }
    
    
//    NSLog(@"当前cell数量：%ld",(long)indexPath.row);
//    NSLog(@"datasource:%@",[dataSource[indexPath.row] objectForKey:@"path"]);
    
    if(dataSource[indexPath.row] == nil || [dataSource[indexPath.row] isEqual:[NSNull null]]){
        cell.imgView.image = [UIImage imageNamed:@"placehoder"];
        cell.text.text = @"失败了";
        return cell;
    }else{
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSString *urlString =[[dataSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        #pragma clang diagnostic pop
        NSURL *imgUrl =[NSURL URLWithString:urlString] ;
        [cell.imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placehoder"]];
        cell.text.text = [dataSource[indexPath.row] objectForKey:@"name"];
        return cell;
    }
    
    
}



//获取数据
- ( void )getAllDiyImage{
    mineSource == nil ? mineSource=[[NSMutableArray alloc]init] : [mineSource removeAllObjects];
    [mineSource addObjectsFromArray:[self getMyImages]];
    [self.collectionView reloadData];
}



#pragma mark --初始化coredata
- (void)initDataBase{
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    //找到你想存放数据库的路径(document)
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //设置数据库存放路径
    NSURL *url = [NSURL fileURLWithPath:[dbPath stringByAppendingPathComponent:@"ExpressModel.sqlite"]];
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"数据库添加错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
}

#pragma mark 获取数据库数据
- (NSArray *)getMyImages{
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    request.entity = [NSEntityDescription entityForName:@"ExpressModel" inManagedObjectContext:context];//找到我们的Person
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", @"001"];//创建谓词语句，条件是uid等于001
    //    request.predicate = predicate; //赋值给请求的谓词语句
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行我们的请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
    }
    return objs;
}


@end
