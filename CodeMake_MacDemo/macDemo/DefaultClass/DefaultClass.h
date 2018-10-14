//
//  DefaultClass.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSPECIALBaseObject.h"
@class WZZObject;

@interface DefaultClass : WZZSPECIALBaseObject

/**
 获取类
 预置的类都应该实现该方法
 @return 获取类
 */
+ (WZZClass *)getClass;

/**
 生成对象
 
 @return 对象
 */
+ (WZZObject *)object;

@end
