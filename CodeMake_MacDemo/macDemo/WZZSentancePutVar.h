//
//  WZZSentancePutVar.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  赋值语句

#import "WZZSentance.h"

@interface WZZSentancePutVar : WZZSentance

/**
 变量
 */
@property (nonatomic, strong) WZZVar * aVar;

/**
 变量值，可为空
 */
@property (nonatomic, strong) WZZObject * varValue;

/**
 创建赋值语句

 @param aVar 变量
 @param varValue 值
 @return 变量
 */
+ (instancetype)sentanceWithName:(WZZVar *)aVar
                        varValue:(WZZObject *)varValue;

@end
