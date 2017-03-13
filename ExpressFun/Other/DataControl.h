//
//  BraDataControl.h
//  SmartBra
//
//  Created by 翟留闯 on 16/7/10.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataControl : NSObject



+ (void)netGetRequestWithRequestCode:(int)requestCode URL:(NSString *)url parameters:(NSDictionary *)dic callBackDelegate:(id<NetWorkCallbackDelegate>)callBackDelehate;




+ (void)netPostRequestWithRequestCode:(int)requestCode URL:(NSString *)url parameters:(NSDictionary *)dic callBackDelegate:(id<NetWorkCallbackDelegate>)callBackDelehate;







@end
