//
//  WZZFunc.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
@class WZZVar;
@class WZZFunc;
@class WZZSentance;

@interface WZZFunc : WZZSPECIALBaseObject

/**
 访问权限
 */
@property (nonatomic, assign) WZZSPECIALManager_Power power;

/**
 函数名
 */
@property (nonatomic, strong) NSString * name;

/**
 入参
 */
@property (nonatomic, strong) NSMutableArray <WZZVar *>* varArray;

/**
 执行数组
 */
@property (nonatomic, strong) NSMutableArray <WZZSentance *>* runArray;

/**
 返回值类型
 */
@property (nonatomic, strong) WZZClass * returnClass;

/**
 生成实例

 @param funcName 方法名
 @return 实例
 */
+ (instancetype)funcWithName:(NSString *)funcName
                 returnClass:(WZZClass *)returnClass;

/**
 执行函数

 @return 返回值
 */
- (WZZVar *)runFunc;

@end
