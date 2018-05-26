//
//  WZZWindowNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/23.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WZZInsideNode.h"

@interface WZZWindowNode : SCNNode

/**
 是否有边框
 */
@property (nonatomic, assign) BOOL hasBorder;

/**
 内部点，如果没边框，内部点和外部点相等
 */
@property (nonatomic, strong) NSArray <NSValue *>* insetPoints;

/**
 内容
 */
@property (nonatomic, strong) WZZInsideNode * insideContent;

/**
 创建window

 @param leftH 左边高
 @param rightH 右边高
 @param downWidth 下边宽
 @param hasBorder 有没有框
 @return 实例
 */
+ (instancetype)nodeWithLeftHeight:(CGFloat)leftH
                       rightHeight:(CGFloat)rightH
                         downWidth:(CGFloat)downWidth
                         hasBorder:(BOOL)hasBorder;

/**
 创建window

 @param points 点数组
 @param hasBorder 有没有边
 @return 实例
 */
+ (instancetype)nodeWithPoints:(NSArray <NSValue *>*)points
                     hasBorder:(BOOL)hasBorder;

//点击
- (void)nodeClick:(SCNHitTestResult *)result;

@end
