//
//  WZZTextureFillNode.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZFillNode.h"

typedef enum : NSUInteger {
    WZZTextureFillNode_textureType_Glass//玻璃
} WZZTextureFillNode_textureType;

@interface WZZTextureFillNode : WZZFillNode

/**
 填充材质
 */
@property (nonatomic, assign) WZZTextureFillNode_textureType fillTexture;

/**
 创建材质填充
 直接创建一个材质，如玻璃、纱窗等

 @param pointsArray 点数组
 @param deep 深度
 @param texture 贴图或颜色
 @return 材质填充
 */
+ (instancetype)fillNodeWithPointsArray:(NSArray<NSValue *> *)pointsArray
                                   deep:(CGFloat)deep
                                texture:(WZZTextureFillNode_textureType)texture;

@end
