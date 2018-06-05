//
//  WZZInsideDataMaker.m
//  tmp3d
//
//  Created by 王泽众 on 2018/6/4.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZInsideDataMaker.h"
#import "WZZInsideNode.h"
#import "WZZWindowDataMaker.h"
#import "WZZWindowNode.h"

@implementation WZZInsideDataMaker

+ (instancetype)makerWithInside:(WZZInsideNode *)insideNode {
    WZZInsideDataMaker * maker = [[WZZInsideDataMaker alloc] init];
    maker.insideHV = insideNode.insideCutHV;
    maker.insideAction = insideNode.insideAction;
    maker.insideContentType = insideNode.insideType;
    maker.insideCutPosition = insideNode.cutPosition;
    insideNode.insideMaker = maker;
    return maker;
}

//+ (void)handleInside:(WZZInsideNode *)insideNode {
//    NSString * pointStr = insideDic[@"cutPosition"];
//    NSArray * pointArr = [pointStr componentsSeparatedByString:@","];
//
//    WZZInsideDataMaker * maker = [[WZZInsideDataMaker alloc] init];
//    CGFloat cx = [NSDecimalNumber decimalNumberWithString:dic[@"insideCutPositionX"]].doubleValue;
//    CGFloat cy = [NSDecimalNumber decimalNumberWithString:dic[@"insideCutPositionY"]].doubleValue;
//
//    maker.insideCutPosition = CGPointMake(cx, cy);
//    maker.insideHV = [dic[@"insideHV"] integerValue];
//    maker.insideAction = [dic[@"insideAction"] integerValue];
//    maker.insideContentType = [dic[@"insideContentType"] integerValue];
//
//
//    NSArray * pointArr = insideDic[@"cutPosition"];
//    [pointArr componentsJoinedByString:@","];
//    insideNode.insideCutHV = self.insideHV;
//    insideNode.insideAction = self.insideAction;
//    insideNode.insideType = self.insideContentType;
//    insideNode.cutPosition = self.insideCutPosition;
//    switch (self.insideAction) {
//        case WZZInsideNode_Action_None:
//        {
//
//        }
//            break;
//        case WZZInsideNode_Action_Cut:
//        {
//            [insideNode cutWithPosition:self.insideCutPosition];
//        }
//            break;
//        case WZZInsideNode_Action_Fill:
//        {
//            [insideNode fillWithInside:self.insideContentType];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

//根据字典重建，递归
+ (void)handleInsideWithDic:(NSDictionary *)dic
                     inside:(WZZInsideNode *)insideNode {
    //切点坐标
    NSString * pointStr = dic[@"cutPosition"];
    NSArray * pointArr = [pointStr componentsSeparatedByString:@","];
    if (pointArr.count != 2) {
        pointArr = @[@"0", @"0"];
    }
    CGFloat cx = [NSDecimalNumber decimalNumberWithString:pointArr[0]].doubleValue;
    CGFloat cy = [NSDecimalNumber decimalNumberWithString:pointArr[1]].doubleValue;
    
    insideNode.cutPosition = CGPointMake(cx, cy);
    insideNode.insideCutHV = [dic[@"insideCutHV"] integerValue];
    insideNode.insideAction = [dic[@"insideAction"] integerValue];
    insideNode.insideType = [dic[@"insideType"] integerValue];
    
    switch (insideNode.insideAction) {
        case WZZInsideNode_Action_None:
        {
            
        }
            break;
        case WZZInsideNode_Action_Cut:
        {
            [insideNode cutWithPosition:insideNode.cutPosition];
            //处理window的inside
            NSArray * windowArr = insideNode.insideWindow;
            NSArray * windowDicArr = dic[@"insideWindow"];
            for (int i = 0; i < windowArr.count; i++) {
                WZZWindowNode * subWindow = windowArr[i];
                NSDictionary * subWindowDic = windowDicArr[i];
                //处理inside之前先处理一下window的转向框
                if ([subWindowDic[@"borderType"] integerValue] == WZZShapeHandler_WindowBorderType_TurnBorder) {
                    [subWindow changeTurnBorderType:WZZShapeHandler_WindowBorderType_None];
                }
                //处理inside
                [self handleInsideWithDic:subWindowDic[@"inside"] inside:subWindow.insideContent];
            }
        }
            break;
        case WZZInsideNode_Action_Fill:
        {
            [insideNode fillWithInside:insideNode.insideType];
        }
            break;
            
        default:
            break;
    }
}

//inside转字典，递归
+ (NSDictionary *)dicWithInside:(WZZInsideNode *)insideNode {
    //基础数据
    NSMutableDictionary * insideDic = [NSMutableDictionary dictionary];
    insideDic[@"cutPosition"] = [NSString stringWithFormat:@"%lf,%lf", insideNode.cutPosition.x, insideNode.cutPosition.y];
    insideDic[@"insideAction"] = @(insideNode.insideAction);
    insideDic[@"insideType"] = @(insideNode.insideType);
    insideDic[@"insideCutHV"] = @(insideNode.insideCutHV);
    
    if (insideNode.insideAction == WZZInsideNode_Action_Cut) {
        //inside上的window
        NSMutableArray * insideWindowArr = [NSMutableArray array];
        insideDic[@"insideWindow"] = insideWindowArr;
        
        for (int i = 0; i < insideNode.insideWindow.count; i++) {
            WZZWindowNode * subWindow = insideNode.insideWindow[i];
            [insideWindowArr addObject:[WZZWindowDataMaker dicWithWindow:subWindow]];
        }
    }
    
    return insideDic;
}

@end
