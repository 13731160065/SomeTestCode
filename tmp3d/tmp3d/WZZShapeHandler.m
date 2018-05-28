//
//  WZZShapeHandler.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZShapeHandler.h"
#import "WZZLinkedArray.h"
#import "WZZWindowNode.h"
#import "WZZWindowBorderTingNode.h"
#import "WZZZhongTingNode.h"
#import "DoorWindowCalculationFormulaObjective.h"
@import UIKit;
@import SceneKit;

typedef enum : NSUInteger {
    WZZShapeHandler_FromTo_BToB,//边到边
    WZZShapeHandler_FromTo_BToC,//边到中
    WZZShapeHandler_FromTo_CToC//中到中
} WZZShapeHandler_FromTo;

#define radiansToDegrees(x) (180.0 * x / M_PI)

//两个线夹角角度
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    //弧度转角度
    NSLog(@"line1>%@, %@", [NSValue valueWithCGPoint:line1Start], [NSValue valueWithCGPoint:line1End]);
    NSLog(@"line2>%@, %@", [NSValue valueWithCGPoint:line2Start], [NSValue valueWithCGPoint:line2End]);
    NSLog(@"jd>%@º, %@", @(radiansToDegrees(rads)), @(rads));
    
    return rads;
}

static WZZShapeHandler * wzzShapeHandler;

@implementation WZZShapeHandler

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wzzShapeHandler = [[WZZShapeHandler alloc] init];
    });
    return wzzShapeHandler;
}

//创建边框
+ (NSArray <NSValue *>*)makeBorderWithLinkArray:(WZZLinkedArray *)linkArray
                                         border:(CGFloat)border {
    WZZLinkedObject * point1 = linkArray.array[0];
    WZZLinkedObject * point2 = linkArray.array[1];
    WZZLinkedObject * point3 = linkArray.array[2];
    WZZLinkedObject * point4 = linkArray.array[3];
    
    CGPoint mp2_, mp3_;
    
#pragma mark 主要点2
    //计算角度，两线夹角/2
    CGFloat mp2Angle = angleBetweenLines(
                                         WZZShapeHandler_LinkedObjectToPoint(point2),
                                         WZZShapeHandler_LinkedObjectToPoint(point1),
                                         WZZShapeHandler_LinkedObjectToPoint(point2),
                                         WZZShapeHandler_LinkedObjectToPoint(point3)
                                         )/2.0f;
    
    //tan函数计算距离
    CGFloat littleBorder2 = border/tan(mp2Angle);
    if (littleBorder2 < 0) {
        littleBorder2 = -littleBorder2;
    }
    mp2_ = CGPointMake(
                       WZZShapeHandler_LinkedObjectToPoint(point2).x+border,
                       WZZShapeHandler_LinkedObjectToPoint(point2).y-littleBorder2
                       );
    
#pragma mark - 主要点3
    //计算角度，两线夹角/2-90度，得到三角形除直角外的另一个叫，做三角函数计算
    CGFloat mp3Angle = angleBetweenLines(
                                         WZZShapeHandler_LinkedObjectToPoint(point3),
                                         WZZShapeHandler_LinkedObjectToPoint(point2),
                                         WZZShapeHandler_LinkedObjectToPoint(point3),
                                         WZZShapeHandler_LinkedObjectToPoint(point4)
                                         )/2.0f;
    //tan函数计算距离
    CGFloat littleBorder3 = border/tan(mp3Angle);
    if (littleBorder3 < 0) {
        littleBorder3 = -littleBorder3;
    }
    mp3_ = CGPointMake(
                       WZZShapeHandler_LinkedObjectToPoint(point3).x-border,
                       WZZShapeHandler_LinkedObjectToPoint(point3).y-littleBorder3
                       );
    
    NSLog(@"\n>>>%@\n>>>%@", [NSValue valueWithCGPoint:mp2_], [NSValue valueWithCGPoint:mp3_]);
    
    CGPoint mp1_ = CGPointMake(
                               WZZShapeHandler_LinkedObjectToPoint(point1).x+border,
                               WZZShapeHandler_LinkedObjectToPoint(point1).y+border
                               );
    CGPoint mp4_ = CGPointMake(
                               WZZShapeHandler_LinkedObjectToPoint(point4).x-border,
                               WZZShapeHandler_LinkedObjectToPoint(point4).y+border
                               );
    return @[
             [NSValue valueWithCGPoint:mp1_],
             [NSValue valueWithCGPoint:mp2_],
             [NSValue valueWithCGPoint:mp3_],
             [NSValue valueWithCGPoint:mp4_]
             ];
}

