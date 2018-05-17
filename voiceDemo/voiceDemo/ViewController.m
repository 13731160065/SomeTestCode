//
//  ViewController.m
//  voiceDemo
//
//  Created by 王泽众 on 2018/5/17.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "ViewController.h"
#import "WZZVideoPlayerView.h"
#import "WZZVideoHandler.h"
@import AVFoundation;
@import AudioToolbox;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    AVAudioRecorder * recorder;
    AVAudioPlayer * player;
    AVAudioPlayer * p2;
    AVAudioSession * audioSession;
    NSString * playName;
    WZZVideoPlayerView * videoView;
    NSMutableArray * dataArr;
    NSIndexPath * indexP;
}
@property (weak, nonatomic) IBOutlet UIView *videoBackView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    dataArr = [NSMutableArray array];
    [dataArr addObject:@{
                         @"stime":@(15),
                         @"etime":@(20)
                         }];
    [dataArr addObject:@{
                         @"stime":@(25),
                         @"etime":@(30)
                         }];
    [dataArr addObject:@{
                         @"stime":@(35),
                         @"etime":@(40)
                         }];
    
    //音频会话
    audioSession = [AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSLog(@"%@", NSHomeDirectory());
    
    playName = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"fff.caf"];
    
    videoView = [WZZVideoPlayerView viewWithUrl:nil frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-15*2, _videoBackView.bounds.size.height) loadVideoReadyBlock:^{
        
    } needResetViewBlock:^(WZZVideoPlayerView *needResetThisView) {
        [_videoBackView insertSubview:needResetThisView atIndex:0];
    }];
//    [videoView setAutoPlay:NO];
    [_videoBackView addSubview:videoView];
}

- (IBAction)getVoice:(id)sender {
    NSLog(@"暂不可用");
    return;
    //录音设置
    NSMutableDictionary * settingDic = [NSMutableDictionary dictionary];
    //设置录音格式
    settingDic[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    settingDic[AVSampleRateKey] = @(8000);
    //设置通道,这里采用单声道
    settingDic[AVNumberOfChannelsKey] = @(1);
    //每个采样点位数,分为8、16、24、32
    settingDic[AVLinearPCMBitDepthKey] = @(8);
    //是否使用浮点数采样
    settingDic[AVLinearPCMIsFloatKey] = @(YES);
    
    NSError *error = nil;
    //必须真机上测试,模拟器上可能会崩溃
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:playName] settings:settingDic error:&error];
    
    if (!error) {
        //是否允许刷新电平表，默认是off
        recorder.meteringEnabled = YES;
        //创建文件，并准备录音
        [recorder prepareToRecord];
        //开始录音
        [recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecVoice];
        });
    } else {
        NSLog(@"Error:%@" , error);
    }
}

//录制音频
- (void)recVoice {
    //录音设置
    NSMutableDictionary * settingDic = [NSMutableDictionary dictionary];
    //设置录音格式
    settingDic[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    settingDic[AVSampleRateKey] = @(8000);
    //设置通道,这里采用单声道
    settingDic[AVNumberOfChannelsKey] = @(1);
    //每个采样点位数,分为8、16、24、32
    settingDic[AVLinearPCMBitDepthKey] = @(8);
    //是否使用浮点数采样
    settingDic[AVLinearPCMIsFloatKey] = @(YES);
    
    NSError *error = nil;
    
    NSString * outPath = [NSString stringWithFormat:@"%@/Documents/%zd.caf", NSHomeDirectory(), indexP.row];
    //必须真机上测试,模拟器上可能会崩溃
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:outPath] settings:settingDic error:&error];
    
    if (!error) {
        //是否允许刷新电平表，默认是off
        recorder.meteringEnabled = YES;
        //创建文件，并准备录音
        [recorder prepareToRecord];
        //开始录音
        [recorder record];
        
        NSDictionary * dic = dataArr[indexP.row];
        NSInteger stime = [dic[@"stime"] integerValue];
        NSInteger etime = [dic[@"etime"] integerValue];
        double timeSec = etime-stime;
        
        NSString * mp4Path = [[NSBundle mainBundle] pathForResource:@"复仇者联盟2" ofType:@"mp4"];
        NSURL * url = [NSURL fileURLWithPath:mp4Path];
        [videoView reloadWithUrl:url];
        [videoView seekToTime:stime];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeSec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecVoice];
            [videoView stop];
        });
    } else {
        NSLog(@"Error:%@" , error);
    }
}

- (void)stopRecVoice {
    //录音停止
    [recorder stop];
    recorder = nil;
    NSLog(@"录音结束");
    
    _mainTableView.userInteractionEnabled = YES;
    [_mainTableView deselectRowAtIndexPath:indexP animated:YES];
    //自动播放
//    [self playVoice:nil];
}

