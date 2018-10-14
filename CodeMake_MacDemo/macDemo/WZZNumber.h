//
//  WZZNumber.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  考虑作废，使用WZZBaseValueClass

#import "WZZSPECIALBaseObject.h"
#import "WZZBaseValueClass.h"
@class WZZClass;

typedef enum : NSUInteger {
    WZZNumber_Type_Auto = 0,
    WZZNumber_Type_Int,
    WZZNumber_Type_Double,
    WZZNumber_Type_Bool,
} WZZNumber_Type;

@interface WZZNumber : WZZBaseValueClass

/**
 类型
 */
@property (nonatomic, assign) WZZNumber_Type type;

/**
 真实数据
 */
@property (nonatomic, strong) NSNumber * realNumber;

/**
 创建number

 @param number 数
 @return 实例
 */
+ (instancetype)numberWithNumber:(NSNumber *)number;

/**
 创建number
 
 @param number 数
 @param type 指定类型
 @return 实例
 */
+ (instancetype)numberWithNumber:(NSNumber *)number
                            type:(WZZNumber_Type)type;

@end