//创建三角形边框
+ (NSArray <NSValue *>*)makeBorder3WithLinkArray:(WZZLinkedArray *)linkArray
                                          border:(CGFloat)border {
    WZZLinkedObject * point1 = linkArray.array[0];
    WZZLinkedObject * point2 = linkArray.array[1];
    WZZLinkedObject * point3 = linkArray.array[2];
    
    CGPoint mp1_, mp2_, mp3_;
    
#pragma mark 主要点1
    //计算角度，两线夹角/2
    CGFloat mp1Angle = angleBetweenLines(
                                         WZZShapeHandler_LinkedObjectToPoint(point1),
                                         WZZShapeHandler_LinkedObjectToPoint(point3),
                                         WZZShapeHandler_LinkedObjectToPoint(point1),
                                         WZZShapeHandler_LinkedObjectToPoint(point2)
                                         )/2.0f;
    
    //tan函数计算距离
    CGFloat littleBorder1 = border/tan(mp1Angle);
    if (littleBorder1 < 0) {
        littleBorder1 = -littleBorder1;
    }
    mp1_ = CGPointMake(
                       WZZShapeHandler_LinkedObjectToPoint(point1).x+littleBorder1,
                       WZZShapeHandler_LinkedObjectToPoint(point1).y+border
                       );
    
#pragma mark - 主要点3
    //计算角度，两线夹角/2-90度，得到三角形除直角外的另一个叫，做三角函数计算
    CGFloat mp3Angle = angleBetweenLines(
                                         WZZShapeHandler_LinkedObjectToPoint(point3),
                                         WZZShapeHandler_LinkedObjectToPoint(point2),
                                         WZZShapeHandler_LinkedObjectToPoint(point3),
                                         WZZShapeHandler_LinkedObjectToPoint(point1)
                                         )/2.0f;
    //tan函数计算距离
    CGFloat littleBorder3 = border/tan(mp3Angle);
    if (littleBorder3 < 0) {
        littleBorder3 = -littleBorder3;
    }
    mp3_ = CGPointMake(
                       WZZShapeHandler_LinkedObjectToPoint(point3).x-littleBorder3,
                       WZZShapeHandler_LinkedObjectToPoint(point3).y+border
                       );
    
#pragma mark 主要点2
    //沿用1的夹角
    CGFloat lineAB = sqrt(
                          pow(WZZShapeHandler_LinkedObjectToPoint(point2).x, 2)+
                          pow(WZZShapeHandler_LinkedObjectToPoint(point2).y, 2));
    CGFloat lineA_B_ = (mp3_.x-mp1_.x)/WZZShapeHandler_LinkedObjectToPoint(point3).x*lineAB;
    CGFloat mp1_Angle = mp1Angle*2.0f;
    if (mp1_Angle > M_PI_2) {
        mp1_Angle = M_PI-mp1_Angle;
    }
    mp2_ = CGPointMake(lineA_B_*cos(mp1_Angle)+mp1_.x, lineA_B_*sin(mp1_Angle)+mp1_.y);
    
    NSLog(@"\n>>>%@\n>>>%@\n>>>%@", [NSValue valueWithCGPoint:mp1_], [NSValue valueWithCGPoint:mp2_], [NSValue valueWithCGPoint:mp3_]);
    
    return @[
             [NSValue valueWithCGPoint:mp1_],
             [NSValue valueWithCGPoint:mp2_],
             [NSValue valueWithCGPoint:mp3_],
             ];
}

void __getPointsFromBezierPath(void * info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
    }
}

