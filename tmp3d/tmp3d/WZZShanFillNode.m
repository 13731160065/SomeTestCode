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
        case WZZShanFillNode_ShanType_None:
        {
            
        }
            break;
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

- (void)handleDataWith:(void (^)(id))dataBlock {
    switch (self.shanType) {
        case WZZShanFillNode_ShanType_None:
        {
            
        }
            break;
        case WZZShanFillNode_ShanType_NormalShan:
        {
            NSMutableArray * dataArr = [NSMutableArray array];
            [self enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
                if ([child.name isEqualToString:@"glassNode"]) {
                    WZZTextureFillNode * node = (WZZTextureFillNode *)child;
                    [node handleDataWith:^(id returnData) {
                        NSLog(@"p:%@", returnData);
                        CGSize size = [self rectDataSize];
                        [dataArr addObject:[NSString stringWithFormat:@"%.2lf", size.width]];
                        [dataArr addObject:[NSString stringWithFormat:@"%.2lf", size.height]];
                    }];
                }
            }];
        }
            break;
            
        default:
            break;
    }
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
