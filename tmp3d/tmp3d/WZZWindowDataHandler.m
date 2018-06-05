//
//  WZZWindowDataHandler.m
//  tmp3d
//
//  Created by 王泽众 on 2018/6/5.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZWindowDataHandler.h"
#import "WZZShapeHandler.h"
#import "WZZWindowNode.h"
#import "WZZWindowBorderTingNode.h"
#import "WZZZhongTingNode.h"
#import "DoorWindowCalculationFormulaObjective.h"
#import "WZZTextureFillNode.h"
#import "WZZShanFillNode.h"
#import "WZZWindowDataMaker.h"
#import "WZZInsideDataMaker.h"

static WZZWindowDataHandler * wzzWindowDataHandler;

@interface WZZWindowDataHandler () {
    NSString * _borderTexture;
}

@end

@implementation WZZWindowDataHandler

//MARK:单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wzzWindowDataHandler = [[WZZWindowDataHandler alloc] init];
    });
    return wzzWindowDataHandler;
}

//MARK:重置handler
+ (void)resetHandler {
    wzzWindowDataHandler = [[WZZWindowDataHandler alloc] init];
}

//记录
+ (void)markdownState {
    NSDictionary * dic = [WZZWindowDataHandler getAllMakerData];
    NSInteger index = [WZZShapeHandler shareInstance].currentActionIndex++;
    NSInteger count = [WZZShapeHandler shareInstance].actionQueueArray.count;
    if (index < count-1) {
        [[WZZShapeHandler shareInstance].actionQueueArray removeObjectsInRange:NSMakeRange(index+1, count-index-1)];
    }
    [[WZZShapeHandler shareInstance].actionQueueArray addObject:dic];
}

//撤销
+ (WZZWindowNode *)undo {
    NSInteger index = [WZZShapeHandler shareInstance].currentActionIndex;
    if (index > 0) {
        [WZZShapeHandler shareInstance].currentActionIndex = --index;
    } else {
        return nil;
    }
    NSDictionary * dic = [WZZShapeHandler shareInstance].actionQueueArray[index];
    return [WZZWindowDataHandler makeAllWindowWithDic:dic];
}

//重做
+ (WZZWindowNode *)redo {
    NSInteger index = [WZZShapeHandler shareInstance].currentActionIndex;
    if (index < [WZZShapeHandler shareInstance].actionQueueArray.count-1) {
        [WZZShapeHandler shareInstance].currentActionIndex = ++index;
    } else {
        return nil;
    }
    NSDictionary * dic = [WZZShapeHandler shareInstance].actionQueueArray[index];
    return [WZZWindowDataHandler makeAllWindowWithDic:dic];
}

//MARK:获取rect所有数据
- (void)getRectAllBorderData:(void (^)(id))borderDataBlock {
    WZZWindowNode * rootWindow = self.allWindows.firstObject;
    NSArray * windowsArray = [NSArray arrayWithArray:self.allUpWindows];
    
    NSMutableDictionary * allDataDic = [NSMutableDictionary dictionary];
    
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
        if (!allDataDic[@"yaxian"]) {
            allDataDic[@"yaxian"] = [NSMutableArray array];
        }
        NSMutableArray * lineArr = allDataDic[@"yaxian"];
        CGFloat lineH = [DoorWindowCalculationFormulaObjective DoorWindowCircleCalculationFormula:hCalType distance:hengTing];
        CGFloat lineV = [DoorWindowCalculationFormulaObjective DoorWindowCircleCalculationFormula:vCalType distance:shuTing];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineH]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineH]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineV]];
        [lineArr addObject:[NSString stringWithFormat:@"%.2lf", lineV]];
        
        //计算填充物
        if (windowNode.insideContent.insideType != WZZInsideNodeContentType_None && windowNode.insideContent.insideType != WZZInsideNodeContentType_Turn) {
            if ([windowNode.insideContent.insideFill isKindOfClass:[WZZTextureFillNode class]]) {
                //填充为材质
                WZZTextureFillNode * node = (WZZTextureFillNode *)windowNode.insideContent.insideFill;
                switch (node.fillTexture) {
                    case WZZTextureFillNode_textureType_Glass:
                    {
                        if (!allDataDic[@"boli"]) {
                            allDataDic[@"boli"] = [NSMutableArray array];
                        }
                        NSArray * tmpArr = [node handleData];
                        [allDataDic[@"boli"] addObjectsFromArray:tmpArr];
                    }
                        break;
                        
                    default:
                        break;
                }
            } else if ([windowNode.insideContent.insideFill isKindOfClass:[WZZShanFillNode class]]) {
                WZZShanFillNode * node = (WZZShanFillNode *)windowNode.insideContent.insideFill;
                //填充为扇
                WZZShanFillNode * fill = (WZZShanFillNode *)windowNode.insideContent.insideFill;
                switch (fill.shanType) {
                    case WZZShanFillNode_ShanType_NormalShan:
                    {
                        if (!allDataDic[@"shan"]) {
                            allDataDic[@"shan"] = [NSMutableArray array];
                        }
                        NSMutableDictionary * shanDic = [NSMutableDictionary dictionary];
                        [allDataDic[@"shan"] addObject:shanDic];
                        shanDic[@"shan"] = [node handleData];//扇
                        shanDic[@"shan_sha"] = [node handleShaData];//纱窗
                        shanDic[@"shan_inside"] = [node handleShanInsideData];//内容
                        shanDic[@"shan_yaxian"] = [node handleShanLineData];//压线
                        shanDic[@"shan_turn"] = [node handleTurnData];//转向框
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    
    //挺尺寸
    NSArray * allTingArr = [WZZWindowDataHandler shareInstance].allTings;
    for (int i = 0; i < allTingArr.count; i++) {
        CGFloat tingLength = 0;
        WZZTingNode * tingNode = allTingArr[i];
        //确保只有中挺参与挺尺寸计算
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
            
            if (!allDataDic[@"zhongting"]) {
                allDataDic[@"zhongting"] = [NSMutableArray array];
            }
            NSMutableArray * zhongTingArr = allDataDic[@"zhongting"];
            [zhongTingArr addObject:[NSString stringWithFormat:@"%.2lf", tingLength]];
        }
    }
    
    if (borderDataBlock) {
        borderDataBlock(allDataDic);
    }
}

//MARK:获取边框关系
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

#pragma mark - 保存重建功能
//MARK:获取所有maker字典数据
+ (NSDictionary *)getAllMakerData {
    WZZWindowNode * rootWindow = [wzzWindowDataHandler.allWindows firstObject];
    return [WZZWindowDataMaker dicWithWindow:rootWindow];
}

//MARK:重建所有数据
+ (WZZWindowNode *)makeAllWindowWithDic:(NSDictionary *)dic {
    [WZZWindowDataHandler resetHandler];
    WZZWindowNode * node = [WZZWindowDataMaker makeWindowWithDic:dic];
    return node;
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

//设置材质
- (void)setBorderTexture:(NSString *)borderTexture {
    _borderTexture = borderTexture;
    [[self allTings] enumerateObjectsUsingBlock:^(WZZTingNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.geometry.firstMaterial.diffuse.contents = borderTexture;
    }];
}

- (NSString *)borderTexture {
    if (!_borderTexture) {
        _borderTexture = @"lvhejin.jpg";
    }
    return _borderTexture;
}

@end
