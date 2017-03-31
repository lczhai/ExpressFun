//
//  RootViewController.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/12.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()
{
    NSArray *tagArray;
    UITableView *tv;
    UIScrollView *expScrollView;
    UIView *backView;
    ExpressCollectionView *mineView;
    UIImageView *toolImgView;
    BOOL databaseReload;
    
    NSManagedObjectContext *context;//coredata上下文

}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表趣";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(intoSearch)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    databaseReload = NO;
    toolImgView = [[UIImageView alloc]init];//工具视图，用于通过SDWebimage转换图片
    tagArray =@[@"手气不错",@"新品发售",@"热门搞笑",@"个人制作"];
    self.navigationController.navigationBar.translucent=YES;
    
    [self creatUI];
    
    
    [self checkVersion];//检查新版本
}

#pragma mark --进入搜索页
- (void)intoSearch{
    SearchViewController *search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:NO];
    
}


- (void)creatUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(10, 32, self.view.frame.size.width/tagArray.count-20, 2)];
    backView.backgroundColor = [UIColor colorWithRed:254/255.0 green:194/255.0 blue:69/255.0 alpha:1.0];
    
    [self.view addSubview:backView];
    
    
    for (int i = 0; i<tagArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/tagArray.count*i, 5, self.view.frame.size.width/tagArray.count, 25)];
        btn.tag = i+11;
        [btn setTitle:tagArray[i] forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn_touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
    
    expScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-backView.frame.size.height-64)];
    expScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*tagArray.count, 0);
    expScrollView.backgroundColor = [UIColor whiteColor];
    expScrollView.scrollEnabled = YES;
    expScrollView.directionalLockEnabled = YES;
    expScrollView.showsHorizontalScrollIndicator = NO;
    expScrollView.pagingEnabled = YES;
    expScrollView.delegate = self;
    [self.view addSubview:expScrollView];
    
    
    
    
    //好运数据
    ExpressCollectionView *goodluck = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-26-64) withKeyword:@"goodluck"];
    goodluck.backgroundColor = [UIColor whiteColor];
    [expScrollView addSubview:goodluck];
    [goodluck setBlock:^(NSString *urlString, NSString *name) {
        [self jumpToProcessViewControllerWithImageUrl:urlString andName:name];
    }];
    
    //最新数据
    ExpressCollectionView *newest = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"newest"];
    newest.backgroundColor = [UIColor whiteColor];
    [expScrollView addSubview:newest];
    [newest setBlock:^(NSString *urlString, NSString *name) {
        [self jumpToProcessViewControllerWithImageUrl:urlString andName:name];
    }];
    

    ExpressCollectionView *hotView = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"hot"];
    hotView.backgroundColor = [UIColor whiteColor];
    [expScrollView addSubview:hotView];
    [hotView setBlock:^(NSString *urlString, NSString *name) {
        [self jumpToProcessViewControllerWithImageUrl:urlString andName:name];
    }];
    
    ExpressCollectionView *mine = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"mine"];
    //从消息中心取到消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataBaseInfo:) name:DateBaseChange object:nil];
    mineView = mine;
    mine.backgroundColor = [UIColor brownColor];
    [expScrollView addSubview:mine];
    [mine setDataBlock:^(NSData *data, NSString *name, NSString *imgId) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您想要的操作" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteImageByImageDataBaseId:imgId];//删除数据库图片
        }];
        
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"再编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImage *img = [UIImage imageWithData:data];
            ProcessViewController *process = [[ProcessViewController alloc]init];
            process.sourceImage = img;
            process.sourceImageName = name;
            process.imageId = imgId;
            [self.navigationController pushViewController:process animated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:editAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }];
}
#pragma mark --接收数据变化的通知
- (void)getDataBaseInfo:(NSNotification *)nocation{
    //当接受到数据库更新的小时时候，讲此变量至为true，之后根据此变量在viewWillAppear方法内判断是否从新加载数据库内容
    databaseReload = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (databaseReload){
        [mineView loadData:@"mine"];
        databaseReload = NO;
    }
}


- (void)btn_touch:(UIButton *)sender
{
    expScrollView.contentOffset = CGPointMake(self.view.frame.size.width*(sender.tag-11), 0);
    [UIView animateWithDuration:0.2 animations:^{
        backView.center = CGPointMake(sender.center.x , backView.center.y);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int page = scrollView.contentOffset.x/self.view.frame.size.width;
    
//    NSLog(@"%f",scrollView.contentOffset.x);
    
//    UIButton *btn = (id)[self.view viewWithTag:page+11];
    
//    [UIView animateWithDuration:0.2 animations:^{
        backView.center = CGPointMake(scrollView.contentOffset.x/tagArray.count + backView.frame.size.width/2+10, backView.center.y);
//    }];
}



#pragma mark --跳转到图片编辑页
- (void)jumpToProcessViewControllerWithImageUrl:(NSString *)imageUrl andName:(NSString *)imageName{
    
    [toolImgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(!error){
            ProcessViewController *process = [[ProcessViewController alloc]init];
            process.sourceImage = toolImgView.image;
            process.sourceImageName = imageName;
            [self.navigationController pushViewController:process animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"出错了/(ㄒoㄒ)/"];
        }
    }];

}




#pragma mark --根据ID删除数据库库中的数据
- (void)deleteImageByImageDataBaseId:(NSString *)imgId{
    [self initDataBase];//初始化
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    request.entity = [NSEntityDescription entityForName:@"ExpressModel" inManagedObjectContext:context];//对应到表
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId = %@", imgId];//检索数据
    request.predicate = predicate; //赋值给请求的谓词语句
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行我们的请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
    }
    // 遍历数据 并删除
    for (NSManagedObject *obj in objs) {
        [context deleteObject:obj];
    }
    
    BOOL success = [context save:&error];
    if (!success) {
        [SVProgressHUD showSuccessWithStatus:@"失败了~~~~(>_<)~~~~"];
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        //发出通知数据库有变化
        [mineView loadData:@"mine"];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    }


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






-(void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1220687564"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    解析json数据
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = json[@"results"];
    
    for (NSDictionary *dic in array) {
        
        
        newVersion = [dic valueForKey:@"version"];
        
    }
    
    NSLog(@"通过appStore获取的版本号是：%@",newVersion);
    
    //获取本地软件的版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSLog(@"app本地版本号是：%@",localVersion);
    
    NSString *msg = [NSString stringWithFormat:@"小的发现了新版本哦，发现了更多好玩的东西，这就去更新吧"];
    
    //对比发现的新版本和本地的版本
    if ([newVersion floatValue] > [localVersion floatValue])
    {
        
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"表趣有新版本啦"message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/%E8%A1%A8%E8%B6%A3/id1220687564?mt=8"]];//这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
            NSLog(@"点击现在升级按钮");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击下次再说按钮");
        }]];
        
        
    }
}
@end
