//
//  WZZInsideNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZInsideNode.h"
#import "WZZWindowNode.h"
#import "WZZZhongTingNode.h"
#import "WZZTextureFillNode.h"
#import "WZZShanFillNode.h"

//中挺宽度
#define WZZInsideNode_BorderWidth WZZShapeHandler_mm_cm(5)

@implementation WZZInsideNode

- (instancetype)initInsideWithWindow:(WZZWindowNode *)node nodeLevel:(NSInteger)nodeLevel
{
    self = [super init];
    if (self) {
        //转换为自己的坐标
        NSMutableArray * thisPath = [NSMutableArray array];
        [thisPath addObject:[NSValue valueWithCGPoint:CGPointZero]];
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        
        self.superWindow = node;
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
        self.geometry.firstMaterial.transparency = 0.0f;
        
        self.nodeLevel = nodeLevel;
    }
    return self;
}

- (instancetype)initInsideWithWindow:(WZZWindowNode *)node {
    //自动设置node等级并使全局等级++
    return [self initInsideWithWindow:node nodeLevel:WZZInsideNode_Node_Level++];
}

- (void)cutWithPosition:(CGPoint)point {
    const CGFloat lineBorderWidth = WZZInsideNode_BorderWidth;
    
    if ([WZZShapeHandler shareInstance].insideHV == WZZInsideNode_H) {
        //水平
        if (point.y) {
            CGPoint pointUp = CGPointMake(point.x, point.y+lineBorderWidth/2.0f);
            CGPoint pointDown = CGPointMake(point.x, point.y-lineBorderWidth/2.0f);
            CGFloat littleY = _points[1].CGPointValue.y<_points[2].CGPointValue.y?_points[1].CGPointValue.y:_points[2].CGPointValue.y;
            CGFloat endPointX = _points[2].CGPointValue.x;
            
            if (point.y < littleY) {
                self.geometry = nil;
                CGPoint hp1 = CGPointMake(0, pointDown.y);
                CGPoint hp2 = CGPointMake(0, pointUp.y);
                CGPoint hp3 = CGPointMake(endPointX, pointUp.y);
                CGPoint hp4 = CGPointMake(endPointX, pointDown.y);
                
                NSArray * hpArr = @[[NSValue valueWithCGPoint:hp1],
                                    [NSValue valueWithCGPoint:hp2],
                                    [NSValue valueWithCGPoint:hp3],
                                    [NSValue valueWithCGPoint:hp4]];
                
                //创建横挺
                WZZZhongTingNode * heightNode = [WZZZhongTingNode nodeWithPath:hpArr superNode:self tingHV:[WZZShapeHandler shareInstance].insideHV border:WZZInsideNode_BorderWidth];
                [self addChildNode:heightNode];
                heightNode.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
                self.insideZhongTing = heightNode;
                
                //创建window1，上边的window
                NSMutableArray * w1PointArr = [NSMutableArray array];
                [w1PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
                [w1PointArr addObject:[NSValue valueWithCGPoint:hp1]];
                [w1PointArr addObject:[NSValue valueWithCGPoint:hp4]];
                [w1PointArr addObject:_points[3]];
                WZZWindowNode * window1 = [WZZWindowNode nodeWithPoints:w1PointArr windowBorderType:WZZShapeHandler_WindowBorderType_None];
                [self addChildNode:window1];
                window1.borderUpTing = self.insideZhongTing;
                window1.borderLeftTing = self.superWindow.borderLeftTing;
                window1.borderRightTing = self.superWindow.borderRightTing;
                window1.borderDownTing = self.superWindow.borderDownTing;
                
                //创建window2，下边的window
                CGPoint w2_2 = CGPointMake(0, _points[1].CGPointValue.y-hp2.y);
                CGPoint w2_3 = CGPointMake(_points[2].CGPointValue.x, _points[2].CGPointValue.y-hp3.y);
                CGPoint w2_4 = CGPointMake(_points[3].CGPointValue.x, 0);
                NSMutableArray * w2PointArr = [NSMutableArray array];
                [w2PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_2]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_3]];
                [w2PointArr addObject:[NSValue valueWithCGPoint:w2_4]];
                WZZWindowNode * window2 = [WZZWindowNode nodeWithPoints:w2PointArr windowBorderType:WZZShapeHandler_WindowBorderType_None];
                [self addChildNode:window2];
                [window2 setPosition:SCNVector3Make(0, hp3.y, 0)];
                window2.borderUpTing = self.superWindow.borderUpTing;
                window2.borderLeftTing = self.superWindow.borderLeftTing;
                window2.borderRightTing = self.superWindow.borderRightTing;
                window2.borderDownTing = self.insideZhongTing;
                
                //对window赋值，从下往上
                [self setInsideWindow:@[window2, window1]];
                
                [[[WZZShapeHandler shareInstance] allTings] addObject:self.insideZhongTing];
            }
        }
    } else {
        self.geometry = nil;
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
        
        NSArray * hpArr = @[[NSValue valueWithCGPoint:hp1],
                            [NSValue valueWithCGPoint:hp2],
                            [NSValue valueWithCGPoint:hp3],
                            [NSValue valueWithCGPoint:hp4]];
        
        //创建竖挺
        WZZZhongTingNode * heightNode = [WZZZhongTingNode nodeWithPath:hpArr superNode:self tingHV:[WZZShapeHandler shareInstance].insideHV border:WZZInsideNode_BorderWidth];
        [self addChildNode:heightNode];
        heightNode.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
        self.insideZhongTing = heightNode;
        
        //创建window1，左边的window
        NSMutableArray * w1PointArr = [NSMutableArray array];
        [w1PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
        [w1PointArr addObject:_points[1]];
        [w1PointArr addObject:[NSValue valueWithCGPoint:hp2]];
        [w1PointArr addObject:[NSValue valueWithCGPoint:hp1]];
        WZZWindowNode * window1 = [WZZWindowNode nodeWithPoints:w1PointArr windowBorderType:WZZShapeHandler_WindowBorderType_None];
        [self addChildNode:window1];
        window1.borderUpTing = self.superWindow.borderUpTing;
        window1.borderLeftTing = self.superWindow.borderLeftTing;
        window1.borderRightTing = self.insideZhongTing;
        window1.borderDownTing = self.superWindow.borderDownTing;
        
        //创建window2，右边的window
        CGPoint w2_2 = CGPointMake(0, hp3.y);
        CGPoint w2_3 = CGPointMake(_points[2].CGPointValue.x-hp4.x, _points[2].CGPointValue.y);
        CGPoint w2_4 = CGPointMake(_points[3].CGPointValue.x-hp4.x, 0);
        NSMutableArray * w2PointArr = [NSMutableArray array];
        [w2PointArr addObject:[NSValue valueWithCGPoint:CGPointZero]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_2]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_3]];
        [w2PointArr addObject:[NSValue valueWithCGPoint:w2_4]];
        WZZWindowNode * window2 = [WZZWindowNode nodeWithPoints:w2PointArr windowBorderType:WZZShapeHandler_WindowBorderType_None];
        [self addChildNode:window2];
        [window2 setPosition:SCNVector3Make(hp4.x, 0, 0)];
        window2.borderUpTing = self.superWindow.borderUpTing;
        window2.borderLeftTing = self.insideZhongTing;
        window2.borderRightTing = self.superWindow.borderRightTing;
        window2.borderDownTing = self.superWindow.borderDownTing;
        
        //对window赋值
        [self setInsideWindow:@[window1, window2]];
        
        [[[WZZShapeHandler shareInstance] allTings] addObject:self.insideZhongTing];
    }
}

