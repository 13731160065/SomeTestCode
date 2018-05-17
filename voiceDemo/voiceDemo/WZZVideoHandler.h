//
//  WZZVideoHandler.h
//  voiceDemo
//
//  Created by 王泽众 on 2018/5/17.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreMedia;
@class WZZVideoHandlerAssetModel;

@interface WZZVideoHandler : NSObject

/**
 合成音视频

 @param videoModel 视频url
 @param audioModelArr 音频url数组
 @param outURL 输出url
 @param successBlock 成功
 @param failedBlock 失败
 */
+ (void)remixAVWithVideoModel:(WZZVideoHandlerAssetModel *)videoModel
                   audioModelArray:(NSArray <WZZVideoHandlerAssetModel *>*)audioModelArr
                      outURL:(NSURL *)outURL
                successBlock:(void(^)(void))successBlock
                 failedBlock:(void(^)(NSError * error))failedBlock;

@end

@interface WZZVideoHandlerAssetModel : NSObject

/**
 资源路径
 */
@property (nonatomic, strong) NSURL * assetURL;

/**
 时间范围
 */
@property (nonatomic, assign) CMTimeRange timeRange;

/**
 创建model

 @param assetURL 路径
 @param timeRange 时间范围，直接使用资源长度传kCMTimeRangeZero即可
 */
+ (instancetype)modelWithAssetURL:(NSURL *)assetURL
                timeRange:(CMTimeRange)timeRange;

@end
