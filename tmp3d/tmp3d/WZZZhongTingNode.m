//
//  WZZZhongTingNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/27.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZZhongTingNode.h"

@implementation WZZZhongTingNode

+ (instancetype)nodeWithPath:(NSArray<NSValue *> *)pointArr
                   superNode:(SCNNode *)superNode
                      tingHV:(WZZInsideNode_HV)tingHV
                      border:(CGFloat)border {
    WZZZhongTingNode * heightNode = [WZZZhongTingNode nodeWithPath:pointArr superNode:superNode border:border];
    
    heightNode->_tingHV = tingHV;
    //挺的中点两端点
    CGFloat maxY = 0;
    CGFloat minY = MAXFLOAT;
    CGFloat maxX = 0;
    CGFloat minX = MAXFLOAT;
    for (int i = 0; i < pointArr.count; i++) {
        if (pointArr[i].CGPointValue.x > maxX) {
            maxX = pointArr[i].CGPointValue.x;
        }
        if (pointArr[i].CGPointValue.x < minX) {
            minX = pointArr[i].CGPointValue.x;
        }
        if (pointArr[i].CGPointValue.y > maxY) {
            maxY = pointArr[i].CGPointValue.y;
        }
        if (pointArr[i].CGPointValue.y < minY) {
            minY = pointArr[i].CGPointValue.y;
        }
    }
    if (tingHV == WZZInsideNode_H) {
        //水平
        heightNode.startPoint = CGPointMake(minX, minY+border/2.0f);
        heightNode.endPoint = CGPointMake(maxX, minY+border/2.0f);
    } else {
        //垂直
        heightNode.startPoint = CGPointMake(minX+border/2.0f, minY);
        heightNode.endPoint = CGPointMake(minX+border/2.0f, maxY);
    }
    
    return heightNode;
}

@end
