//
//  WZZVideoPlayerView.m
//  WZZVideoPlayerDemo
//
//  Created by 王泽众 on 2017/5/25.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZVideoPlayerView.h"
#import <objc/runtime.h>
@import AVFoundation;
@import CoreMedia;

#define PLAYBUTTON @"暂停icon"
#define PAUSEBUTTON @"播放icon"
#define SLIDERBUTTON @"小圆点"
#define FULLSCREENBUTTON @"放大"
#define SMALLSCREENBUTTON @"收缩"

const CGFloat toolBarHeight = 44;
const CGFloat playButtonWH = 15;
const CGFloat fullScreenWH = 15;
const CGFloat timeLabelWidth = 45;
const CGFloat toolBorder = 8;

@interface WZZVideoPlayerView ()<UIGestureRecognizerDelegate> {
#pragma mark - 变量
    AVPlayer * player;//播放器
    AVPlayerItem * playerItem;//播放项目
    AVPlayerLayer * playerLayer;//播放图层
    BOOL isPlaying;//是否正在播放
    UIView * toolBarView;//控制视图
    UIButton * playButton;//播放按钮
    UIButton * bigPlayButton;//大的播放按钮
    UILabel * nowTimeLabel;//当前时间
    UILabel * totalTimeLabel;//总时间
    UISlider * timeSliderView;//时间条
    UIButton * fullScreenButton;//全屏按钮
    UIButton * bigFullScreenButton;//大全屏按钮
    NSTimer * timer;//时间
    BOOL isHidToolBar;//toolbar是否隐藏
    BOOL isDoubletouch;
    BOOL isLeft;//是横屏么
    BOOL isEnd;//是播放完了么
    CGRect oFrame;//原frame
    UIView * oSuperView;//原来view
    UITapGestureRecognizer * oneTap;//单指点击
    UIPanGestureRecognizer * panGes;//拖拽
#pragma mark - block
    void(^_loadVideoFailedBlock)();
    void(^_loadVideoReadyBlock)();
    void(^_resetBlock)(WZZVideoPlayerView *);
    void(^_finishedPlayBlock)();
}

@end

@implementation WZZVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isEnd = YES;
        _autoPlay = YES;
        
    }
    return self;
}

#pragma mark - 外部方法
+ (instancetype)viewWithUrl:(NSURL *)url
                      frame:(CGRect)frame
        loadVideoReadyBlock:(void (^)())loadVideoReadyBlock
         needResetViewBlock:(void (^)(WZZVideoPlayerView *))nrvBlock {
    WZZVideoPlayerView * aView = [[WZZVideoPlayerView alloc] initWithFrame:frame];
    [aView setUrl:url];
    [aView loadVideoReadyBlock:loadVideoReadyBlock];
    [aView resetBlock:nrvBlock];
    [aView setup];
    return aView;
}

//初始化
- (void)setup {
    //用于清除隐藏statebar
    self.tag = 9000;
    [[self superVC] setNeedsStatusBarAppearanceUpdate];
    
    if (!_url) {
        //初始化项目
        playerItem = [AVPlayerItem playerItemWithURL:self.url];
        
        //初始化播放器
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    
    //初始化播放涂层
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.bounds;
    [self.layer addSublayer:playerLayer];
    
    //创建控制UI
    [self creatUI];
    
    [self checkIfRead:^{
        if (_loadVideoReadyBlock) {
            _loadVideoReadyBlock();
        }
    } failed:^{
        if (_loadVideoFailedBlock) {
            _loadVideoFailedBlock();
        }
    }];
    
    //如果自动播放就播放
    if (_autoPlay) {
        [self play];
    }
}

//视频大小
- (CGSize)videoSize {
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return playerItem.presentationSize;
    } else {
        return CGSizeZero;
    }
}

//播放视频
- (void)play {
    if (isEnd) {
        [player seekToTime:kCMTimeZero];
    }
    [self checkIfRead:^{
        [player play];
        isPlaying = YES;
        isEnd = NO;
        [timer invalidate];
        timer = [self startTimer];
        [playButton setBackgroundImage:[UIImage imageNamed:PLAYBUTTON] forState:UIControlStateNormal];
    } failed:^{
        
    }];
}

//暂停
- (void)pause {
    [player pause];
    isPlaying = NO;
    [timer invalidate];
    timer = nil;
    [playButton setBackgroundImage:[UIImage imageNamed:PAUSEBUTTON] forState:UIControlStateNormal];
}

