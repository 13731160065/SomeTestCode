//
//  WZZWindowDataMaker.h
//  tmp3d
//
//  Created by 王泽众 on 2018/6/4.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZShapeHandler.h"
@class WZZInsideDataMaker;
@class WZZWindowNode;

@interface WZZWindowDataMaker : NSObject

/**
 是不是主框
 */
@property (nonatomic, assign) BOOL isRoot;

/**
 外部点
 */
@property (nonatomic, strong) NSArray <NSValue *>* outPoints;

/**
 边框类型
 */
@property (nonatomic, assign) WZZShapeHandler_WindowBorderType borderType;

/**
 内容
 */
@property (nonatomic, strong) WZZInsideDataMaker * insideMaker;

/**
 用dic创建window

 @param dic 字典
 @return window
 */
+ (WZZWindowNode *)makeWindowWithDic:(NSDictionary *)dic;

/**
 window转换成字典，递归

 @return window字典
 */
+ (NSDictionary *)dicWithWindow:(WZZWindowNode *)windowNode;

@end
