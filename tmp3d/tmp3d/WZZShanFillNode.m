//
//  WZZShanFillNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZShanFillNode.h"
#import "WZZTingNode.h"
#import "WZZWindowBorderTingNode.h"
#import "WZZTextureFillNode.h"
#import "WZZWindowNode.h"
#import "DoorWindowCalculationFormulaObjective.h"
#import "WZZWindowDataHandler.h"

typedef struct WZZShanFillNode_BaseData {
    CalculationFormula h;
    CalculationFormula v;
    CGFloat hf;
    CGFloat vf;
} WZZShanFillNode_BaseData;

@interface WZZShanFillNode () {
    WZZShanFillNode_BaseData baseData;
    WZZShanFillNode_BaseData shanData;
    WZZShanFillNode_BaseData turnData;
}

@end

@implementation WZZShanFillNode

+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep
                               shanType:(WZZShanFillNode_ShanType)shanType
                        shanBorderWidth:(CGFloat)shanBorderWidth {
    WZZShanFillNode * node = [self fillNodeWithPointsArray:pointsArray deep:deep];
    node.shanBorderWidth = shanBorderWidth;
    [node setShanType:shanType];
    [node fillWithShan];
    return node;
}

- (void)fillWithShan {
    self.geometry.firstMaterial.transparency = 0.0f;
    self.geometry.firstMaterial.diffuse.contents = nil;
    
    switch (self.shanType) {
        case WZZShanFillNode_ShanType_NormalShan:
        {
            NSArray * pointsArr = [WZZShapeHandler makeBorderWithLinkArray:[WZZLinkedArray arrayWithArray:self.pointsArray] border:self.shanBorderWidth];
            [self createBorderTingWithOutPoints:self.pointsArray inPoints:pointsArr];
            WZZTextureFillNode * tfNode = [WZZTextureFillNode fillNodeWithPointsArray:pointsArr deep:self.deep texture:WZZTextureFillNode_textureType_Glass];
            [self addChildNode:tfNode];
        }
            break;
            
        default:
            break;
    }
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
            WZZWindowBorderTingNode * node = [WZZWindowBorderTingNode nodeWithPath:pointArr superNode:self border:self.shanBorderWidth];
            [self addChildNode:node];
            node.name = @"glassNode";
            node.geometry.firstMaterial.diffuse.contents = @"mucai005.jpg";
            [borderArr addObject:node];
        }
    }
}

//基础数据
- (void)handleBaseData {
    WZZWindowNode * windowNode = self.superNode.superWindow;
    SCNVector3 upTV3 = SCNVector3Make(windowNode.borderUpTing.startPoint.x, windowNode.borderUpTing.startPoint.y, 0);
    SCNVector3 downTV3 = SCNVector3Make(windowNode.borderDownTing.startPoint.x, windowNode.borderDownTing.startPoint.y, 0);
    SCNVector3 rightTV3 = SCNVector3Make(windowNode.borderRightTing.startPoint.x, windowNode.borderRightTing.startPoint.y, 0);
    SCNVector3 leftTV3 = SCNVector3Make(windowNode.borderLeftTing.startPoint.x, windowNode.borderLeftTing.startPoint.y, 0);
    
    WZZWindowNode * rootWindow = [WZZWindowDataHandler shareInstance].allWindows.firstObject;
    
    upTV3 = [windowNode.borderUpTing convertPosition:upTV3 toNode:rootWindow];
    downTV3 = [windowNode.borderDownTing convertPosition:downTV3 toNode:rootWindow];
    rightTV3 = [windowNode.borderRightTing convertPosition:rightTV3 toNode:rootWindow];
    leftTV3 = [windowNode.borderLeftTing convertPosition:leftTV3 toNode:rootWindow];
    
    CGPoint upTP = CGPointMake(upTV3.x, upTV3.y);
    CGPoint downTP = CGPointMake(downTV3.x, downTV3.y);
    CGPoint rightTP = CGPointMake(rightTV3.x, rightTV3.y);
    CGPoint leftTP = CGPointMake(leftTV3.x, leftTV3.y);
    
    CGFloat shuTing = fabs(upTP.y-downTP.y);
    CGFloat hengTing = fabs(rightTP.x-leftTP.x);
    
    NSLog(@"tag:[%zd], uy(%lf)-dy(%lf), rx(%lf)-lx(%lf)", windowNode.insideContent.nodeLevel,
          upTP.y,
          downTP.y,
          rightTP.x,
          leftTP.x
          );
    NSLog(@"T(%lf, %lf)", hengTing, shuTing);
    
    //计算数据
    //计算两挺之间距离的类型
    WZZShapeHandler_FromTo shuTingType = 0;
    WZZShapeHandler_FromTo hengTingType = 0;
    
    //方向
    CalculationFormula hCalType = (CalculationFormula)hengTingType;
    CalculationFormula vCalType = (CalculationFormula)shuTingType;
    
    baseData.h = hCalType;
    baseData.v = vCalType;
    baseData.hf = hengTing;
    baseData.vf = shuTing;
}

