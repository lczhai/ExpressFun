//
//  ExpressModel+CoreDataProperties.h
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/18.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ExpressModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ExpressModel (CoreDataProperties)

+ (NSFetchRequest<ExpressModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imageId;

@end

NS_ASSUME_NONNULL_END
