//
//  SearchViewController.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/18.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController
{
    UISearchBar *searchBox;
    FLAnimatedImageView  *toolImgView;
}
@synthesize searchSource;
@synthesize _collectionView;
@synthesize fl;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"dsa";
    self.view.backgroundColor  =  [UIColor whiteColor];
    
    [self initSearchBar];
    [self initCollectionView];
    
    toolImgView = [[FLAnimatedImageView alloc]init];
    
    
}
#pragma mark --初始化collectionView
- (void)initCollectionView{
    //初始化
    searchSource = [[NSMutableArray alloc]init];
    
    
    //创建网格布局对象
    self.fl = [[UICollectionViewFlowLayout alloc]init];
    //设置滑动方向为竖直滑动
    self.fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 创建集合视图对象
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBox.frame)+10, self.view.frame.size.width, self.view.frame.size.height-searchBox.frame.size.height-10) collectionViewLayout:self.fl];
    
    //注册cell
    [_collectionView registerClass:[ExpressCollectionCell class] forCellWithReuseIdentifier:@"search"];
    
    
    
    //定义每个UICollectionView 横向的间距
    self.fl.minimumLineSpacing = 20;
    //定义每个UICollectionView 的边距距
    self.fl.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);//上左下右
    
    
    //背景颜色
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    //自适应大小
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

}

#pragma mark --cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return searchSource.count;
    
}
#pragma mark --section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



//初始化cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"search" forIndexPath:indexPath];
    
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *urlString =[[searchSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    #pragma clang diagnostic pop
    NSURL *imgUrl =[NSURL URLWithString:urlString] ;
    [cell.imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placehoder"]];
    cell.text.text = [searchSource[indexPath.row] objectForKey:@"name"];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2.3, self.view.frame.size.height/3.5);
}


#pragma mark --选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString =[[searchSource[indexPath.row] objectForKey:@"path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [toolImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    ProcessViewController *process = [[ProcessViewController alloc]init];
    process.sourceImage = toolImgView.image;
    process.sourceImageName = [searchSource[indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:process animated:YES];
}








#pragma mark --初始化searchbar
- (void)initSearchBar{
    searchBox = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 64)];
    searchBox.placeholder = @"表情名称";
    [searchBox becomeFirstResponder];
    searchBox.showsCancelButton = YES;
    searchBox.searchBarStyle =UISearchBarStyleMinimal;
    searchBox.delegate = self;
    [self.view addSubview:searchBox];
    [searchBox becomeFirstResponder];
}


#pragma mark --点击搜索按钮事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBox resignFirstResponder];
    NSString *urlString = [NSString stringWithFormat:@"/search/%@?begin=%@&offset=%@",searchBar.text,@"1",@"9999"];
    [DataControl netGetRequestWithRequestCode:2 URL:urlString parameters:nil callBackDelegate:self];
}


- (void)callBackWithData:(id)data requestCode:(int)requestCode
{
    searchSource == nil ? searchSource = [[NSMutableArray alloc]init] : [searchSource removeAllObjects];
    [searchSource addObjectsFromArray:data];
    [_collectionView reloadData];
}

- (void)callBackWithErrorCode:(int)code message:(NSString *)message innerError:(NSError *)error requestCode:(int)requestCode
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:message];
}









#pragma mark --点击取消按钮事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}


@end
