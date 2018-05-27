//
//  WZZTingNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/25.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZTingNode.h"

@implementation WZZTingNode

+ (instancetype)nodeWithPath:(NSArray<NSValue *> *)pointArr
                   superNode:(SCNNode *)superNode
                      border:(CGFloat)border {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:pointArr[0].CGPointValue];
    for (int i = 0; i < pointArr.count; i++) {
        [path addLineToPoint:pointArr[i].CGPointValue];
    }
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:border];
    WZZTingNode * heightNode = (WZZTingNode *)[self nodeWithGeometry:shape];
    //挺的所有点
    heightNode->_pointArr = [NSArray arrayWithArray:pointArr];
    //厚度
    heightNode->_border = border;
    //父节点
    heightNode->_superNode = superNode;
    
    return heightNode;
}

#pragma mark - 属性


@end
