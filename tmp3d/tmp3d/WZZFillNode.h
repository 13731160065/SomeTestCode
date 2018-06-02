//
//  WZZFillNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WZZShapeHandler.h"
#import "WZZInsideNode.h"

@interface WZZFillNode : SCNNode

/**
 父节点
 */
@property (nonatomic, weak) WZZInsideNode * superNode;

/**
 路径点
 */
@property (nonatomic, strong) NSArray <NSValue *>* pointsArray;

/**
 深度
 */
@property (nonatomic, assign) CGFloat deep;

/**
 创建填充

 @param pointsArray 填充路径
 @param deep 深度
 @return 填充
 */
+ (instancetype)fillNodeWithPointsArray:(NSArray <NSValue *>*)pointsArray
                                   deep:(CGFloat)deep;

/**
 计算数据
 */
- (NSArray <NSString *>*)handleData;

/**
 计算转向框尺寸
 
 @return 尺寸
 */
- (NSArray <NSString *>*)handleTurnData;

@end