//计算扇尺寸
- (id)handleData {
    NSMutableArray * dataArr = [NSMutableArray array];
    switch (self.shanType) {
        case WZZShanFillNode_ShanType_NormalShan:
        {
            [self handleBaseData];
            //带不带转向框
            ScreenWindowTurn turn = self.superNode.superWindow.windowBorderType?ScreenWindowTurn_YES:ScreenWindowTurn_NO;
            CGFloat hh = [DoorWindowCalculationFormulaObjective DoorWindowFanCalculationFormula:baseData.h screenWindowTurn:turn distance:baseData.hf];
            CGFloat vv = [DoorWindowCalculationFormulaObjective DoorWindowFanCalculationFormula:baseData.v screenWindowTurn:turn distance:baseData.vf];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
            shanData.h = baseData.h;
            shanData.v = baseData.v;
            shanData.hf = hh;
            shanData.vf = vv;
        }
            break;
            
        default:
            break;
    }
    return dataArr;
}

//转向框
- (NSArray<NSString *> *)handleTurnData {
    if (self.superNode.superWindow.windowBorderType == WZZShapeHandler_WindowBorderType_TurnBorder) {
        [self handleBaseData];
        turnData.hf = [DoorWindowCalculationFormulaObjective DoorWindowToTurnToCircleCalculationFormula:baseData.h distance:baseData.hf];
        turnData.vf = [DoorWindowCalculationFormulaObjective DoorWindowToTurnToCircleCalculationFormula:baseData.v distance:baseData.vf];
        turnData.h = baseData.h;
        turnData.v = baseData.v;
        
        NSMutableArray * dataArr = [NSMutableArray array];
        [dataArr addObject:[NSString stringWithFormat:@"%.2lf", turnData.hf]];
        [dataArr addObject:[NSString stringWithFormat:@"%.2lf", turnData.vf]];
        return dataArr;
    } else {
        return nil;
    }
}

//纱窗
- (NSArray<NSString *> *)handleShaData {
    NSMutableArray * dataArr = [NSMutableArray array];
    switch (self.shanType) {
        case WZZShanFillNode_ShanType_NormalShan:
        {
            [self handleBaseData];
            //带转向框
            ScreenWindowTurn turn = self.superNode.superWindow.windowBorderType?ScreenWindowTurn_YES:ScreenWindowTurn_NO;
            CGFloat hh = [DoorWindowCalculationFormulaObjective DoorWindowScreenWindowCalculationFormula:baseData.h screenWindowTurn:turn distance:baseData.hf];
            CGFloat vv = [DoorWindowCalculationFormulaObjective DoorWindowScreenWindowCalculationFormula:baseData.v screenWindowTurn:turn distance:baseData.vf];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
        }
            break;
            
        default:
            break;
    }
    return dataArr;
}

//压线
- (NSArray<NSString *> *)handleShanLineData {
    [self handleData];
    
    CGFloat hh = [DoorWindowCalculationFormulaObjective DoorWindowFanPressingLineCalculationFormula:shanData.h distance:shanData.hf];
    CGFloat vv = [DoorWindowCalculationFormulaObjective DoorWindowFanPressingLineCalculationFormula:shanData.v distance:shanData.vf];
    NSMutableArray * dataArr = [NSMutableArray array];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
    return dataArr;
}

//内容
- (NSArray<NSString *> *)handleShanInsideData {
    [self handleData];
    
    CGFloat hh = [DoorWindowCalculationFormulaObjective DoorWindowFanGalssCalculationFormula:shanData.h distance:shanData.hf];
    CGFloat vv = [DoorWindowCalculationFormulaObjective DoorWindowFanGalssCalculationFormula:shanData.v distance:shanData.vf];
    NSMutableArray * dataArr = [NSMutableArray array];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", hh]];
    [dataArr addObject:[NSString stringWithFormat:@"%.2lf", vv]];
    return dataArr;
}

//计算边
- (CGSize)rectDataSize {
    CGPoint point1 = self.pointsArray[0].CGPointValue;
    CGPoint point2 = self.pointsArray[1].CGPointValue;
    CGPoint point3 = self.pointsArray[2].CGPointValue;
    
    CGFloat lineH = point2.y-point1.y;
    CGFloat lineV = point3.x-point2.x;
    
    return CGSizeMake(lineH, lineV);
}

@end
