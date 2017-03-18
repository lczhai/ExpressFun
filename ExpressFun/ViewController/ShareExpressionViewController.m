//
//  ShareExpressionViewController.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/14.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ShareExpressionViewController.h"

@interface ShareExpressionViewController ()

@end

@implementation ShareExpressionViewController
{
    UIImageView *showImageView;
    XMShareView *shareView;
    NSManagedObjectContext *context;//coredata上下文
}
@synthesize completeImage;




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保存/分享";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [self initUi];//初始化试图
    [self initDataBase];
    
}

- (void)initUi{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:@selector(goHomePage:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStyleDone target:self action:@selector(goHomePage:)];
    
    showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.15, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
    showImageView.image = completeImage;
    showImageView.contentMode = UIViewContentModeRedraw;
    //    showImageView.layer.cornerRadius = SCREEN_WIDTH/4;
    showImageView.layer.cornerRadius = 25;
    showImageView.layer.masksToBounds = YES;
    showImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    showImageView.layer.borderWidth = 2;
    [self.view addSubview:showImageView];
    
    
    UIButton *saveButton = [self createdButtonWithTitle:@"保存到相册" andFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(showImageView.frame)+30, SCREEN_WIDTH*0.6, 50)];
    [saveButton addTarget:self action:@selector(saveToLocal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    
    UIButton *shareButton = [self createdButtonWithTitle:@"分享给朋友" andFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(saveButton.frame)+20, SCREEN_WIDTH*0.6, 50)];
    [shareButton addTarget:self action:@selector(shareToFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    
    
    UIButton *collectionButton = [self createdButtonWithTitle:@"收藏表情" andFrame:CGRectMake(SCREEN_WIDTH*0.2, CGRectGetMaxY(shareButton.frame)+20, SCREEN_WIDTH*0.6, 50)];
    [collectionButton addTarget:self action:@selector(saveToDataBase:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionButton];

    
    
    
    
    
    
}

#pragma mark --定义按钮
- (UIButton *)createdButtonWithTitle:(NSString *)title andFrame:(CGRect)frame{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = button.frame.size.height/2;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    return button;
}

#pragma mark --分享给朋友
- (void)shareToFriends:(id)sender{
    //1.在目标页面添加分享按钮，事件如下（请先创建XMShareView）
    shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
    shareView.image = completeImage;
    [self.view addSubview:shareView];
}



#pragma mark --保存到本地
- (void)saveToLocal:(id)sender
{
    [self loadImageFinished:completeImage];
}

#pragma mark --保存到本地数据库
- (void)saveToDataBase:(id)sender{
        if(_completeImageId == nil){
            //将处理好的图片存入数据库
            NSData *imageData = UIImagePNGRepresentation(completeImage);
            [self insertImageToDataBaseWithImageData:imageData andImageName:_completeImageName];
            //发出通知数据库有变化
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DateBaseChange" object:@""];
        }else{
            NSData *imageData = UIImagePNGRepresentation(completeImage);
            [self updateImageByimageId:_completeImageId andImageData:imageData];
    
            //发出通知数据库有变化
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DateBaseChange" object:@""];
        }

}


#pragma mark -- 加载处理完成的图片
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

#pragma mark --将完成的图片保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [SVProgressHUD showErrorWithStatus:@"保存失败啦~~~~(>_<)~~~~"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"已放入相册啦(*^__^*)"];
    }
}


#pragma mark --回到首页
- (void)goHomePage:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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



#pragma mark --获取数据中所有数据
- (NSArray *)getAllImages{
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

#pragma mark --插入数据到数据库
- (void)insertImageToDataBaseWithImageData:(NSData *)data andImageName:(NSString *)name{
    NSManagedObject *mObject = [NSEntityDescription    insertNewObjectForEntityForName:@"ExpressModel" inManagedObjectContext:context];
    
    NSArray * imgs = [self getAllImages];
    NSString *imgId = [NSString stringWithFormat:@"%d",(int)(imgs.count+1)];
    
    
    [mObject setValue:data forKey:@"imageData"];
    [mObject setValue:name forKey:@"imageName"];
    [mObject setValue:imgId forKey:@"imageId"];
    
    
    NSError *error = nil;
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功(*^__^*)"];
    }
}


#pragma mark --更新数据库中的数据
- (void)updateImageByimageId:(NSString *)imgId andImageData:(NSData *)data{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];//创建请求
    request.entity = [NSEntityDescription entityForName:@"ExpressModel" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId = %@", imgId];//查询条件
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        [obj setValue:data forKey:@"imageData"];//查到数据后，将它的name修改成小红
    }
    
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"修改成功(*^__^*)"];
    }
    
}





@end
