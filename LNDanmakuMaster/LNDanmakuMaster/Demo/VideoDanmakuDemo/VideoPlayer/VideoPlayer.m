//
//  VideoPlayer.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "VideoPlayer.h"

@implementation VideoModel

@end

@interface VideoPlayer ()

@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, assign) VideoPlayerStatus status;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, assign) CGFloat r; // step = 1
@property (nonatomic, assign) CGFloat g; // step = 3
@property (nonatomic, assign) CGFloat b; // step = 5

@end

@implementation VideoPlayer

- (instancetype)initWithVideoModel:(VideoModel *)videoModel
{
    self = [super init];
    if (self) {
        self.totalTime = videoModel.totalTime;
        self.currentTime = 0.f;
    }
    return self;
}

- (void)setStatus:(VideoPlayerStatus)status
{
    if (_status != status) {
        VideoPlayerStatus originStatus = _status;
        _status = status;
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerStatusDidChangeFrom:to:)]) {
            [self.delegate videoPlayerStatusDidChangeFrom:originStatus to:status];
        }
    }
}

- (void)invalidTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)restartTimer
{
    [self invalidTimer];
    _timer = [NSTimer timerWithTimeInterval:0.025f target:self selector:@selector(flashAndCallBack) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//这看起来只是颜色变化，实则在播放视频 o(*￣︶￣*)o
- (void)flashAndCallBack
{
    if (self.status != VideoPlayerStatusPlaying) {
        return;
    }
    
    if (self.totalTime - self.currentTime < 0.025f) {
        //播放结束
        [self stop];
    } else {
        self.currentTime += 0.025f;
    }
    
    NSInteger accumulatedR = ((NSInteger)floor(self.currentTime/0.025f) * 1)%510;
    NSInteger accumulatedG = ((NSInteger)floor(self.currentTime/0.025f) * 3)%510;
    NSInteger accumulatedB = ((NSInteger)floor(self.currentTime/0.025f) * 5)%510;
    
    if (accumulatedR > 255) {
        self.r = (510 - accumulatedR)/255.f;
    } else {
        self.r = accumulatedR/255.f;
    }
    
    if (accumulatedG > 255) {
        self.g = (510 - accumulatedG)/255.f;
    } else {
        self.g = accumulatedG/255.f;
    }
    
    if (accumulatedB > 255) {
        self.b = (510 - accumulatedB)/255.f;
    } else {
        self.b = accumulatedB/255.f;
    }
    
    self.playerView.backgroundColor = [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:0.2f];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerProgress:totalTime:)]) {
        [self.delegate videoPlayerProgress:self.currentTime totalTime:self.totalTime];
    }
}

- (void)start
{
    self.status = VideoPlayerStatusPlaying;
    self.currentTime = 0.f;
    [self invalidTimer];
    [self restartTimer];
}
- (void)pause
{
    self.status = VideoPlayerStatusPaused;
}

- (void)resume
{
    self.status = VideoPlayerStatusPlaying;
}

- (void)stop
{
    self.status = VideoPlayerStatusStopped;
    [self invalidTimer];
    self.currentTime = 0.f;
}

- (void)seek:(NSTimeInterval)targetTime
{
    if (targetTime >= 0.f && targetTime <= self.totalTime) {
        self.currentTime = targetTime;
    }
}

- (UIView *)playerView
{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

@end

