//
//  WZZInsideDataMaker.h
//  tmp3d
//
//  Created by 王泽众 on 2018/6/4.
//  Copyright © 2018年 王泽众. All rights reserved.
//  window会自动创建inside所以inside的创建不用管，只需要inside的参数即可

#import <Foundation/Foundation.h>
#import "WZZShapeHandler.h"
@class WZZWindowDataMaker;
@class WZZInsideNode;

@interface WZZInsideDataMaker : NSObject

/**
 切割方向
 */
@property (nonatomic, assign) WZZInsideNode_HV insideHV;

/**
 切割位置
 */
@property (nonatomic, assign) CGPoint insideCutPosition;

/**
 动作
 */
@property (nonatomic, assign) WZZInsideNode_Action insideAction;

/**
 内容类型
 */
@property (nonatomic, assign) WZZInsideNodeContentType insideContentType;

/**
 处理inside

 @param dic inside字典
 @param insideNode 待处理insideNode
 */
+ (void)handleInsideWithDic:(NSDictionary *)dic inside:(WZZInsideNode *)insideNode;

/**
 inside转换成字典，递归
 
 @return inside字典
 */
+ (NSDictionary *)dicWithInside:(WZZInsideNode *)insideNode;

@end
