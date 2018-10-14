//
//  WZZClassFunc.h
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFunc.h"
@class WZZClass;

@interface WZZClassFunc : WZZFunc

/**
 调用类
 */
@property (nonatomic, strong) WZZClass * runClass;

/**
 执行函数
 
 @return 返回值
 */
- (WZZVar *)runFuncWithClass:(WZZClass *)runClass;

@end
