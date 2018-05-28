//
//  WZZTextureFillNode.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZTextureFillNode.h"

#define WZZTextureFillNode_TextureContent_Glass @"boli.jpg"
#define WZZTextureFillNode_TextureContent_Sha [UIColor blackColor]

@implementation WZZTextureFillNode

+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep
                                texture:(WZZTextureFillNode_textureType)texture {
    WZZTextureFillNode * node = [self fillNodeWithPointsArray:pointsArray deep:deep];
    node.fillTexture = texture;
    [node fillTexture];
    return node;
}

- (void)fillWithTexture {
    switch (self.fillTexture) {
        case WZZTextureFillNode_textureType_None:
        {
            self.geometry.firstMaterial.diffuse.contents = nil;
            self.geometry.firstMaterial.transparency = 0.0f;
        }
            break;
        case WZZTextureFillNode_textureType_Glass:
        {
            self.geometry.firstMaterial.diffuse.contents = WZZTextureFillNode_TextureContent_Glass;
            self.geometry.firstMaterial.transparency = 0.5f;
        }
            break;
        case WZZTextureFillNode_textureType_Sha:
        {
            self.geometry.firstMaterial.diffuse.contents = WZZTextureFillNode_TextureContent_Sha;
            self.geometry.firstMaterial.transparency = 0.3f;
        }
            break;
            
        default:
            break;
    }
}

//计算数据
- (void)handleDataWith:(void (^)(id))dataBlock {
    if (self.pointsArray.count == 4) {
        CGSize size = [self rectDataSize];
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObject:[NSString stringWithFormat:@"%.2lf", size.width]];
        [arr addObject:[NSString stringWithFormat:@"%.2lf", size.height]];
        if (dataBlock) {
            dataBlock(arr);
        }
    }
}

//计算宽高
- (CGSize)rectDataSize {
    CGPoint point1 = self.pointsArray[0].CGPointValue;
    CGPoint point2 = self.pointsArray[1].CGPointValue;
    CGPoint point3 = self.pointsArray[2].CGPointValue;
    
    CGFloat lineH = point2.y-point1.y;
    CGFloat lineV = point3.x-point2.x;
    
    return CGSizeMake(lineH, lineV);
}

@end
