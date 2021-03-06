//
//  WZZShapeHandler.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZShapeHandler.h"
#import "WZZLinkedArray.h"
@import UIKit;
@import SceneKit;

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

//一次函数表达式
typedef struct WZZLineFuncKB {
    CGFloat k;//系数
    CGFloat b;//y轴交点
    BOOL X;//当两个x相等时的x
} WZZLineFuncKB;

//根据kb创建一次函数表达式
WZZLineFuncKB WZZLineFuncKBMake(CGFloat k, CGFloat b, BOOL X) {
    WZZLineFuncKB kb;
    kb.k = k;
    kb.b = b;
    kb.X = X;
    return kb;
}

//根据2点计算一次函数表达式
WZZLineFuncKB WZZLineFuncKBP1P2(CGPoint p1, CGPoint p2) {
    if (p1.x == p2.x) {
        //表达式直接为x
        return WZZLineFuncKBMake(0, 0, YES);
    }
    CGFloat k = (p1.y-p2.y)/(p1.x-p2.x);
    CGFloat b = p1.y-k*p1.x;
    return WZZLineFuncKBMake(k, b, NO);
}

//根据x和函数kb获取点
CGPoint getPointWithLineKBX(WZZLineFuncKB kb, CGFloat x) {
    return CGPointMake(x, kb.k*x+kb.b);
}
//根据y和函数kb获取点
CGPoint getPointWithLineKBY(WZZLineFuncKB kb, CGFloat y) {
    return CGPointMake((y-kb.b)/kb.k, y);
}

static WZZShapeHandler * wzzShapeHandler;

@interface WZZShapeHandler ()

@end

@implementation WZZShapeHandler

//MARK:单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wzzShapeHandler = [[WZZShapeHandler alloc] init];
    });
    return wzzShapeHandler;
}

//MARK:重置handler
+ (void)resetHandler {
    wzzShapeHandler = [[WZZShapeHandler alloc] init];
}

//获取被塞尔曲线中的点，支持方法
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

//MARK:获取被塞尔曲线上的点
+ (NSArray *)getPointsFromBezierPath:(UIBezierPath *)path {
    NSMutableArray * points = [NSMutableArray array];
    CGPathApply(path.CGPath, (__bridge void *)points, __getPointsFromBezierPath);
    return points;
}

