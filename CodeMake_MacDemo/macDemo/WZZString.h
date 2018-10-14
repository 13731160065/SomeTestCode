//
//  WZZString.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  考虑作废，使用WZZBaseValueClass

#import "WZZSPECIALBaseObject.h"
#import "WZZBaseValueClass.h"

@interface WZZString : WZZBaseValueClass

/**
 基础类型
 */
@property (nonatomic, strong) NSString * string;

/**
 实例化
 
 @param string 基础类型
 @return 实例
 */
+ (instancetype)stringWithString:(NSString *)string;

@end
