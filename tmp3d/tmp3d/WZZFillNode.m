//
//  WZZFillNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFillNode.h"

@implementation WZZFillNode

+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep {
    if (pointsArray.count < 3) {
        return nil;
    }
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:pointsArray[0].CGPointValue];
    for (int i = 1; i < pointsArray.count; i++) {
        [path addLineToPoint:pointsArray[i].CGPointValue];
    }
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:deep];
    WZZFillNode * node = (WZZFillNode *)[self nodeWithGeometry:shape];
    node.deep = deep;
    node.pointsArray = [NSArray arrayWithArray:pointsArray];
    return node;
}

//计算数据，子类计算
- (NSArray <NSString *>*)handleData {
    return [NSArray array];
}

@end
