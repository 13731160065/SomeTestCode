//
//  WZZVideoPlayerView.h
//  WZZVideoPlayerDemo
//
//  Created by 王泽众 on 2017/5/25.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreMedia;

@interface WZZVideoPlayerView : UIView

/**
 视频url
 */
@property (nonatomic, strong) NSURL * url;

/**
 音量，0静音，1正常
 */
@property (nonatomic, assign) double videoVolume;

/**
 是否自动播放，默认是
 */
@property (nonatomic, assign) BOOL autoPlay;

/**
 视频大小，在视频加载完成后调用，否则返回(0, 0)
 */
@property (nonatomic, assign, readonly) CGSize videoSize;

/**
 进度条能不能滑动
 */
@property (nonatomic, assign) BOOL canProgressScroll;

/**
 播放视频
 */
- (void)play;

/**
 暂停视频
 */
- (void)pause;

/**
 停止视频
 */
- (void)stop;

/**
 加载视频失败回调
 */
- (void)loadVideoFailedBlock:(void(^)(NSString * failedStr))aBlock;

/**
 加载视频完成回调
 */
- (void)loadVideoReadyBlock:(void(^)())aBlock;

/**
 播放结束
 */
- (void)finishedPlay:(void(^)(CMTime))aBlock;

/**
 初始化
 */
- (void)setup;

/**
 再次设置位置
 */
- (void)resetBlock:(void(^)(WZZVideoPlayerView * aView))rb;

/**
 刷新url
 */
- (void)reloadWithUrl:(NSURL *)url;

/**
 快速创建
 Url                    视频地址
 frame                  frame
 loadVideoReadyBlock    视频加载完成回调
 needResetViewBlock     需要重新设置视频视图回调
 */
+ (instancetype)viewWithUrl:(NSURL *)url
                      frame:(CGRect)frame
        loadVideoReadyBlock:(void(^)())loadVideoReadyBlock
         needResetViewBlock:(void(^)(WZZVideoPlayerView * needResetThisView))nrvBlock;

- (void)seekToTime:(CMTime)time;

@end

//用于隐藏statebar
@interface UIViewController (WZZVideoStateBarHandle)

@end