+ (NSArray *)getPointsFromBezierPath:(UIBezierPath *)path {
    NSMutableArray * points = [NSMutableArray array];
    CGPathApply(path.CGPath, (__bridge void *)points, __getPointsFromBezierPath);
    return points;
}

//计算多边形边框
+ (NSArray <NSValue *>*)makeAnyBorderWithLinkArray:(WZZLinkedArray *)linkArray {
    //至少3个点
    if (linkArray.array.count < 3) {
        return nil;
    }
    
    const CGFloat l = 3.0f;//边框宽度
    CGPoint p1 = WZZShapeHandler_LinkedObjectToPoint(linkArray.array.firstObject);
    CGPoint p2 = WZZShapeHandler_LinkedObjectToPoint(linkArray.array.firstObject.nextObj);
    CGPoint pn_1 = WZZShapeHandler_LinkedObjectToPoint(linkArray.array.lastObject.lastObj);
    CGPoint pn = WZZShapeHandler_LinkedObjectToPoint(linkArray.array.lastObject);
    CGFloat angle1 = angleBetweenLines(p1, p2, p1, pn)/2.0f;
    CGFloat angle2 = angleBetweenLines(pn, p1, pn, pn_1)/2.0f;
    CGFloat m = pn.x;
    CGFloat m2 = 0.0f;
    CGFloat scale = 0.0f;
    CGFloat a1 = 0.0f;
    CGFloat a2 = 0.0f;
    
    //保证弧度大于0小于90度
    angle1 = fabs(angle1);
    angle2 = fabs(angle2);
    if (angle1 > M_PI_2) {
        angle1 = M_PI-angle1;
    }
    if (angle2 > M_PI_2) {
        angle2 = M_PI-angle2;
    }
    
    a1 = fabs(l/tan(angle1));
    a2 = fabs(l/tan(angle2));
    
    m2 = m-a1-a2;
    scale = m2/m;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    for (int i = 1; i < linkArray.array.count; i++) {
        [path addLineToPoint:WZZShapeHandler_LinkedObjectToPoint(linkArray.array[i])];
    }
    NSLog(@">>>>>>path1:%@", path);
    [path applyTransform:CGAffineTransformMakeScale(scale, scale)];
    NSLog(@">>>>>>path2:%@", path);
    NSArray * pathPointsArr = [self getPointsFromBezierPath:path];
    NSMutableArray * okPath = [NSMutableArray array];
    for (int i = 0; i < pathPointsArr.count; i++) {
        NSValue * value = pathPointsArr[i];
        [okPath addObject:[NSValue valueWithCGPoint:CGPointMake(value.CGPointValue.x+a1, value.CGPointValue.y+l)]];
    }
    
    return okPath;
}

