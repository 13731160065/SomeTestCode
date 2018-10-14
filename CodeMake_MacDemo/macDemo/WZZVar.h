//
//  WZZVar.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//  变量类：
//  1.带有类信息和对象信息
//  2.用在方法里时，nameFunc和descFunc分别表示方法描述和方法名

#import <Foundation/Foundation.h>
#import "WZZSPECIALManager.h"
@class WZZClass;
@class WZZObject;

@interface WZZVar : WZZSPECIALBaseObject

/**
 指针所属类
 */
@property (nonatomic, strong) WZZClass * pointClass;

/**
 变量
 */
@property (nonatomic, strong) WZZObject * varValue;

/**
 变量名，生成方法时或创建变量时使用
 */
@property (nonatomic, strong) NSString * name;

/**
 描述，生成方法时使用
 */
@property (nonatomic, strong) NSString * descFunc;

@end
