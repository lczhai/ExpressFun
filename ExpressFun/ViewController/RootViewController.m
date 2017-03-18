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
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表趣";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(intoSearch)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    databaseReload = NO;
    toolImgView = [[UIImageView alloc]init];//工具视图，用于通过SDWebimage转换图片
    self.view.backgroundColor = [UIColor whiteColor];
    tagArray =@[@"手气不错",@"新品发售",@"热门搞笑",@"个人制作"];
    self.navigationController.navigationBar.translucent=YES;
    
    [self creatUI];
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
    goodluck.backgroundColor = [UIColor yellowColor];
    [expScrollView addSubview:goodluck];
    [goodluck setBlock:^(NSString *urlString, NSString *name) {
        [toolImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        ProcessViewController *process = [[ProcessViewController alloc]init];
        process.sourceImage = toolImgView.image;
        process.sourceImageName = name;
        [self.navigationController pushViewController:process animated:YES];
    }];
    
    //最新数据
    ExpressCollectionView *newest = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"newest"];
    newest.backgroundColor = [UIColor greenColor];
    [expScrollView addSubview:newest];
    [newest setBlock:^(NSString *urlString, NSString *name) {
        [toolImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        ProcessViewController *process = [[ProcessViewController alloc]init];
        process.sourceImage = toolImgView.image;
        process.sourceImageName = name;
        [self.navigationController pushViewController:process animated:YES];
    }];
    

    ExpressCollectionView *hotView = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"hot"];
    hotView.backgroundColor = [UIColor purpleColor];
    [expScrollView addSubview:hotView];
    [hotView setBlock:^(NSString *urlString, NSString *name) {
        [toolImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        ProcessViewController *process = [[ProcessViewController alloc]init];
        process.sourceImage = toolImgView.image;
        process.sourceImageName = name;
        [self.navigationController pushViewController:process animated:YES];
    }];
    
    ExpressCollectionView *mine = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"mine"];
    //从消息中心取到消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataBaseInfo:) name:DateBaseChange object:nil];
    mineView = mine;
    mine.backgroundColor = [UIColor brownColor];
    [expScrollView addSubview:mine];
    [mine setDataBlock:^(NSData *data, NSString *name, NSString *imgId) {
        UIImage *img = [UIImage imageWithData:data];
        ProcessViewController *process = [[ProcessViewController alloc]init];
        process.sourceImage = img;
        process.sourceImageName = name;
        process.imageId = imgId;
        [self.navigationController pushViewController:process animated:YES];
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



@end