//MARK:计算多边形边框内点坐标
+ (NSArray <NSValue *>*)makeAnyBorder3WithLinkArray:(WZZLinkedArray *)linkArray
                                             border:(CGFloat)border {
    NSMutableArray * returnArr = [NSMutableArray array];
    for (int i = 0; i < linkArray.array.count; i++) {
        WZZLinkedObject * lpa = linkArray.array[i];
        CGPoint pa = WZZShapeHandler_LinkedObjectToPoint(lpa);
        CGPoint pal = WZZShapeHandler_LinkedObjectToPoint(lpa.lastObj);
        CGPoint pan = WZZShapeHandler_LinkedObjectToPoint(lpa.nextObj);
        
        WZZLineFuncKB kbl = WZZLineFuncKBP1P2(pa, pal);
        WZZLineFuncKB kbn = WZZLineFuncKBP1P2(pa, pan);
        
        WZZLineFuncKB ll1, ll2, ln1, ln2;
        CGPoint p1, p2, p3, p4;
        
        if (kbl.X) {
            //垂直x轴
            ll1 = WZZLineFuncKBMake(kbl.k, kbl.b, kbl.X);
            ll2 = WZZLineFuncKBMake(kbl.k, kbl.b, kbl.X);
        } else {
            ll1 = WZZLineFuncKBMake(kbl.k, kbl.b+border/cos(atan(kbl.k)), NO);
            ll2 = WZZLineFuncKBMake(kbl.k, kbl.b-border/cos(atan(kbl.k)), NO);
        }
        if (kbn.X) {
            //垂直x轴
            ln1 = WZZLineFuncKBMake(kbn.k, kbn.b, kbn.X);
            ln2 = WZZLineFuncKBMake(kbn.k, kbn.b, kbn.X);
        } else {
            ln1 = WZZLineFuncKBMake(kbn.k, kbn.b+border/cos(atan(kbn.k)), NO);
            ln2 = WZZLineFuncKBMake(kbn.k, kbn.b-border/cos(atan(kbn.k)), NO);
        }
        
        //计算4个交点坐标
        //，k1*x+b1=k2*x+b2，x=(b2-b1)/(k1-k2);(ll1, ln1)
        p1.x = (ln1.b-ll1.b)/(ll1.k-ln1.k);
        //y=k1*x+b
        p1.y = p1.x*ll1.k+ll1.b;
        //同上，(ll2, ln2)
        p2.x = (ln2.b-ll2.b)/(ll2.k-ln2.k);
        p2.y = p2.x*ll2.k+ll2.b;
        //同上，(ll1, ln2)
        p3.x = (ln2.b-ll1.b)/(ll1.k-ln2.k);
        p3.y = p3.x*ll2.k+ll2.b;
        //同上，(ll2, ln1)
        p4.x = (ln1.b-ll2.b)/(ll2.k-ln1.k);
        p4.y = p4.x*ll2.k+ll2.b;
        
        //判断某边垂直x的情况
        if (kbl.X) {
            //x=any, y=kx+b, (x+, ln1)
            p1.x = pa.x+border;
            p1.y = ln1.k*p1.x+ln1.b;
            //x=any, y=kx+b, (x-, ln2)
            p2.x = pa.x-border;
            p2.y = ln2.k*p2.x+ln2.b;
            //x=any, y=kx+b, (x-, ln1)
            p3.x = pa.x-border;
            p3.y = ln1.k*p2.x+ln1.b;
            //x=any, y=kx+b, (x+, ln2)
            p4.x = pa.x+border;
            p4.y = ln2.k*p2.x+ln2.b;
        }
        if (kbn.X) {
            //x=any, y=kx+b, (x+, ll1)
            p1.x = pa.x+border;
            p1.y = ll1.k*p1.x+ll1.b;
            //x=any, y=kx+b, (x-, ll2)
            p2.x = pa.x-border;
            p2.y = ll2.k*p2.x+ll2.b;
            //x=any, y=kx+b, (x-, ll1)
            p3.x = pa.x-border;
            p3.y = ll1.k*p1.x+ll1.b;
            //x=any, y=kx+b, (x+, ll2)
            p4.x = pa.x+border;
            p4.y = ll2.k*p2.x+ll2.b;
        }
        
        //判断p1还是p2落在路径里
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:WZZShapeHandler_LinkedObjectToPoint(linkArray.array.firstObject)];
        for (int i = 1; i < linkArray.array.count; i++) {
            [path addLineToPoint:WZZShapeHandler_LinkedObjectToPoint(linkArray.array[i])];
        }
        CGPoint insidePoint;
        if ([path containsPoint:p1]) {
            insidePoint = p1;
        } else if ([path containsPoint:p2]) {
            insidePoint = p2;
        } else if ([path containsPoint:p3]) {
            insidePoint = p3;
        } else {
            insidePoint = p4;
        }
        
        [returnArr addObject:[NSValue valueWithCGPoint:insidePoint]];
    }
    
    return returnArr;
}

//MARK:显示点，测试用
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

#pragma mark - 属性

- (NSMutableArray *)actionQueueArray {
    if (!_actionQueueArray) {
        _actionQueueArray = [NSMutableArray array];
    }
    return _actionQueueArray;
}

#pragma mark - 弃用


//创建边框
+ (NSArray <NSValue *>*)makeBorderWithLinkArray:(WZZLinkedArray *)linkArray
                                         border:(CGFloat)border {
    WZZLinkedObject * point1 = linkArray.array[0];
    WZZLinkedObject * point2 = linkArray.array[1];
    WZZLinkedObject * point3 = linkArray.array[2];
    WZZLinkedObject * point4 = linkArray.array[3];
    
    CGPoint mp2_, mp3_;
    
    //主要点2
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
    
    //主要点3
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
    
    //主要点1
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
    
    //主要点3
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
    
    //主要点2
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


@end
