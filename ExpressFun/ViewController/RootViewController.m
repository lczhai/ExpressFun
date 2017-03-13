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
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表趣";
    self.view.backgroundColor = [UIColor colorWithRed:228/255.0 green:106/255.0 blue:17/255.0 alpha:1.0];
    tagArray =@[@"手气不错",@"新品发售",@"热门搞笑",@"个人制作"];
    self.navigationController.navigationBar.translucent=YES;
    
    [self creatUI];
}


- (void)creatUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.frame.size.width/tagArray.count, 2)];
    backView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backView];
    
    
    for (int i = 0; i<tagArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/tagArray.count*i, 0, self.view.frame.size.width/tagArray.count, 25)];
        btn.tag = i+11;
        [btn setTitle:tagArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [goodluck setBlock:^(NSString *urlString) {
        NSLog(@"图片地址：%@",urlString);
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *img = [UIImage imageWithData:imgData];
        
        ProcessViewController *process = [[ProcessViewController alloc]init];
        [process initWithSourceImage:img];
        [self.navigationController pushViewController:process animated:YES];
    }];
    
    ExpressCollectionView *recommend = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"recommend"];
    recommend.backgroundColor = [UIColor greenColor];
    [expScrollView addSubview:recommend];
    [recommend setBlock:^(NSString *urlString) {
        NSLog(@"图片地址：%@",urlString);
    }];
    

    ExpressCollectionView *hotView = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"hot"];
    hotView.backgroundColor = [UIColor purpleColor];
    [expScrollView addSubview:hotView];
    [hotView setBlock:^(NSString *urlString) {
        NSLog(@"图片地址：%@",urlString);
    }];
    
    ExpressCollectionView *mine = [[ExpressCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, self.view.frame.size.width, self.view.frame.size.height-26-64) withKeyword:@"mine"];
    mine.backgroundColor = [UIColor brownColor];
    [expScrollView addSubview:mine];
    [mine setBlock:^(NSString *urlString) {
        NSLog(@"图片地址：%@",urlString);
    }];
    
}


- (void)btn_touch:(UIButton *)sender
{
    expScrollView.contentOffset = CGPointMake(self.view.frame.size.width*(sender.tag-11), 0);
    [UIView animateWithDuration:0.5 animations:^{
        backView.center = CGPointMake(sender.center.x , backView.center.y);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int page = scrollView.contentOffset.x/self.view.frame.size.width;
    
//    NSLog(@"%f",scrollView.contentOffset.x);
    
//    UIButton *btn = (id)[self.view viewWithTag:page+11];
    
//    [UIView animateWithDuration:0.2 animations:^{
        backView.center = CGPointMake(scrollView.contentOffset.x/tagArray.count + backView.frame.size.width/2, backView.center.y);
//    }];
    
}



@end
