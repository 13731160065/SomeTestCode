//
//  WZZChangeTextureVC.h
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZChangeTextureVC : UIViewController

/**
 回调
 */
@property (nonatomic, strong) void(^textureBlock)(NSString * textureName);

@end