//停止
- (void)stop {
    [self pause];
    isEnd = YES;
}
//刷新url
- (void)reloadWithUrl:(NSURL *)url {
    _url = url;
    
    if (!_url) {
        NSLog(@"视频url为空");
        return;
    }
    
    //初始化项目
    playerItem = [AVPlayerItem playerItemWithURL:self.url];
    
    //初始化播放器
    [player replaceCurrentItemWithPlayerItem:playerItem];
    
    [self checkIfRead:^{
        if (_loadVideoReadyBlock) {
            _loadVideoReadyBlock();
        }
    } failed:^{
        if (_loadVideoFailedBlock) {
            _loadVideoFailedBlock();
        }
    }];
    
    isEnd = YES;
    
    [self reloadFrame:self.frame];
    
    //如果自动播放就播放
    if (_autoPlay) {
        [self play];
    }
}

- (void)seekToTime:(CMTime)time {
    timeSliderView.value = CMTimeGetSeconds(time);
    
    //停止
    [timer invalidate];
    [self removeGestureRecognizer:oneTap];
    
    //时间文字改变
    int oSec = (int)timeSliderView.value;
    int hour = oSec/3600;
    int min = oSec%3600/60;
    int sec = oSec%60;
    [nowTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]];
    
    //播放
    [player seekToTime:time];
    timer = [self startTimer];
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:oneTap];
}

#pragma mark - 点击事件
- (void)playButtonClick {
    if (isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)fullScreenClick {
    isLeft = !isLeft;
    //用于隐藏statebar
    self.tag = 9000+(isLeft?1:0);
    [[self superVC] setNeedsStatusBarAppearanceUpdate];
    if (isLeft) {
        oSuperView = self.superview;
        oFrame = self.frame;
        [UIView animateWithDuration:0.3f animations:^{
            //横屏
            [self removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            [self setTransform:CGAffineTransformRotate(self.transform, M_PI_2)];
            CGSize windowSize = [UIScreen mainScreen].bounds.size;
            self.frame = CGRectMake(0, 0, windowSize.width, windowSize.height+1);
        }];
    } else {
        //竖屏
        [UIView animateWithDuration:0.3f animations:^{
            //横屏
            [self removeFromSuperview];
            [self setTransform:CGAffineTransformMakeRotation(0)];
            self.frame = oFrame;
            if (_resetBlock) {
                _resetBlock(self);
            }
        }];
    }
}

- (void)sliderTouchDown:(UISlider *)slider {
    //停止计时器
    [timer invalidate];
    [self removeGestureRecognizer:oneTap];
//    [self removeGestureRecognizer:panGes];
}

- (void)sliderValueDidChange:(UISlider *)slider {
    //value改变
    int oSec = (int)slider.value;
    int hour = oSec/3600;
    int min = oSec%3600/60;
    int sec = oSec%60;
    [nowTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]];
}

- (void)sliderTouchUp:(UISlider *)slider {
    //抬起手
    [player seekToTime:CMTimeMakeWithSeconds(slider.value, 60)];
    timer = [self startTimer];
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:oneTap];
//    [self addGestureRecognizer:panGes];
}

- (void)selfTap:(UITapGestureRecognizer *)tap {
    if (isHidToolBar) {
        [UIView animateWithDuration:0.3f animations:^{
            [toolBarView setAlpha:1.0f];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [toolBarView setAlpha:0.0f];
        }];
    }
    isHidToolBar = !isHidToolBar;
}

- (void)selfPan:(UIPanGestureRecognizer *)pan {
//    CGPoint point = [tap translationInView:tap.view];
}

- (void)selfDoubleTap:(UITapGestureRecognizer *)tap {
    [self playButtonClick];
}

#pragma mark - 内部方法
//检查视频加载是否完成
- (void)checkIfRead:(void(^)())aBlock failed:(void(^)())failedBlock {
    //检查是不是准备好了
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        if (aBlock) {
            aBlock();
        }
    } else if (playerItem.status == AVPlayerItemStatusFailed) {
        if (failedBlock) {
            failedBlock();
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkIfRead:aBlock failed:failedBlock];
        });
    }
}

