//
//  WZZObject.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
@class WZZClass;
@class WZZProperty;
@class WZZFunc;

@interface WZZObject : WZZSPECIALBaseObject

/**
 所属类
 */
@property (nonatomic, strong, readonly) WZZClass * realClass;

/**
 属性数组
 */
@property (nonatomic, strong, readonly) NSMutableArray <WZZProperty *>* propertyArray;

/**
 对象方法数组
 */
@property (nonatomic, strong, readonly) NSMutableArray <WZZFunc *>* objFuncArray;

/**
 创建实例

 @param aClass 所属类
 @return 对象
 */
+ (instancetype)objectWithRealClass:(WZZClass *)aClass;

@end
