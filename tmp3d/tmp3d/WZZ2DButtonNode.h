//
//  WZZ2DButtonNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>

static NSInteger levelTap;//等级

@interface WZZ2DButtonNode : SCNNode

/**
 加在哪个node上，方便相响应时处理
 */
@property (nonatomic, weak, readonly) SCNNode * superNode;

/**
 点击事件触发方法，属于superNode
 */
@property (nonatomic, assign) SEL clickSel;

/**
 用父node初始化

 @param superNode 父node
 @param geometry 几何体
 @param clickSel 点击事件
 @return 实例
 */
- (instancetype)initWithSuperNode:(SCNNode *)superNode
                         geometry:(SCNGeometry *)geometry
                         clickSel:(SEL)clickSel;

/**
 用父node初始化

 @param superNode 父node
 @param path 路径
 @param clickSel 点击事件
 @return 实例
 */
- (instancetype)initWithSuperNode:(SCNNode *)superNode
                         path:(UIBezierPath *)path
                         clickSel:(SEL)clickSel;

@end
