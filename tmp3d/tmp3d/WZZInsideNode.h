//
//  WZZInsideNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//  内容，内容类型默认为无即透明，可选择玻璃等，如果切割或添加扇，需要在内容上创建框并将内容置为空

#import <SceneKit/SceneKit.h>
#import "WZZShapeHandler.h"
#import "WZZZhongTingNode.h"
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
 内容上的框
 */
@property (nonatomic, strong) NSArray <WZZWindowNode *>* insideWindow;

/**
 父window
 */
@property (nonatomic, strong) WZZWindowNode * superWindow;

/**
 内容上的中挺
 内容上可能没有中挺，没有中挺的内容是最上层的内容，并且没有被切割
 计算所有没被切割的内容即可算出所有框挺之间的距离以及内容的尺寸
 */
@property (nonatomic, strong) WZZZhongTingNode * insideZhongTing;

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

 @param fillType 填充物
 */
- (void)fillWithInside:(WZZInsideNodeFillType)fillType;

/**
 点击了这个node
 */
- (void)nodeClick:(SCNHitTestResult *)result;

@end
