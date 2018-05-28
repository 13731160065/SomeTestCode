//
//  WZZFillNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "WZZShapeHandler.h"

@interface WZZFillNode : SCNNode

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

 @param dataBlock 回调
 */
- (void)handleDataWith:(void(^)(id returnData))dataBlock;

@end
