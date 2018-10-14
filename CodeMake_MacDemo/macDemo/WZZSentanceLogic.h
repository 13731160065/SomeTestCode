//
//  WZZSentanceLogic.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  逻辑判断语句

#import "WZZSentance.h"

typedef enum : NSUInteger {
    WZZSentanceLogic_Type_Equal,//==
    WZZSentanceLogic_Type_Big,//>
    WZZSentanceLogic_Type_BigEqual,//>=
    WZZSentanceLogic_Type_Small,///<
    WZZSentanceLogic_Type_SmallEqual,///<=
    WZZSentanceLogic_Type_NotEqual,//!=
    WZZSentanceLogic_Type_Or,//||
    WZZSentanceLogic_Type_And,//&&
    WZZSentanceLogic_Type_Not,//!
} WZZSentanceLogic_Type;//逻辑类型

@interface WZZSentanceLogic : WZZSentance

/**
 变量A
 */
@property (nonatomic, strong) id objA;

/**
 变量B
 */
@property (nonatomic, strong) id objB;

/**
 逻辑类型
 */
@property (nonatomic, assign) WZZSentanceLogic_Type logicType;

+ (instancetype)sentanceWithObjA:(id)objA
                       logicType:(WZZSentanceLogic_Type)logicType
                            objB:(id)objB;

@end
