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
#import "WZZWindowBorderTingNode.h"

#define WZZWindowNode_BorderWidth WZZShapeHandler_mm_cm(7)

@implementation WZZWindowNode

//用点创建window
+ (instancetype)nodeWithPoints:(NSArray <NSValue *>*)points
                     hasBorder:(BOOL)hasBorder {
    WZZWindowNode * node = [WZZWindowNode node];
    [node setupNodeWithPoints:points hasBorder:hasBorder];
    [[[WZZShapeHandler shareInstance] allWindows] addObject:node];
    node.geometry.firstMaterial.transparency = 0.0f;
    return node;
}

//用高度创建window
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

+ (instancetype)nodeWithHeight:(CGFloat)height
                         width:(CGFloat)width
                     hasBorder:(BOOL)hasBorder {
    return [self nodeWithLeftHeight:height rightHeight:height downWidth:width hasBorder:hasBorder];
}

//初始化window
- (void)setupNodeWithPoints:(NSArray <NSValue *>*)points hasBorder:(BOOL)hasBorder {
    //初始化window
    self.hasBorder = hasBorder;
    self.outPoints = [NSArray arrayWithArray:points];
    if (hasBorder) {
#if 1
        if (points.count == 3) {
            [self makeBorder3WithPoints:points];
        } else {
            [self makeBorderWithPoints:points];
        }
#else
        [self makeAnyBorderWithPoints:points];
#endif
        [self createBorderTingWithOutPoints:self.outPoints inPoints:self.insetPoints];
    } else {
        self.insetPoints = [NSArray arrayWithArray:points];
    }
    
    //初始化window的insideNode
    WZZInsideNode * InsideNode = [[WZZInsideNode alloc] initInsideWithWindow:self];
    [self addChildNode:InsideNode];
    self.insideContent = InsideNode;
}

- (void)makeAnyBorderWithPoints:(NSArray *)points {
    if (points.count < 3) {
        return;
    }
    
    [WZZShapeHandler showPointWithNode:self points:points color:[UIColor redColor]];
    [WZZShapeHandler showPointWithNode:self points:[WZZShapeHandler makeAnyBorder2WithLinkArray:[WZZLinkedArray arrayWithArray:points]] color:[UIColor greenColor]];
}

//创建边框
- (void)createBorderTingWithOutPoints:(NSArray <NSValue *>*)outPoints
                             inPoints:(NSArray <NSValue *>*)inPoints {
    WZZLinkedArray * outArr = [WZZLinkedArray arrayWithArray:outPoints];
    WZZLinkedArray * inArr = [WZZLinkedArray arrayWithArray:inPoints];
    if (outArr.array.count == inArr.array.count) {
        NSMutableArray * borderArr = [NSMutableArray array];
        for (int i = 0; i < outArr.array.count; i++) {
            CGPoint point1 = WZZShapeHandler_LinkedObjectToPoint(outArr.array[i]);
            CGPoint point2 = WZZShapeHandler_LinkedObjectToPoint(outArr.array[i].nextObj);
            CGPoint point3 = WZZShapeHandler_LinkedObjectToPoint(inArr.array[i].nextObj);
            CGPoint point4 = WZZShapeHandler_LinkedObjectToPoint(inArr.array[i]);
            
            NSArray * pointArr = @[
                                   [NSValue valueWithCGPoint:point1],
                                   [NSValue valueWithCGPoint:point2],
                                   [NSValue valueWithCGPoint:point3],
                                   [NSValue valueWithCGPoint:point4]
                                   ];
            WZZWindowBorderTingNode * node = [WZZWindowBorderTingNode nodeWithPath:pointArr superNode:self border:WZZWindowNode_BorderWidth];
            [self addChildNode:node];
            node.geometry.firstMaterial.diffuse.contents = WZZShapeHandlerTexture_Border;
            [borderArr addObject:node];
        }
        
        //以下仅适用4边形
        [self setupRectBorder:borderArr];
    }
}

//仅适用于矩形的边框
- (void)setupRectBorder:(NSArray <WZZWindowBorderTingNode *>*)borderArr {
    self.borderLeftTing = borderArr[0];
    self.borderUpTing = borderArr[1];
    self.borderRightTing = borderArr[2];
    self.borderDownTing = borderArr[3];
    
    //添加至全部挺中
    [[[WZZShapeHandler shareInstance] allTings] addObjectsFromArray:borderArr];
}

//创建4边形边框
- (void)makeBorderWithPoints:(NSArray *)points {
    if (points.count != 4) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeBorderWithLinkArray:[WZZLinkedArray arrayWithArray:points] border:WZZWindowNode_BorderWidth];
    self.insetPoints = [NSArray arrayWithArray:mpArr];
#if 0
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
#endif
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

#pragma mark - 属性

@end
