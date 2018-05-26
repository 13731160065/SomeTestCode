//
//  WZZ2DButtonNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZ2DButtonNode.h"

@implementation WZZ2DButtonNode

//用geomerty创建
- (instancetype)initWithSuperNode:(SCNNode *)superNode
                         geometry:(SCNGeometry *)geometry
                         clickSel:(SEL)clickSel {
    self = [super init];
    if (self) {
        _superNode = superNode;
        self.geometry = geometry;
        _clickSel = clickSel;
    }
    return self;
}

//用path创建
- (instancetype)initWithSuperNode:(SCNNode *)superNode
                             path:(UIBezierPath *)path
                         clickSel:(SEL)clickSel {
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:1];
    self = [[WZZ2DButtonNode alloc] initWithSuperNode:superNode geometry:shape clickSel:clickSel];
    [self setPosition:SCNVector3Make(self.position.x, self.position.y, self.position.z+1)];
    return self;
}

@end
