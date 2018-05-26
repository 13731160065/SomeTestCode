//
//  WZZInsideNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZInsideNode.h"
#import "WZZWindowNode.h"

#define WZZInsideNode_BorderWidth 0.5f

@implementation WZZInsideNode

- (instancetype)initInsideWithWindow:(WZZWindowNode *)node
{
    self = [super init];
    if (self) {
        //转换为自己的坐标
        NSMutableArray * thisPath = [NSMutableArray array];
        [thisPath addObject:[NSValue valueWithCGPoint:CGPointZero]];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        
        CGPoint point1 = node.insetPoints[0].CGPointValue;
        for (int i = 1; i < node.insetPoints.count; i++) {
            NSValue * value = node.insetPoints[i];
            
            //转换坐标
            CGPoint newPoint = CGPointMake(value.CGPointValue.x-point1.x, value.CGPointValue.y-point1.y);
            [thisPath addObject:[NSValue valueWithCGPoint:newPoint]];
            [path addLineToPoint:newPoint];
        }
        _points = thisPath;
        
        SCNShape * shape2 = [SCNShape shapeWithPath:path extrusionDepth:0.3f];
        self.geometry = shape2;
        self.position = SCNVector3Make(point1.x, point1.y, 0);
        
        //设置node等级并使全局等级++
        self.nodeLevel = WZZInsideNode_Node_Level++;
    }
    return self;
}

- (void)cutWithPosition:(CGPoint)point {
    self.geometry = nil;
    const CGFloat lineBorderWidth = WZZInsideNode_BorderWidth;
    
    if ([WZZShapeHandler shareInstance].insideHV == WZZInsideNode_H) {
        //水平
        if (point.y) {
            CGPoint pointUp = CGPointMake(point.x, point.y+lineBorderWidth/2.0f);
            CGPoint pointDown = CGPointMake(point.x, point.y-lineBorderWidth/2.0f);
            CGFloat littleY = _points[1].CGPointValue.y<_points[2].CGPointValue.y?_points[1].CGPointValue.y:_points[2].CGPointValue.y;
            CGFloat endPointX = _points[2].CGPointValue.x;
            
            if (point.y < littleY) {
                CGPoint hp1 = CGPointMake(0, pointDown.y);
                CGPoint hp2 = CGPointMake(0, pointUp.y);
                CGPoint hp3 = CGPointMake(endPointX, pointUp.y);
                CGPoint hp4 = CGPointMake(endPointX, pointDown.y);
                
                //创建横挺
                UIBezierPath * path = [UIBezierPath bezierPath];
                [path moveToPoint:hp1];
                [path addLineToPoint:hp2];
                [path addLineToPoint:hp3];
                [path addLineToPoint:hp4];
                SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:lineBorderWidth];
                SCNNode * heightNode = [SCNNode nodeWithGeometry:shape];
                [self addChildNode:heightNode];
                heightNode.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
                
                //创建window1
                NSMutableArray * w1PointArr = [NSMutableArray array];
                [w1PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
                [w1PointArr addObject:[NSValue valueWithCGPoint:hp1]];
                [w1PointArr addObject:[NSValue valueWithCGPoint:hp4]];
                [w1PointArr addObject:_points[3]];
                WZZWindowNode * window1 = [WZZWindowNode nodeWithPoints:w1PointArr hasBorder:NO];
                [self addChildNode:window1];
                
                //创建window2
                CGPoint w2_2 = CGPointMake(0, _points[1].CGPointValue.y-hp2.y);
                CGPoint w2_3 = CGPointMake(_points[2].CGPointValue.x, _points[2].CGPointValue.y-hp3.y);
                CGPoint w2_4 = CGPointMake(_points[3].CGPointValue.x, 0);
                NSMutableArray * w2PointArr = [NSMutableArray array];
                [w2PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_2]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_3]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_4]];
                WZZWindowNode * window2 = [WZZWindowNode nodeWithPoints:w2PointArr hasBorder:NO];
                [self addChildNode:window2];
                [window2 setPosition:SCNVector3Make(0, hp3.y, 0)];
            }
        }
    } else {
        CGPoint pointLeft = CGPointMake(point.x-lineBorderWidth/2.0f, point.y);
        CGPoint pointRight = CGPointMake(point.x+lineBorderWidth/2.0f, point.y);
        //垂直
        CGFloat lineBig = _points[3].CGPointValue.x;
        CGFloat heightBig = _points[1].CGPointValue.y-_points[2].CGPointValue.y;
        CGFloat lineLeftSmall = lineBig-pointLeft.x;
        CGFloat lineRightSmall = lineBig-pointRight.x;

        //左右高，根据全等三角形等比+梯形短边
        CGFloat heightLeft = (lineLeftSmall/lineBig*heightBig)+_points[2].CGPointValue.y;
        CGFloat heightRight = (lineRightSmall/lineBig*heightBig)+_points[2].CGPointValue.y;

        //路径点
        CGPoint hp1 = CGPointMake(pointLeft.x, 0);
        CGPoint hp2 = CGPointMake(pointLeft.x, heightLeft);
        CGPoint hp3 = CGPointMake(pointRight.x, heightRight);
        CGPoint hp4 = CGPointMake(pointRight.x, 0);
        
        //创建竖挺
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:hp1];
        [path addLineToPoint:hp2];
        [path addLineToPoint:hp3];
        [path addLineToPoint:hp4];
        SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:lineBorderWidth];
        SCNNode * heightNode = [SCNNode nodeWithGeometry:shape];
        [self addChildNode:heightNode];
        heightNode.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
        
        //创建window1
        NSMutableArray * w1PointArr = [NSMutableArray array];
        [w1PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
        [w1PointArr addObject:_points[1]];
        [w1PointArr addObject:[NSValue valueWithCGPoint:hp2]];
        [w1PointArr addObject:[NSValue valueWithCGPoint:hp1]];
        WZZWindowNode * window1 = [WZZWindowNode nodeWithPoints:w1PointArr hasBorder:NO];
        [self addChildNode:window1];
        
        //创建window2
        CGPoint w2_2 = CGPointMake(0, hp3.y);
        CGPoint w2_3 = CGPointMake(_points[2].CGPointValue.x-hp4.x, _points[2].CGPointValue.y);
        CGPoint w2_4 = CGPointMake(_points[3].CGPointValue.x-hp4.x, 0);
        NSMutableArray * w2PointArr = [NSMutableArray array];
        [w2PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_2]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_3]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_4]];
        WZZWindowNode * window2 = [WZZWindowNode nodeWithPoints:w2PointArr hasBorder:NO];
        [self addChildNode:window2];
        [window2 setPosition:SCNVector3Make(hp4.x, 0, 0)];
    }
}

- (void)fillWithInside:(WZZInsideNode *)insideNode {
    self.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Fill;
    self.geometry.firstMaterial.transparency = 0.5f;
    self.insideType = WZZInsideNodeContentType_Fill;
}

- (void)nodeClick:(SCNHitTestResult *)result {
    NSLog(@"inside点击");
    CGPoint touchPoint = CGPointMake([result localCoordinates].x, [result localCoordinates].y);
    if (self.insideType == WZZInsideNodeContentType_None) {
        if ([WZZShapeHandler shareInstance].insideAction == WZZInsideNode_Action_Cut) {
            //切割
            [self cutWithPosition:touchPoint];
        }if ([WZZShapeHandler shareInstance].insideAction == WZZInsideNode_Action_Fill) {
            //填充
            [self fillWithInside:nil];
        } else {
            //none
        }
    }
}

@end
