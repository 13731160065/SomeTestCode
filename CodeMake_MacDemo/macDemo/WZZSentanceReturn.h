//
//  WZZSentanceReturn.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//  返回语句

#import "WZZSentance.h"

@interface WZZSentanceReturn : WZZSentance

/**
 返回值
 */
@property (nonatomic, strong) WZZVar * returnVar;

/**
 返回

 @param returnVar 返回值
 @return 返回语句
 */
+ (instancetype)returnVar:(WZZVar *)returnVar;

@end
