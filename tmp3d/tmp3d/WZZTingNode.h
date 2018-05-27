//
//  WZZTingNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/25.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface WZZTingNode : SCNNode

/**
 暂时没用
 相连的挺
 如果是横挺，连接的就是竖挺，竖挺连接的就是横挺
 如果一个挺没有连接，那链接的就是边框
 */
@property (nonatomic, strong) NSMutableArray <WZZTingNode *>* connectTing;

/**
 挺的点数组
 */
@property (nonatomic, strong, readonly) NSArray <NSValue *>* pointArr;

//挺提供起始点结束点，但这两点的设置需要子类实现，两点之间的连线组成一个用来计算的线
/**
 挺开始的中心点
 */
@property (nonatomic, assign) CGPoint startPoint;

/**
 挺结束的中心点
 */
@property (nonatomic, assign) CGPoint endPoint;

/**
 父节点
 */
@property (nonatomic, strong) SCNNode * superNode;

/**
 挺的宽度
 */
@property (nonatomic, assign, readonly) CGFloat border;

/**
 创建挺

 @param pointArr 点数组
 @param border 宽度
 @return 挺
 */
+ (instancetype)nodeWithPath:(NSArray <NSValue *>*)pointArr
                   superNode:(SCNNode *)superNode
                      border:(CGFloat)border;

@end
