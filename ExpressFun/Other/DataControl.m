//
//  BraDataControl.m
//  SmartBra
//
//  Created by 翟留闯 on 16/7/10.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "DataControl.h"

@implementation DataControl




+ (void)netGetRequestWithRequestCode:(int)requestCode URL:(NSString *)url parameters:(NSDictionary *)dic callBackDelegate:(id<NetWorkCallbackDelegate>)callBackDelehate
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 10;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
	
	
//	NSString *sessionID = [dic objectForKey:@"sessionID"];
//	if (sessionID != nil && ![sessionID isEqualToString:@""]) {
//		[session.requestSerializer setValue:sessionID forHTTPHeaderField:@"sessionID"];
//	}
    
    //发出请求
	[session GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		
		NSDictionary *responesDic = (NSDictionary *)responseObject;
		
		if ([[responesDic objectForKey:@"status"] isEqualToString:@"success"]) {
			if (callBackDelehate != nil) {
				if ([[responesDic objectForKey:@"datas"] isKindOfClass:[NSString class]]) {
					NSData *data = [[responesDic objectForKey:@"datas"] dataUsingEncoding:NSUTF8StringEncoding];
					NSDictionary *canshu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
					[callBackDelehate callBackWithData:canshu requestCode:requestCode];
					
				}
				else
				{
					[callBackDelehate callBackWithData:[responesDic objectForKey:@"datas"] requestCode:requestCode];
				}
				
			}
		}
		else
		{
			if (callBackDelehate != nil) {
				[callBackDelehate callBackWithErrorCode:0 message:[responesDic objectForKey:@"datas"] innerError:nil requestCode:requestCode];
			}
		}
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (callBackDelehate != nil) {
            [callBackDelehate callBackWithErrorCode:0 message:@"请检查您的网络" innerError:nil requestCode:requestCode];
        }
	}];
	
	
	
}


+ (void)netPostRequestWithRequestCode:(int)requestCode URL:(NSString *)url parameters:(NSDictionary *)dic callBackDelegate:(id<NetWorkCallbackDelegate>)callBackDelehate
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 10;
	[session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
	
	NSString *sessionID = [dic objectForKey:@"sessionID"];
	if (sessionID != nil && ![sessionID isEqualToString:@""]) {
		[session.requestSerializer setValue:sessionID forHTTPHeaderField:@"sessionID"];
	}

//	NSLog(@"发送数据：%@",dic);
	
	
	[session POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responesDic = responseObject;
        if ([[responesDic objectForKey:@"status"] isEqualToString:@"success"]) {
            
            
            if (callBackDelehate != nil) {
                
                if ([[responesDic objectForKey:@"datas"] isKindOfClass:[NSString class]]) {
                    NSData *data = [[responesDic objectForKey:@"datas"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *canshu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [callBackDelehate callBackWithData:canshu requestCode:requestCode];
                    
                }
                else
                {
                    [callBackDelehate callBackWithData:[responesDic objectForKey:@"datas"] requestCode:requestCode];
                }
                
            }
        }
        else
        {
            if (callBackDelehate != nil) {
                [callBackDelehate callBackWithErrorCode:0 message:[responesDic objectForKey:@"datas"] innerError:nil requestCode:requestCode];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (callBackDelehate != nil) {
            [callBackDelehate callBackWithErrorCode:0 message:@"请检查您的网络" innerError:nil requestCode:requestCode];
        }
    }];
	
	
}


@end
