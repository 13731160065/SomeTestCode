//
//  WZZSentanceCreateVar.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  声明语句

#import "WZZSentance.h"

@interface WZZSentanceCreateVar : WZZSentance

/**
 类型
 */
@property (nonatomic, strong) WZZClass * pointClass;

/**
 变量名
 */
@property (nonatomic, strong) NSString * varName;

/**
 变量，可为空
 */
@property (nonatomic, strong) WZZObject * varValue;

/**
 创建变量语句

 @param aClass 类
 @param varName 变量名
 @param aObj 变量，可为空
 @return 语句
 */
+ (instancetype)sentanceWithClass:(WZZClass *)aClass
                          varName:(NSString *)varName
                         varValue:(WZZObject *)aObj;

@end