//创建操作UI
- (void)creatUI {
    //背景
    toolBarView = [[UIView alloc] init];
    [self addSubview:toolBarView];
    [toolBarView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    
    //播放按钮
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarView addSubview:playButton];
    [playButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [playButton setBackgroundImage:[UIImage imageNamed:PLAYBUTTON] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //大播放按钮
    bigPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarView addSubview:bigPlayButton];
    [bigPlayButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //现在时间
    nowTimeLabel = [[UILabel alloc] init];
    [toolBarView addSubview:nowTimeLabel];
    [nowTimeLabel setFont:[UIFont systemFontOfSize:10]];
//    [nowTimeLabel setAdjustsFontSizeToFitWidth:YES];
    [nowTimeLabel setTextColor:[UIColor whiteColor]];
    //总时间
    totalTimeLabel = [[UILabel alloc] init];
    [toolBarView addSubview:totalTimeLabel];
    [totalTimeLabel setFont:nowTimeLabel.font];
    [totalTimeLabel setAdjustsFontSizeToFitWidth:nowTimeLabel.adjustsFontSizeToFitWidth];
    [totalTimeLabel setTextColor:nowTimeLabel.textColor];

    //时间条
    timeSliderView = [[UISlider alloc] init];
    [toolBarView addSubview:timeSliderView];
    [timeSliderView setThumbImage:[UIImage imageNamed:SLIDERBUTTON] forState:UIControlStateNormal];
    [timeSliderView setThumbImage:[UIImage imageNamed:SLIDERBUTTON] forState:UIControlStateHighlighted];
    timeSliderView.maximumTrackTintColor = [UIColor grayColor];
    timeSliderView.minimumTrackTintColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    [timeSliderView addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [timeSliderView addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [timeSliderView addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [timeSliderView addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    //全屏按钮
    fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarView addSubview:fullScreenButton];
    [fullScreenButton setBackgroundImage:[UIImage imageNamed:FULLSCREENBUTTON] forState:UIControlStateNormal];
    [fullScreenButton addTarget:self action:@selector(fullScreenClick) forControlEvents:UIControlEventTouchUpInside];
    
    //大全屏按钮
    bigFullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolBarView addSubview:bigFullScreenButton];
    [bigFullScreenButton addTarget:self action:@selector(fullScreenClick) forControlEvents:UIControlEventTouchUpInside];
    [self reloadFrame:self.frame];
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
//    panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfPan:)];
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDoubleTap:)];
    oneTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    
//    [self addGestureRecognizer:panGes];
    [self addGestureRecognizer:oneTap];
    [self addGestureRecognizer:doubleTap];
}

- (void)reloadFrame:(CGRect)frame {
    if (isLeft) {
        //横屏
        [toolBarView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width-44, [UIScreen mainScreen].bounds.size.height, 44)];
        [playButton setFrame:CGRectMake(8, toolBarHeight/2-playButtonWH/2, playButtonWH, playButtonWH)];
        [bigPlayButton setFrame:CGRectMake(0, 0, CGRectGetMaxX(playButton.frame)+toolBorder, toolBarHeight)];
        [nowTimeLabel setFrame:CGRectMake(CGRectGetMaxX(playButton.frame)+toolBorder, 0, timeLabelWidth, toolBarHeight)];
        [fullScreenButton setFrame:CGRectMake(toolBarView.frame.size.width-8-fullScreenWH, toolBarHeight/2-fullScreenWH/2, fullScreenWH, fullScreenWH)];
        [totalTimeLabel setFrame:CGRectMake(CGRectGetMinX(fullScreenButton.frame)-timeLabelWidth-toolBorder, 0, timeLabelWidth, nowTimeLabel.frame.size.height)];
        [bigFullScreenButton setFrame:CGRectMake(CGRectGetMaxX(totalTimeLabel.frame), 0, toolBarView.frame.size.width-CGRectGetMaxX(totalTimeLabel.frame), toolBarHeight)];
        [timeSliderView setFrame:CGRectMake(CGRectGetMaxX(nowTimeLabel.frame)+toolBorder, 0, CGRectGetMinX(totalTimeLabel.frame)-CGRectGetMaxX(nowTimeLabel.frame)-toolBorder*2, toolBarHeight)];
        [self checkIfRead:^{
            int oSec = CMTimeGetSeconds(playerItem.asset.duration);
            int hour = oSec/3600;
            int min = oSec%3600/60;
            int sec = oSec%60;
            [totalTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]];
            timeSliderView.maximumValue = CMTimeGetSeconds(playerItem.asset.duration);
            timeSliderView.minimumValue = 0.0f;
        } failed:^{
            
        }];
    } else {
        [toolBarView setFrame:CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44)];
        [playButton setFrame:CGRectMake(8, toolBarHeight/2-playButtonWH/2, playButtonWH, playButtonWH)];
        [bigPlayButton setFrame:CGRectMake(0, 0, CGRectGetMaxX(playButton.frame)+toolBorder, toolBarHeight)];
        [nowTimeLabel setFrame:CGRectMake(CGRectGetMaxX(playButton.frame)+toolBorder, 0, timeLabelWidth, toolBarHeight)];
        [fullScreenButton setFrame:CGRectMake(toolBarView.frame.size.width-8-fullScreenWH, toolBarHeight/2-fullScreenWH/2, fullScreenWH, fullScreenWH)];
        [totalTimeLabel setFrame:CGRectMake(CGRectGetMinX(fullScreenButton.frame)-timeLabelWidth-toolBorder, 0, timeLabelWidth, nowTimeLabel.frame.size.height)];
        [bigFullScreenButton setFrame:CGRectMake(CGRectGetMaxX(totalTimeLabel.frame), 0, toolBarView.frame.size.width-CGRectGetMaxX(totalTimeLabel.frame), toolBarHeight)];
        [timeSliderView setFrame:CGRectMake(CGRectGetMaxX(nowTimeLabel.frame)+toolBorder, 0, CGRectGetMinX(totalTimeLabel.frame)-CGRectGetMaxX(nowTimeLabel.frame)-toolBorder*2, toolBarHeight)];
        [self checkIfRead:^{
            int oSec = CMTimeGetSeconds(playerItem.asset.duration);
            int hour = oSec/3600;
            int min = oSec%3600/60;
            int sec = oSec%60;
            [totalTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]];
            timeSliderView.maximumValue = CMTimeGetSeconds(playerItem.asset.duration);
            timeSliderView.minimumValue = 0.0f;
        } failed:^{
            
        }];
    }
}

