//
//  WZZARManager.h
//  WZZARDemo
//
//  Created by 王泽众 on 2017/12/3.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZARManager : NSObject

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 初始化AR
 */
- (void)setupAR;

/**
 启动AR
 */
- (void)startAR;

/**
 暂停AR
 */
- (void)pauseAR;

@end
