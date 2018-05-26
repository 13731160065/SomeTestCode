//
//  WZZInsideNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WZZShapeHandler.h"
@class WZZWindowNode;

//全局node等级
static NSInteger WZZInsideNode_Node_Level = 0;

@interface WZZInsideNode : SCNNode

/**
 node等级，越后创建的该数字越大
 */
@property (nonatomic, assign) NSInteger nodeLevel;

/**
 路径点
 */
@property (nonatomic, strong) NSArray <NSValue *>* points;

/**
 切割的方向
 */
@property (nonatomic, assign) WZZInsideNode_HV insideCutHV;

/**
 点击将要执行的动作
 */
@property (nonatomic, assign) WZZInsideNode_Action insideAction;

/**
 内容类型
 */
@property (nonatomic, assign) WZZInsideNodeContentType insideType;

/**
 内容为框
 */
@property (nonatomic, strong) NSArray <WZZWindowNode *>* insideWindow;

/**
 内容为填充
 */
@property (nonatomic, strong) WZZInsideNode * insideFill;

/**
 创建inside

 @param node 框
 @return 内容
 */
- (instancetype)initInsideWithWindow:(WZZWindowNode *)node;

/**
 切

 @param point 切的点
 */
- (void)cutWithPosition:(CGPoint)point;

/**
 填充

 @param insideNode 填充物
 */
- (void)fillWithInside:(WZZInsideNode *)insideNode;

/**
 点击了这个node
 */
- (void)nodeClick:(SCNHitTestResult *)result;

@end
