//
//  WZZObjectFunc.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFunc.h"
@class WZZObject;

@interface WZZObjectFunc : WZZFunc

/**
 调用对象
 */
@property (nonatomic, strong) WZZObject * runObject;

/**
 执行函数
 
 @return 返回值
 */
- (WZZVar *)runFuncWithObject:(WZZObject *)runObject;

@end