//计算多边形边框
+ (NSArray <NSValue *>*)makeAnyBorder2WithLinkArray:(WZZLinkedArray *)linkArray {
    //至少3个点
    if (linkArray.array.count < 3) {
        return nil;
    }
    
    const CGFloat l = 3.0f;//边框宽度
    
    NSMutableArray * okArray = [NSMutableArray array];
    for (int i = 1; i < linkArray.array.count-1; i++) {
#if 1
        NSLog(@"------------------------------");
        WZZLinkedObject * pa = linkArray.array[i];
        CGFloat paAngle_2 = angleBetweenLines(WZZShapeHandler_LinkedObjectToPoint(pa), WZZShapeHandler_LinkedObjectToPoint(pa.nextObj), WZZShapeHandler_LinkedObjectToPoint(pa), WZZShapeHandler_LinkedObjectToPoint(pa.lastObj))/2.0f;

        CGFloat AOXAngle = angleBetweenLines(WZZShapeHandler_LinkedObjectToPoint(pa.lastObj), WZZShapeHandler_LinkedObjectToPoint(pa), WZZShapeHandler_LinkedObjectToPoint(pa.lastObj), CGPointMake(10000, WZZShapeHandler_LinkedObjectToPoint(pa.lastObj).y));
#else
        NSLog(@"------------------------------");
        WZZLinkedObject * pa = linkArray.array[i];
        CGFloat paAngle_2 = angleBetweenLines(WZZShapeHandler_LinkedObjectToPoint(pa.lastObj), WZZShapeHandler_LinkedObjectToPoint(pa), WZZShapeHandler_LinkedObjectToPoint(pa.nextObj), WZZShapeHandler_LinkedObjectToPoint(pa))/2.0f;
        
        CGFloat AOXAngle = angleBetweenLines(WZZShapeHandler_LinkedObjectToPoint(pa), WZZShapeHandler_LinkedObjectToPoint(pa.lastObj), CGPointMake(10000, WZZShapeHandler_LinkedObjectToPoint(pa.lastObj).y), WZZShapeHandler_LinkedObjectToPoint(pa.lastObj));
#endif
        //计算AA'X夹角，化简完为AOXAngle+paAngle_2，其实两个三角形相似
//        CGFloat AA_XAngle = ((M_PI_2+AOXAngle)-(M_PI_2-paAngle_2)*2)+(M_PI_2-paAngle_2);
//        NSLog(@"ffff%lf", AA_XAngle);
        CGFloat AA_XAngle = AOXAngle+paAngle_2;
        NSLog(@"AA'X>%lf", AA_XAngle);
    
        CGFloat AA_ = l/sin(paAngle_2);
        CGFloat AH = AA_*sin(AA_XAngle);
        CGFloat A_H = AA_*cos(AA_XAngle);
        NSLog(@"AA_:%lf, A':(%lf, %lf)", AA_, A_H, AH);
        
        //调整补充象限判断
//        CGFloat XiangXianAddAngle = angleBetweenLines(pa.thisObj, WZZShapeHandler_LinkedObjectToPoint(<#linkObj#>), <#CGPoint line2Start#>, <#CGPoint line2End#>)
        
        //象限
        int XiangXian = 0;
        if (AA_XAngle < M_PI_2) {
            XiangXian = 1;
        } else if (AA_XAngle < M_PI) {
            XiangXian = 2;
        } else if (AA_XAngle < M_PI+M_PI_2) {
            XiangXian = 3;
        } else {
            XiangXian = 4;
        }
        
        CGPoint pA_ = CGPointZero;
        switch (XiangXian) {
            case 1:
            {
                pA_ = CGPointMake(WZZShapeHandler_LinkedObjectToPoint(pa).x-A_H, WZZShapeHandler_LinkedObjectToPoint(pa).y-AH);
            }
                break;
            case 2:
            {
                pA_ = CGPointMake(WZZShapeHandler_LinkedObjectToPoint(pa).x-A_H, WZZShapeHandler_LinkedObjectToPoint(pa).y-AH);
            }
                break;
            case 3:
            {
                pA_ = CGPointMake(WZZShapeHandler_LinkedObjectToPoint(pa).x+A_H, WZZShapeHandler_LinkedObjectToPoint(pa).y+AH);
            }
                break;
            case 4:
            {
                pA_ = CGPointMake(WZZShapeHandler_LinkedObjectToPoint(pa).x-A_H, WZZShapeHandler_LinkedObjectToPoint(pa).y+AH);
            }
                break;
                
            default:
            {
                
            }
                break;
        }
        
        [okArray addObject:[NSValue valueWithCGPoint:pA_]];
    }
    
    return okArray;
}

//显示点
+ (void)showPointWithNode:(SCNNode *)node
                   points:(NSArray <NSValue *>*)points
                    color:(UIColor *)color {
    [points enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SCNBox * box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0.0f];
        SCNNode * nodeBox = [SCNNode nodeWithGeometry:box];
        nodeBox.position = SCNVector3Make(obj.CGPointValue.x, obj.CGPointValue.y, 0);
        nodeBox.geometry.firstMaterial.diffuse.contents = color;
        [node addChildNode:nodeBox];
    }];
}

//重置handler
+ (void)resetHandler {
    wzzShapeHandler = [[WZZShapeHandler alloc] init];
}

