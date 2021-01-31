//
//  VideoDanmakuDemoViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "VideoDanmakuDemoViewController.h"
#import "VideoPlayer.h"

@interface VideoDanmakuDemoViewController () <VideoPlayerDelegate>

@property (nonatomic, strong) VideoPlayer *player;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) VideoModel *videoModel;

@end

@implementation VideoDanmakuDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self addConstraints];
}

- (void)addSubviews
{
    [self.view addSubview:self.player.playerView];
    [self.view addSubview:self.slider];
}

- (void)addConstraints
{
    self.player.playerView.frame = self.view.bounds;
    self.slider.frame = CGRectMake(50.f, self.view.bounds.size.height - 44.f, self.view.bounds.size.width - 100.f, 44.f);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.player stop];
}

- (VideoPlayer *)player
{
    if (!_player) {
        _player = [[VideoPlayer alloc] initWithVideoModel:self.videoModel];
        _player.delegate = self;
    }
    return _player;
}

- (VideoModel *)videoModel
{
    if (!_videoModel) {
        _videoModel = [[VideoModel alloc] init];
        _videoModel.totalTime = 200.f;
        _videoModel.url = @"";
    }
    return _videoModel;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        [_slider addTarget:self action:@selector(sliderValueDidChange) forControlEvents:UIControlEventValueChanged];
        _slider.minimumValue = 0.f;
        _slider.maximumValue = self.videoModel.totalTime;
    }
    return _slider;
}

- (void)sliderValueDidChange
{
    if (!self.slider.isTracking) {
        [self.player seek:self.slider.value];
    }
}

#pragma -mark videoDelegate

- (void)videoPlayerProgress:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    if (!self.slider.isTracking) {
        self.slider.value = currentTime;
    }
}

- (void)videoPlayerStatusDidChangeFrom:(VideoPlayerStatus)originStatus to:(VideoPlayerStatus)targetStatus
{
    
}

@end