//计时器开始
- (NSTimer *)startTimer {
    NSTimer * tim = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerRuning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:tim forMode:NSRunLoopCommonModes];
    return tim;
}

- (void)timerRuning {
    double endTime = CMTimeGetSeconds(playerItem.asset.duration);
    double timeDouble = CMTimeGetSeconds(playerItem.currentTime);
    int timeInt = (int)timeDouble;
    int hour = timeInt/3600;
    int min = timeInt%3600/60;
    int sec = timeInt%60;
    timeSliderView.value = timeDouble;
    [nowTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec]];
    if (timeDouble >= endTime-0.1) {
        //播放结束
        [self stop];
        if (_finishedPlayBlock) {
            _finishedPlayBlock();
        }
    }
}

- (void)setVideoVolume:(double)videoVolume {
    player.volume = videoVolume;
}

//改变系统声音
- (void)setVolume:(float)volume{
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    [allAudioParams addObject:audioInputParams];
    AVMutableAudioMix * audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [player.currentItem setAudioMix:audioMix];
    
    [player setVolume:volume];
}

#pragma mark - getset方法
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //视频图层和view同步
    [playerLayer setFrame:self.bounds];
    [self reloadFrame:frame];
}

- (void)setCanProgressScroll:(BOOL)canProgressScroll {
    _canProgressScroll = canProgressScroll;
    [timeSliderView setUserInteractionEnabled:NO];
}

#pragma mark - block赋值
- (void)loadVideoFailedBlock:(void (^)(NSString *))aBlock {
    if (_loadVideoFailedBlock != aBlock) {
        _loadVideoFailedBlock = aBlock;
    }
}

- (void)loadVideoReadyBlock:(void (^)())aBlock {
    if (_loadVideoReadyBlock != aBlock) {
        _loadVideoReadyBlock = aBlock;
    }
}

- (void)resetBlock:(void (^)(WZZVideoPlayerView *))rb {
    if (_resetBlock != rb) {
        _resetBlock = rb;
    }
}

- (void)finishedPlay:(void (^)())aBlock {
    if (_finishedPlayBlock != aBlock) {
        _finishedPlayBlock = aBlock;
    }
}

- (UIViewController *)superVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

@end

//用于隐藏statebar
@implementation UIViewController (WZZVideoStateBarHandle)

- (BOOL)prefersStatusBarHidden {
    BOOL iii = NO;
    if ([self.view viewWithTag:9001]) {
        iii = YES;
    }
    return iii;
}

@end
