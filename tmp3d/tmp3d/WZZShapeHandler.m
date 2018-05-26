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
    NSLog(@"jd>%@", @(radiansToDegrees(rads)));
    
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

@end
