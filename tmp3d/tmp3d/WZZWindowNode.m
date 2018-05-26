//
//  WZZWindowNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/23.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZWindowNode.h"
#import "WZZ2DButtonNode.h"
#import "WZZLinkedArray.h"
#import "WZZShapeHandler.h"

#define WZZWindowNode_BorderWidth 0.7f

@implementation WZZWindowNode

+ (instancetype)nodeWithPoints:(NSArray <NSValue *>*)points
                     hasBorder:(BOOL)hasBorder {
    WZZWindowNode * node = [WZZWindowNode node];
    [node setupNodeWithPoints:points hasBorder:hasBorder];
    return node;
}

+ (instancetype)nodeWithLeftHeight:(CGFloat)leftH
                       rightHeight:(CGFloat)rightH
                         downWidth:(CGFloat)downWidth
                         hasBorder:(BOOL)hasBorder {
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, leftH)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(downWidth, rightH)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(downWidth, 0)]];
    WZZWindowNode * node233 = [WZZWindowNode nodeWithPoints:arr hasBorder:YES];
    [node233 setPosition:SCNVector3Make(-downWidth/2, -(leftH+rightH)/4.0f, 0)];
    return node233;
}

//初始化window
- (void)setupNodeWithPoints:(NSArray <NSValue *>*)points hasBorder:(BOOL)hasBorder {
    //初始化window
    self.hasBorder = hasBorder;
    if (hasBorder) {
//        if (points.count == 3) {
//            [self makeBorder3WithPoints:points];
//        } else {
//            [self makeBorderWithPoints:points];
//        }
        [self makeAnyBorderWithPoints:points];
    } else {
        self.insetPoints = [NSArray arrayWithArray:points];
    }
    self.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
    
    //初始化window的insideNode
    WZZInsideNode * InsideNode = [[WZZInsideNode alloc] initInsideWithWindow:self];
    [self addChildNode:InsideNode];
}

- (void)makeAnyBorderWithPoints:(NSArray *)points {
    if (points.count < 3) {
        return;
    }
    
    [WZZShapeHandler showPointWithNode:self points:points color:[UIColor redColor]];
    [WZZShapeHandler showPointWithNode:self points:[WZZShapeHandler makeAnyBorder2WithLinkArray:[WZZLinkedArray arrayWithArray:points]] color:[UIColor greenColor]];
}

//创建4边形边框
- (void)makeBorderWithPoints:(NSArray *)points {
    if (points.count != 4) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeBorderWithLinkArray:[WZZLinkedArray arrayWithArray:points] border:WZZWindowNode_BorderWidth];
    self.insetPoints = [NSArray arrayWithArray:mpArr];
    
    CGPoint point1 = [points[0] CGPointValue];
    CGPoint point2 = [points[1] CGPointValue];
    CGPoint point3 = [points[2] CGPointValue];
    CGPoint point4 = [points[3] CGPointValue];
    
    CGPoint mp1_ = [mpArr[0] CGPointValue];
    CGPoint mp2_ = [mpArr[1] CGPointValue];
    CGPoint mp3_ = [mpArr[2] CGPointValue];
    CGPoint mp4_ = [mpArr[3] CGPointValue];
    
    //路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:mp4_];
    [path addLineToPoint:mp3_];
    [path addLineToPoint:mp2_];
    [path addLineToPoint:mp1_];
    
    //底部
    [path moveToPoint:point1];
    [path addLineToPoint:mp1_];
    [path addLineToPoint:mp4_];
    [path addLineToPoint:point4];
    
    //node
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:WZZWindowNode_BorderWidth];
    shape.chamferRadius = 0.3f;
    self.geometry = shape;
}

//创建3边形边框
- (void)makeBorder3WithPoints:(NSArray *)points {
    if (points.count != 3) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeBorder3WithLinkArray:[WZZLinkedArray arrayWithArray:points] border:WZZWindowNode_BorderWidth];
    self.insetPoints = [NSArray arrayWithArray:mpArr];
    
    CGPoint point1 = [points[0] CGPointValue];
    CGPoint point2 = [points[1] CGPointValue];
    CGPoint point3 = [points[2] CGPointValue];
    
    CGPoint mp1_ = [mpArr[0] CGPointValue];
    CGPoint mp2_ = [mpArr[1] CGPointValue];
    CGPoint mp3_ = [mpArr[2] CGPointValue];
    
    //路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:mp3_];
    [path addLineToPoint:mp2_];
    [path addLineToPoint:mp1_];
    
    //底部
    [path moveToPoint:point1];
    [path addLineToPoint:mp1_];
    [path addLineToPoint:mp3_];
    [path addLineToPoint:point3];
    
    //node
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:WZZWindowNode_BorderWidth];
    shape.chamferRadius = 0.3f;
    self.geometry = shape;
}

- (void)nodeClick:(SCNHitTestResult *)result {
    NSLog(@"window点击");
    
}

//创建面
- (void)makeShapeWithPoints:(NSArray <NSValue *>*)points {
    //路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint point1 = [[points firstObject] CGPointValue];
    [path moveToPoint:point1];
    for (int i = 1; i < points.count; i++) {
        CGPoint pointn = [points[i] CGPointValue];
        [path addLineToPoint:pointn];
    }
    
    //node
    SCNShape * shape = [SCNShape shapeWithPath:path extrusionDepth:0.5f];
    shape.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.0f green:0.3f blue:1.0f alpha:0.5f];
    
    self.geometry = shape;
}

@end
