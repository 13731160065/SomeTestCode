//
//  WZZWindowBorderTingNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/27.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZWindowBorderTingNode.h"

@implementation WZZWindowBorderTingNode

+ (instancetype)nodeWithPath:(NSArray<NSValue *> *)pointArr
                   superNode:(SCNNode *)superNode
                      border:(CGFloat)border {
    WZZWindowBorderTingNode * node = [super nodeWithPath:pointArr superNode:superNode border:border];
    node.startPoint = pointArr[0].CGPointValue;
    node.endPoint = pointArr[1].CGPointValue;
    return node;
}

@end
