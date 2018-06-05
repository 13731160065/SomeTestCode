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
#import "WZZWindowDataHandler.h"

#define WZZWindowNode_BorderWidth WZZShapeHandler_mm_cm(7)

@implementation WZZWindowNode

//用点创建window
+ (instancetype)nodeWithPoints:(NSArray <NSValue *>*)points
              windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType{
    WZZWindowNode * node = [WZZWindowNode node];
    [node setupNodeWithPoints:points windowBorderType:windowBorderType borderWidth:WZZWindowNode_BorderWidth];
    [node setupInside];
    [[[WZZWindowDataHandler shareInstance] allWindows] addObject:node];
    node.geometry.firstMaterial.transparency = 0.0f;
    return node;
}

//用高度创建window
+ (instancetype)nodeWithLeftHeight:(CGFloat)leftH
                       rightHeight:(CGFloat)rightH
                         downWidth:(CGFloat)downWidth
                  windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType {
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, leftH)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(downWidth, rightH)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(downWidth, 0)]];
    WZZWindowNode * node233 = [WZZWindowNode nodeWithPoints:arr windowBorderType:windowBorderType];
    [node233 setPosition:SCNVector3Make(-downWidth/2, -(leftH+rightH)/4.0f, 0)];
    return node233;
}

+ (instancetype)nodeWithHeight:(CGFloat)height
                         width:(CGFloat)width
              windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType {
    return [self nodeWithLeftHeight:height rightHeight:height downWidth:width windowBorderType:windowBorderType];
}

//初始化window
- (void)setupNodeWithPoints:(NSArray <NSValue *>*)points
           windowBorderType:(WZZShapeHandler_WindowBorderType)windowBorderType
                borderWidth:(CGFloat)borderWidth {
    //初始化window
    self.windowBorderType = windowBorderType;
    self.outPoints = [NSArray arrayWithArray:points];
    if (windowBorderType == WZZShapeHandler_WindowBorderType_None) {
        self.insetPoints = [NSArray arrayWithArray:points];
    } else {
#if 0
        if (points.count == 3) {
            [self makeBorder3WithPoints:points border:borderWidth];
        } else {
            [self makeBorderWithPoints:points border:borderWidth];
        }
#else
        [self makeAnyBorderWithPoints:points border:borderWidth];
#endif
        [self createBorderTingWithOutPoints:self.outPoints inPoints:self.insetPoints];
    }
}

- (void)setupInside {
    //初始化window的insideNode
    self.insideContent = [[WZZInsideNode alloc] initInsideWithWindow:self];
    [self addChildNode:self.insideContent];
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
    if (self.windowBorderType == WZZShapeHandler_WindowBorderType_RootWindowBorder) {
        self.borderLeftTing = borderArr[0];
        self.borderUpTing = borderArr[1];
        self.borderRightTing = borderArr[2];
        self.borderDownTing = borderArr[3];
    }
    //添加至全部挺中
    [[[WZZWindowDataHandler shareInstance] allTings] addObjectsFromArray:borderArr];
}

- (void)makeAnyBorderWithPoints:(NSArray *)points
                         border:(CGFloat)border{
    if (points.count < 3) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeAnyBorder3WithLinkArray:[WZZLinkedArray arrayWithArray:points] border:border];
    self.insetPoints = [NSArray arrayWithArray:mpArr];
}

//创建4边形边框
- (void)makeBorderWithPoints:(NSArray *)points
                      border:(CGFloat)border {
    if (points.count != 4) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeBorderWithLinkArray:[WZZLinkedArray arrayWithArray:points] border:border];
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
- (void)makeBorder3WithPoints:(NSArray *)points
                       border:(CGFloat)border {
    if (points.count != 3) {
        return;
    }
    
    NSArray <NSValue *>* mpArr = [WZZShapeHandler makeBorder3WithLinkArray:[WZZLinkedArray arrayWithArray:points] border:border];
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
    [self nodeClickPoint:CGPointMake(result.localCoordinates.x, result.localCoordinates.y)];
}

- (void)nodeClickPoint:(CGPoint)result {
    
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

//修改转向框状态
- (void)changeTurnBorderType:(WZZShapeHandler_WindowBorderType)turnBorderType {
    //转换边框类型
    if (turnBorderType == WZZShapeHandler_WindowBorderType_RootWindowBorder) {
        return;
    } else if (turnBorderType == WZZShapeHandler_WindowBorderType_None) {
        turnBorderType = WZZShapeHandler_WindowBorderType_TurnBorder;
    } else if (turnBorderType == WZZShapeHandler_WindowBorderType_TurnBorder) {
        turnBorderType = WZZShapeHandler_WindowBorderType_None;
    }
    [self enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    
    //旧inside
    WZZInsideNode * oldNode = self.insideContent;
    
    //新初始化window
    [self setupNodeWithPoints:_outPoints windowBorderType:turnBorderType borderWidth:WZZWindowNode_BorderWidth/2.0f];
    self.geometry.firstMaterial.transparency = 0.0f;
    
    //配置window的insideNode
    self.insideContent = [[WZZInsideNode alloc] initInsideWithWindow:self nodeLevel:oldNode.nodeLevel];
    [self addChildNode:self.insideContent];
}

#pragma mark - 属性

@end
