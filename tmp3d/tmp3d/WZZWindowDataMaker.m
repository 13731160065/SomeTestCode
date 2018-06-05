//
//  WZZWindowDataMaker.m
//  tmp3d
//
//  Created by 王泽众 on 2018/6/4.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZWindowDataMaker.h"
#import "WZZWindowNode.h"
#import "WZZInsideDataMaker.h"
#import "WZZInsideNode.h"

@implementation WZZWindowDataMaker

//用dic创建window
+ (WZZWindowNode *)makeWindowWithDic:(NSDictionary *)dic {
    //四周点
    NSMutableArray * outPoints = [NSMutableArray array];
    NSArray * outPointStrArr = dic[@"outPoints"];
    for (int i = 0; i < outPointStrArr.count; i++) {
        NSArray * outSub = [outPointStrArr[i] componentsSeparatedByString:@","];
        [outPoints addObject:[NSValue valueWithCGPoint:CGPointMake([outSub[0] doubleValue], [outSub[1] doubleValue])]];
    }
    
    WZZShapeHandler_WindowBorderType borderType = [dic[@"borderType"] integerValue];
    //node
    WZZWindowNode * node;
    if (borderType == WZZShapeHandler_WindowBorderType_TurnBorder) {
        node = [WZZWindowNode nodeWithPoints:outPoints windowBorderType:WZZShapeHandler_WindowBorderType_None];
        [node changeTurnBorderType:WZZShapeHandler_WindowBorderType_TurnBorder];
    } else {
        node = [WZZWindowNode nodeWithPoints:outPoints windowBorderType:borderType];
    }
    
    //是不是主窗体
    BOOL isRootWindow = [dic[@"isRootWindow"] boolValue];
    node.isRootWindow = isRootWindow;
    
    //递归内容
    [WZZInsideDataMaker handleInsideWithDic:dic[@"inside"] inside:node.insideContent];
    
    return node;
}

//获取window数据
+ (NSDictionary *)dicWithWindow:(WZZWindowNode *)windowNode {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    //基本数据
    dic[@"isRootWindow"] = @(windowNode.isRootWindow);
    dic[@"borderType"] = @(windowNode.windowBorderType);
    
    //四周点
    NSMutableArray * outPoints = [NSMutableArray array];
    [windowNode.outPoints enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = obj.CGPointValue;
        NSString * str = [NSString stringWithFormat:@"%lf,%lf", point.x, point.y];
        [outPoints addObject:str];
    }];
    dic[@"outPoints"] = outPoints;
    
    //递归内容
    dic[@"inside"] = [WZZInsideDataMaker dicWithInside:windowNode.insideContent];

    return dic;
}

@end