- (void)fillWithInside:(WZZInsideNodeContentType)fillType {
    self.insideType = fillType;
    switch (fillType) {
        case WZZInsideNodeContentType_Fill_Texture_Glass:
        {
            
            WZZTextureFillNode * node = [WZZTextureFillNode fillNodeWithPointsArray:self.points deep:WZZInsideNode_BorderWidth/2.0f texture:WZZTextureFillNode_textureType_Glass];
            [self addChildNode:node];
            node.superNode = self;
            self.insideFill = node;
        }
            break;
        case WZZInsideNodeContentType_Fill_Shan_NormalShan:
        {
            WZZShanFillNode * node = [WZZShanFillNode fillNodeWithPointsArray:self.points deep:WZZInsideNode_BorderWidth shanType:WZZShanFillNode_ShanType_NormalShan shanBorderWidth:WZZInsideNode_BorderWidth];
            [self addChildNode:node];
            node.superNode = self;
            self.insideFill = node;
        }
            break;
        case WZZInsideNodeContentType_Turn:
        {
            [self.superWindow changeTurnBorderType:self.superWindow.windowBorderType];
        }
            break;

        default:
            break;
    }
}

- (void)nodeClick:(SCNHitTestResult *)result {
    NSLog(@"inside点击");
    CGPoint touchPoint = CGPointMake([result localCoordinates].x, [result localCoordinates].y);
    if (self.insideType == WZZInsideNodeContentType_None) {
        //如果是空的可以随意操作
        if ([WZZShapeHandler shareInstance].insideAction == WZZInsideNode_Action_Cut) {
            //切割
            [self cutWithPosition:touchPoint];
        } if ([WZZShapeHandler shareInstance].insideAction == WZZInsideNode_Action_Fill) {
            //填充
            [self fillWithInside:[WZZShapeHandler shareInstance].insideContentType];
        } else {
            //none
        }
    } else if ([WZZShapeHandler shareInstance].insideContentType == WZZInsideNodeContentType_Turn) {
        //如果内容不是空的，但填充是转向框，可以做转向框操作
        [self fillWithInside:[WZZShapeHandler shareInstance].insideContentType];
    }
}

//重写删除方法，删除中挺
- (void)removeFromParentNode {
    [[[WZZShapeHandler shareInstance] allTings] removeObject:self.insideZhongTing];
    [super removeFromParentNode];
}

@end