//获取rect所有数据
- (void)getRectAllBorderData:(void (^)(id))borderDataBlock {
    WZZWindowNode * rootWindow = self.allWindows.firstObject;
    NSArray * windowsArray = [NSArray arrayWithArray:self.allUpWindows];
    
    NSMutableDictionary * allDataDic = [NSMutableDictionary dictionary];
    NSMutableArray * lineArr = [NSMutableArray array];
    NSMutableArray * glassArr = [NSMutableArray array];
    NSMutableArray * zhongTingArr = [NSMutableArray array];
    allDataDic[@"line"] = lineArr;
    allDataDic[@"glass"] = glassArr;
    allDataDic[@"zhongTing"] = zhongTingArr;
    for (int i = 0; i < windowsArray.count; i++) {
        WZZWindowNode * windowNode = windowsArray[i];
        SCNVector3 upTV3 = SCNVector3Make(windowNode.borderUpTing.startPoint.x, windowNode.borderUpTing.startPoint.y, 0);
        SCNVector3 downTV3 = SCNVector3Make(windowNode.borderDownTing.startPoint.x, windowNode.borderDownTing.startPoint.y, 0);
        SCNVector3 rightTV3 = SCNVector3Make(windowNode.borderRightTing.startPoint.x, windowNode.borderRightTing.startPoint.y, 0);
        SCNVector3 leftTV3 = SCNVector3Make(windowNode.borderLeftTing.startPoint.x, windowNode.borderLeftTing.startPoint.y, 0);
        
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
        
        
        //计算尺寸
        CalculationFormula hCalType = (CalculationFormula)hengTingType;
        CalculationFormula vCalType = (CalculationFormula)shuTingType;
        //压线尺寸
        CGFloat lineH = [DoorWindowCalculationFormulaObjective DoorWindowCircleCalculationFormula:hCalType distance:hengTing];
        CGFloat lineV = [DoorWindowCalculationFormulaObjective DoorWindowCircleCalculationFormula:vCalType distance:shuTing];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineH]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineH]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineV]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineV]];
        
        //玻璃尺寸
        CGFloat glassH = [DoorWindowCalculationFormulaObjective DoorWindowGlassCalculationFormula:hCalType distance:hengTing];
        CGFloat glassV = [DoorWindowCalculationFormulaObjective DoorWindowGlassCalculationFormula:vCalType distance:shuTing];
        [glassArr addObject:[NSString stringWithFormat:@"%.2lf", glassH]];
        [glassArr addObject:[NSString stringWithFormat:@"%.2lf", glassV]];
    }
    
    //挺尺寸
    NSArray * allTingArr = [WZZShapeHandler shareInstance].allTings;
    for (int i = 0; i < allTingArr.count; i++) {
        CGFloat tingLength = 0;
        WZZTingNode * tingNode = allTingArr[i];
        if ([tingNode isKindOfClass:[WZZZhongTingNode class]]) {
            WZZZhongTingNode * zhongTing = (WZZZhongTingNode *)tingNode;
            WZZInsideNode * insideNode = (WZZInsideNode *)zhongTing.superNode;
            WZZWindowNode * windowNode = insideNode.superWindow;
            if (zhongTing.tingHV == WZZInsideNode_H) {
                //挺间关系
                CalculationFormula tingType = [self handleHVWithWindowNode:windowNode tingHV:WZZInsideNode_H];
                
                //转换坐标
                SCNVector3 rightTV3 = SCNVector3Make(windowNode.borderRightTing.startPoint.x, windowNode.borderRightTing.startPoint.y, 0);
                SCNVector3 leftTV3 = SCNVector3Make(windowNode.borderLeftTing.startPoint.x, windowNode.borderLeftTing.startPoint.y, 0);

                rightTV3 = [windowNode.borderRightTing convertPosition:rightTV3 toNode:rootWindow];
                leftTV3 = [windowNode.borderLeftTing convertPosition:leftTV3 toNode:rootWindow];
                
                CGPoint rightTP = CGPointMake(rightTV3.x, rightTV3.y);
                CGPoint leftTP = CGPointMake(leftTV3.x, leftTV3.y);
                
                CGFloat hengTing = fabs(rightTP.x-leftTP.x);
                
                tingLength = [DoorWindowCalculationFormulaObjective DoorWindowCentreGalssCalculationFormula:tingType distance:hengTing];
            } else {
                //挺间关系
                CalculationFormula tingType = [self handleHVWithWindowNode:windowNode tingHV:WZZInsideNode_H];
                
                //转换坐标
                SCNVector3 upTV3 = SCNVector3Make(windowNode.borderUpTing.startPoint.x, windowNode.borderUpTing.startPoint.y, 0);
                SCNVector3 downTV3 = SCNVector3Make(windowNode.borderDownTing.startPoint.x, windowNode.borderDownTing.startPoint.y, 0);
                
                upTV3 = [windowNode.borderUpTing convertPosition:upTV3 toNode:rootWindow];
                downTV3 = [windowNode.borderDownTing convertPosition:downTV3 toNode:rootWindow];
                
                CGPoint upTP = CGPointMake(upTV3.x, upTV3.y);
                CGPoint downTP = CGPointMake(downTV3.x, downTV3.y);
                
                CGFloat shuTing = fabs(upTP.y-downTP.y);
                
                tingLength = [DoorWindowCalculationFormulaObjective DoorWindowCentreGalssCalculationFormula:tingType distance:shuTing];
            }
            
            [zhongTingArr addObject:[NSString stringWithFormat:@"%.2lf", tingLength]];
        }
    }
    
    if (borderDataBlock) {
        borderDataBlock(allDataDic);
    }
}

