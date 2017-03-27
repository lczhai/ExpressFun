//
//  AppDelegate.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/12.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setLoadingStyle];//设置loading样式
    [self init3rdParty];//初始化分享SDK
    
    RootViewController *root = [[RootViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:253/255.0 green:179/255.0 blue:51/255.0 alpha:1.0];
    //设置导航字体颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    

    //当app首次启动时候，在userdefault创建一个记录id的字段
    NSString *collectId  =  [[NSUserDefaults standardUserDefaults] objectForKey:imgIds];
    NSLog(@"isd:%@",collectId);
    if(collectId == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:imgIds];
    }
    
    
    self.window.rootViewController = nav;
    return YES;
}

//设置loding样式
- (void)setLoadingStyle{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//黑色背景
    [SVProgressHUD setMinimumDismissTimeInterval:1];//提示持续时长
    [SVProgressHUD setDefaultMaskType:2];//渐变效果
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.110 alpha:0.900]];//提示框背景色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//提示框前景色
    [SVProgressHUD setCornerRadius:8];//提示框圆角
    [SVProgressHUD setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    

}

//初始化第三方库
- (void)init3rdParty
{
    [WXApi registerApp:@"wx00145d7ef1189927"];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"2752862027"];//表趣
    
    //    TencentOAuth *tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1106043198" andDelegate:self];//表趣
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        
        return [TencentOAuth HandleOpenURL:url];
        
    }else if([[url absoluteString] hasPrefix:@"wb"]){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }
    else if([[url absoluteString] hasPrefix:@"WX"]){
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([WXApi handleOpenURL:url delegate:self]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([WeiboSDK handleOpenURL:url delegate:self])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else
    {
        return [TencentOAuth HandleOpenURL:url];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExpressFun"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
