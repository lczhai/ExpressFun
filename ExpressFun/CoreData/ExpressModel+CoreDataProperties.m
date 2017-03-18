//
//  ExpressModel+CoreDataProperties.m
//  ExpressFun
//
//  Created by 翟留闯 on 2017/3/18.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ExpressModel+CoreDataProperties.h"

@implementation ExpressModel (CoreDataProperties)

+ (NSFetchRequest<ExpressModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ExpressModel"];
}

@dynamic imageData;
@dynamic imageName;
@dynamic imageId;

@end
