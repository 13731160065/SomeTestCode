//
//  WZZVideoHandler.m
//  voiceDemo
//
//  Created by 王泽众 on 2018/5/17.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZVideoHandler.h"
@import CoreMedia;
@import AVFoundation;

#define WZZVideoHandler_ZHEN 60

@interface WZZVideoHandler ()

@end

@implementation WZZVideoHandler

//合成音视频
+ (void)remixAVWithVideoModel:(WZZVideoHandlerAssetModel *)videoModel
              audioModelArray:(NSArray<WZZVideoHandlerAssetModel *> *)audioModelArr
                       outURL:(NSURL *)outURL
                 successBlock:(void (^)(void))successBlock
                  failedBlock:(void (^)(NSError *))failedBlock {
    WZZVideoHandler * handler = [[WZZVideoHandler alloc] init];
    [handler remixAVWithVideoModel:videoModel audioModelArray:audioModelArr outURL:outURL completeBlock:^(AVAssetExportSessionStatus status, NSError * error) {
        if (status == AVAssetExportSessionStatusCompleted) {
            if (successBlock) {
                successBlock();
            }
        } else {
            if (failedBlock) {
                failedBlock(error);
            }
        }
    }];
}

- (void)remixAVWithVideoModel:(WZZVideoHandlerAssetModel *)videoModel
              audioModelArray:(NSArray<WZZVideoHandlerAssetModel *> *)audioModelArr
                       outURL:(NSURL *)outURL
             completeBlock:(void(^)(AVAssetExportSessionStatus status, NSError * error))completeBlock {
    //音视频合成器
    AVMutableComposition * mutiComposition = [AVMutableComposition composition];
    
    //MARK:视频资源解析
    //源视频资源
    AVURLAsset * videoAsset = [AVURLAsset assetWithURL:videoModel.assetURL];
    //从源视频资源提出视频轨道
    AVAssetTrack * videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //源视频音频
    AVAssetTrack * orgAudioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    //MARK:视频添加到合成器
    //让合成器添加一个视频轨，并返回视频轨
    AVMutableCompositionTrack * videoTrack = [mutiComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //起始时间
    CMTime videoStartTime = kCMTimeZero;
    //视频时间范围
    CMTimeRange videoRange = CMTimeRangeMake(videoStartTime, videoAsset.duration);
    //将源视频的视频轨放入合成器的视频轨
    NSError * err = nil;
    [videoTrack insertTimeRange:videoRange ofTrack:videoAssetTrack atTime:videoStartTime error:&err];
    if (err) {
        NSLog(@">>>>>%@", err);
        return;
    }
    
    //MARK:音频添加到合成器
    //创建音轨
    AVMutableCompositionTrack * newAudioTrack = [mutiComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //创建源视频音轨
    AVMutableCompositionTrack * orgAudioTrack = [mutiComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //创建减弱源视频音轨
    AVMutableCompositionTrack * orgPAudioTrack = [mutiComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //时间排序
    NSMutableArray * audioSortArr = [NSMutableArray arrayWithArray:audioModelArr];
    for (int i = 0; i < audioSortArr.count; i++) {
        for (int j = 0; j < audioSortArr.count-i-1; j++) {
            WZZVideoHandlerAssetModel * model1 = audioSortArr[j];
            WZZVideoHandlerAssetModel * model2 = audioSortArr[j+1];
            //如果1>2，交换
            if (CMTimeCompare(model1.timeRange.start, model2.timeRange.start) > 0) {
                [audioSortArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    //补充源视频音频，顺便合成新音频片段
    CMTime currentTime = kCMTimeZero;//时间指针
    for (int i = 0; i < audioSortArr.count; i++) {
        //model
        WZZVideoHandlerAssetModel * model = audioSortArr[i];
        
        if (CMTimeCompare(model.timeRange.start, currentTime) > 0) {
            //当前音频段的开始时间大于时间指针的时间的情况
            //源音频片段范围
            CMTime start = currentTime;
            CMTime duration = CMTimeSubtract(model.timeRange.start, currentTime);
            CMTimeRange range = CMTimeRangeMake(start, duration);

            //源音频片段添加至音轨
            NSError * tmpErr = nil;
            [orgAudioTrack insertTimeRange:range ofTrack:orgAudioAssetTrack atTime:currentTime error:&tmpErr];
            if (tmpErr) {
                NSLog(@">>>>>%@", tmpErr);
                return;
            }

            //减弱的源音频片段添加至音轨
            tmpErr = nil;
            [orgPAudioTrack insertTimeRange:CMTimeRangeMake(model.timeRange.start, model.timeRange.duration) ofTrack:orgAudioAssetTrack atTime:model.timeRange.start error:&tmpErr];
            if (tmpErr) {
                NSLog(@">>>>>2%@", tmpErr);
                return;
            }
        } else if (CMTimeCompare(CMTimeAdd(model.timeRange.start, model.timeRange.duration), currentTime) > 0) {
            //当不满足开始时间大于时间指针时间，且满足结束时间大于时间指针时间时
            //源音频片段范围
            CMTime start = currentTime;
            CMTime duration = CMTimeSubtract(CMTimeAdd(model.timeRange.start, model.timeRange.duration), currentTime);
            CMTimeRange range = CMTimeRangeMake(start, duration);
            
            //减弱的源音频片段添加至音轨
            NSError * tmpErr = nil;
            [orgPAudioTrack insertTimeRange:range ofTrack:orgAudioAssetTrack atTime:currentTime error:&tmpErr];
            if (tmpErr) {
                NSLog(@">>>>>%@", tmpErr);
                return;
            }
        } else {
            //其他情况不用添加任何音轨
        }
        
        //时间指针指向本段插入音频的末尾
        currentTime = CMTimeAdd(model.timeRange.start, model.timeRange.duration);
        //合成新音频片段
        AVURLAsset * newAudioAsset = [AVURLAsset assetWithURL:model.assetURL];
        AVAssetTrack * newAudioAssetTrack = [[newAudioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        NSError * tmpErr = nil;
        [newAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, model.timeRange.duration) ofTrack:newAudioAssetTrack atTime:model.timeRange.start error:&tmpErr];
        if (tmpErr) {
            NSLog(@">>>>>%@", tmpErr);
            return;
        }
    }
    //最终插入末尾音频
    WZZVideoHandlerAssetModel * model = [audioSortArr lastObject];
    NSError * tmpErr = nil;
    CMTime endTime = CMTimeRangeGetEnd(model.timeRange);
    [orgAudioTrack insertTimeRange:CMTimeRangeMake(endTime, CMTimeSubtract(videoAsset.duration, endTime)) ofTrack:orgAudioAssetTrack atTime:currentTime error:&tmpErr];
    
    //混音操作，降低音量
    //混音输入参数
    AVMutableAudioMixInputParameters * audioMixInputParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:orgPAudioTrack];
    [audioMixInputParam setVolume:0.3f atTime:kCMTimeZero];
    //混音处理者
    AVMutableAudioMix * audioMixHandler = [AVMutableAudioMix audioMix];
    audioMixHandler.inputParameters = @[audioMixInputParam];//设置输入参数
    
    
    AVAssetExportSession * session = [AVAssetExportSession exportSessionWithAsset:mutiComposition presetName:AVAssetExportPresetMediumQuality];
    session.outputFileType = AVFileTypeMPEG4;
    session.outputURL = outURL;
    session.shouldOptimizeForNetworkUse = YES;//尽可能优化以供网络使用
    session.audioMix = audioMixHandler;
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(session.status, session.error);
            }
        });
    }];
}

@end

@implementation WZZVideoHandlerAssetModel

+ (instancetype)modelWithAssetURL:(NSURL *)assetURL
                        timeRange:(CMTimeRange)timeRange {
    WZZVideoHandlerAssetModel * model = [[WZZVideoHandlerAssetModel alloc] init];
    model.assetURL = assetURL;
    model.timeRange = timeRange;
    if (CMTimeRangeEqual(timeRange, kCMTimeRangeZero)) {
        AVURLAsset * asset = [AVURLAsset assetWithURL:assetURL];
        model.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    }
    return model;
}

@end
