//
//  WZZARManager.m
//  WZZARDemo
//
//  Created by 王泽众 on 2017/12/3.
//  Copyright © 2017年 王泽众. All rights reserved.
//

#import "WZZARManager.h"
@import ARKit;

static WZZARManager * wzzARManager;

@interface WZZARManager ()<ARSessionDelegate> {
    ARSession * arSession;
}

@end

@implementation WZZARManager

//单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wzzARManager = [[WZZARManager alloc] init];
        [wzzARManager setupAR];
    });
    return wzzARManager;
}

//初始化AR
- (void)setupAR {
    arSession = [ARSession new];
    [arSession setDelegate:self];
}

//启动AR
- (void)startAR {
    ARWorldTrackingConfiguration * conf = [ARWorldTrackingConfiguration new];
    conf.planeDetection = ARPlaneDetectionHorizontal;
    [arSession runWithConfiguration:conf];
}

//暂停AR
- (void)pauseAR {
    [arSession pause];
}

#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    matrix_float4x4 a4x4 = frame.camera.transform;
    for (int i = 0; i < 4; i++) {
        simd_float4 af4 = a4x4.columns[i];
        for (int j = 0; j < 4; j++) {
            float af = af4[j];
            printf("%f\t", af);
        }
        printf("\n");
    }
    printf("\n");
}

@end