//获取边框关系
- (CalculationFormula)handleHVWithWindowNode:(WZZWindowNode *)windowNode
                                          tingHV:(WZZInsideNode_HV)tingHV {
    WZZShapeHandler_FromTo tingType;
    if (tingHV == WZZInsideNode_H) {
        //横向
        if ([windowNode.borderLeftTing isKindOfClass:[WZZWindowBorderTingNode class]] && [windowNode.borderRightTing isKindOfClass:[WZZWindowBorderTingNode class]]) {
            //边到边
            tingType = WZZShapeHandler_FromTo_BToB;
            NSLog(@"横:边到边");
        } else if ([windowNode.borderLeftTing isKindOfClass:[WZZWindowBorderTingNode class]] || [windowNode.borderRightTing isKindOfClass:[WZZWindowBorderTingNode class]]) {
            //边到中
            tingType = WZZShapeHandler_FromTo_BToC;
            NSLog(@"横:边到中");
        } else {
            //中到中
            tingType = WZZShapeHandler_FromTo_CToC;
            NSLog(@"横:中到中");
        }
    } else {
        //纵向
        if ([windowNode.borderUpTing isKindOfClass:[WZZWindowBorderTingNode class]] && [windowNode.borderDownTing isKindOfClass:[WZZWindowBorderTingNode class]]) {
            //边到边
            tingType = WZZShapeHandler_FromTo_BToB;
            NSLog(@"竖:边到边");
        } else if ([windowNode.borderUpTing isKindOfClass:[WZZWindowBorderTingNode class]] || [windowNode.borderDownTing isKindOfClass:[WZZWindowBorderTingNode class]]) {
            //边到中
            tingType = WZZShapeHandler_FromTo_BToC;
            NSLog(@"竖:边到中");
        } else {
            //中到中
            tingType = WZZShapeHandler_FromTo_CToC;
            NSLog(@"竖:中到中");
        }
    }
    return (CalculationFormula)tingType;
}

#pragma mark - 属性
//全部window
- (NSMutableArray<WZZWindowNode *> *)allWindows {
    if (!_allWindows) {
        _allWindows = [NSMutableArray array];
    }
    return _allWindows;
}

//所有最上层的window
- (NSArray *)allUpWindows {
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < _allWindows.count; i++) {
        WZZWindowNode * node = _allWindows[i];
        //没有中挺的内容的window就是最上层的window
        if (node.insideContent) {
            if (!node.insideContent.insideZhongTing) {
                [arr addObject:node];
            }
        }
    }
    return arr;
}

//所有挺
- (NSMutableArray<WZZTingNode *> *)allTings {
    if (!_allTings) {
        _allTings = [NSMutableArray array];
    }
    return _allTings;
}

@end
