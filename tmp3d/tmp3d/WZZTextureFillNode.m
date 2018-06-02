//
//  WZZTextureFillNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZTextureFillNode.h"
#import "WZZShapeHandler.h"
#import "WZZWindowNode.h"
#import "DoorWindowCalculationFormulaObjective.h"

#define WZZTextureFillNode_TextureContent_Glass @"boli.jpg"
#define WZZTextureFillNode_TextureContent_Sha [UIColor blackColor]

@implementation WZZTextureFillNode

+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep
                                texture:(WZZTextureFillNode_textureType)texture {
    WZZTextureFillNode * node = [self fillNodeWithPointsArray:pointsArray deep:deep];
    node.fillTexture = texture;
    [node fillWithTexture];
    return node;
}

- (void)fillWithTexture {
    switch (self.fillTexture) {
        case WZZTextureFillNode_textureType_Glass:
        {
            self.geometry.firstMaterial.diffuse.contents = WZZTextureFillNode_TextureContent_Glass;
            self.geometry.firstMaterial.transparency = 0.5f;
        }
            break;
            
        default:
            break;
    }
}

//计算数据
- (NSArray <NSString *>*)handleData {
    if (self.pointsArray.count == 4) {
        NSArray * arr = [self rectDataSize];
        return arr;
    }
    return [NSArray array];
}

//计算宽高
- (NSArray <NSString *>*)rectDataSize {
    WZZWindowNode * windowNode = self.superNode.superWindow;
    SCNVector3 upTV3 = SCNVector3Make(windowNode.borderUpTing.startPoint.x, windowNode.borderUpTing.startPoint.y, 0);
    SCNVector3 downTV3 = SCNVector3Make(windowNode.borderDownTing.startPoint.x, windowNode.borderDownTing.startPoint.y, 0);
    SCNVector3 rightTV3 = SCNVector3Make(windowNode.borderRightTing.startPoint.x, windowNode.borderRightTing.startPoint.y, 0);
    SCNVector3 leftTV3 = SCNVector3Make(windowNode.borderLeftTing.startPoint.x, windowNode.borderLeftTing.startPoint.y, 0);
    
    WZZWindowNode * rootWindow = [WZZShapeHandler shareInstance].allWindows.firstObject;
    
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
    
    NSMutableArray * dataArr = [NSMutableArray array];
    //填充为材质
    switch (self.fillTexture) {
        case WZZTextureFillNode_textureType_Glass:
        {
            //玻璃
            //玻璃尺寸
            CGFloat glassH = [DoorWindowCalculationFormulaObjective DoorWindowGlassCalculationFormula:hCalType distance:hengTing];
            CGFloat glassV = [DoorWindowCalculationFormulaObjective DoorWindowGlassCalculationFormula:vCalType distance:shuTing];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", glassH]];
            [dataArr addObject:[NSString stringWithFormat:@"%.2lf", glassV]];
        }
            break;
            
        default:
            break;
    }
    
    return dataArr;
}

@end
