//
//  WZZShanFillNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFillNode.h"

typedef enum : NSUInteger {
    WZZShanFillNode_ShanType_None,//没有
    WZZShanFillNode_ShanType_NormalShan//最普通的扇
} WZZShanFillNode_ShanType;

@interface WZZShanFillNode : WZZFillNode

/**
 扇类型
 */
@property (nonatomic, assign) WZZShanFillNode_ShanType shanType;

/**
 扇宽度
 */
@property (nonatomic, assign) CGFloat shanBorderWidth;

/**
 创建扇

 @param pointsArray 点坐标
 @param deep 厚度
 @param shanType 扇类型
 @return 扇
 */
+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep
                               shanType:(WZZShanFillNode_ShanType)shanType
                        shanBorderWidth:(CGFloat)shanBorderWidth;

@end