- (IBAction)playVoice:(id)sender {
    NSLog(@"暂不可用");
    return;
    NSError *playerError;
    
    //播放
    player = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:playName] error:&playerError];
    
    NSString * mp3Path = [[NSBundle mainBundle] pathForResource:@"-Rissa mento" ofType:@"mp3"];
    p2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mp3Path] error:nil];
    
    NSString * mp4Path = [[NSBundle mainBundle] pathForResource:@"复仇者联盟2" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:mp4Path];
    
    if (player == nil) {
        NSLog(@"ERror creating player: %@", [playerError description]);
    } else {
        [player prepareToPlay];
        [p2 prepareToPlay];
        [player play];
        [p2 play];
        
        videoView.autoPlay = NO;
        [videoView reloadWithUrl:url];
        
        [videoView seekToTime:20];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [player stop];
            [p2 stop];
            [videoView stop];
        });
    }
}

- (IBAction)playVideo:(id)sender {
    NSString * outStr = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"tmpRemixVideo.mp4"];
    NSURL * outUrl = [NSURL fileURLWithPath:outStr];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outStr)) {
        //保存相册核心代码
        UISaveVideoAtPathToSavedPhotosAlbum(outStr, self, nil, nil);
    }
    
    return;
    NSString * mp4Path = [[NSBundle mainBundle] pathForResource:@"复仇者联盟2" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:mp4Path];
    [videoView reloadWithUrl:url];
}

- (IBAction)remixAV:(id)sender {
    //视频路径
    NSURL * videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"复仇者联盟2" ofType:@"mp4"]];
    
    //输出路径
    NSString * outStr = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"tmpRemixVideo.mp4"];
    NSURL * outUrl = [NSURL fileURLWithPath:outStr];
    [[NSFileManager defaultManager] removeItemAtURL:outUrl error:nil];
    
    WZZVideoHandlerAssetModel * videoModel = [WZZVideoHandlerAssetModel modelWithAssetURL:videoURL timeRange:kCMTimeRangeZero];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary * dic = dataArr[i];
        NSInteger stime = [dic[@"stime"] integerValue];
        NSInteger etime = [dic[@"etime"] integerValue];
        double timeSec = etime-stime;
        NSString * audioPath = [NSString stringWithFormat:@"%@/Documents/%d.caf", NSHomeDirectory(), i];
        NSURL * url = [NSURL fileURLWithPath:audioPath];
        WZZVideoHandlerAssetModel * audioModel1 = [WZZVideoHandlerAssetModel modelWithAssetURL:url timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(stime, 60), CMTimeMakeWithSeconds(timeSec, 60))];
        [arr addObject:audioModel1];
    }
    
    [WZZVideoHandler remixAVWithVideoModel:videoModel audioModelArray:arr outURL:outUrl successBlock:^{
        [videoView reloadWithUrl:outUrl];
        [videoView play];
    } failedBlock:^(NSError *error) {
        
    }];
    
#if 0
    //音频路径
    NSURL * audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"-Rissa mento" ofType:@"mp3"]];
    
    //视频路径
    NSURL * videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"复仇者联盟2" ofType:@"mp4"]];
    
    //输出路径
    NSString * outStr = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"tmpRemixVideo.mp4"];
    NSURL * outUrl = [NSURL fileURLWithPath:outStr];
    [[NSFileManager defaultManager] removeItemAtURL:outUrl error:nil];
    
    WZZVideoHandlerAssetModel * videoModel = [WZZVideoHandlerAssetModel modelWithAssetURL:videoURL timeRange:kCMTimeRangeZero];
    
    NSMutableArray * arr = [NSMutableArray array];
    WZZVideoHandlerAssetModel * audioModel1 = [WZZVideoHandlerAssetModel modelWithAssetURL:audioURL timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(5, 60), CMTimeMakeWithSeconds(5, 60))];
    [arr addObject:audioModel1];
    
    WZZVideoHandlerAssetModel * audioModel2 = [WZZVideoHandlerAssetModel modelWithAssetURL:audioURL timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(15, 60), CMTimeMakeWithSeconds(5, 60))];
    [arr addObject:audioModel2];
    
    WZZVideoHandlerAssetModel * audioModel3 = [WZZVideoHandlerAssetModel modelWithAssetURL:audioURL timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(25, 60), CMTimeMakeWithSeconds(5, 60))];
    [arr addObject:audioModel3];
    
    [WZZVideoHandler remixAVWithVideoModel:videoModel audioModelArray:arr outURL:outUrl successBlock:^{
        [videoView reloadWithUrl:outUrl];
        [videoView play];
    } failedBlock:^(NSError *error) {
        
    }];
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic = dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"[%zd] %@-%@ 点击开始录音", indexPath.row, dic[@"stime"], dic[@"etime"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexP = indexPath;
    _mainTableView.userInteractionEnabled = NO;
    [self recVoice];
}

@end
