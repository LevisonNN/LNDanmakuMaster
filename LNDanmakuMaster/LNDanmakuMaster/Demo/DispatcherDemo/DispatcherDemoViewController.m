//
//  DispatcherDemoViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "DispatcherDemoViewController.h"
#import "LNDanmakuMaster.h"

@interface DispatcherDemoViewController ()

@property (nonatomic, assign) DispatcherDemoViewControllerType type;

@property (nonatomic, strong) LNDanmakuPlayer* danmakuPlayer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DispatcherDemoViewController

- (instancetype)initWithType:(DispatcherDemoViewControllerType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayer];
    [self addSubviews];
    [self addConstraints];
    
    _timer = [NSTimer timerWithTimeInterval:0.256f target:self selector:@selector(addRandomDanmaku) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc
{
    NSLog(@"释放了");
}

- (void)addRandomDanmaku
{
    LNDanmakuLayer *danmakuLayer = [[LNDanmakuLayer alloc] init];
    danmakuLayer.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:1.f].CGColor;
    danmakuLayer.cornerRadius = 12.f;
    LNDanmakuAttributes *attributes = [[LNDanmakuAttributes alloc] init];
    attributes.presentLayer = danmakuLayer;
    attributes.size = CGSizeMake((rand()%100)/100.f * 88.f + 22.f, 24.f);
    attributes.danmakuTime = 2.f;
    attributes.trackTime = 2.f + ((rand()%100)/100.f)*4.f;
    [self.danmakuPlayer insertAttributes:@[attributes]];
}

- (void)addSubviews
{
    [self.view addSubview:self.danmakuPlayer.containerView];
}

- (void)addConstraints
{
    self.danmakuPlayer.containerView.frame = self.view.bounds;
}

- (void)setupPlayer
{
    for (int i = 0; i < 20; i++) {
        LNDanmakuHorizontalMoveTrackController *horizontalTrackController = [[LNDanmakuHorizontalMoveTrackController alloc] init];
        horizontalTrackController.horizontalTrack.startPosition = CGPointMake(0, 44.f + 30.f * i);
        horizontalTrackController.horizontalTrack.width = self.view.frame.size.width;
        horizontalTrackController.spaceTimeInterval = 0.2f;
        [self.danmakuPlayer addTrack:horizontalTrackController];
    }
    
    [self.danmakuPlayer start];
}

- (LNDanmakuPlayer *)danmakuPlayer
{
    if (!_danmakuPlayer) {
        _danmakuPlayer = [[LNDanmakuPlayer alloc] init];
        switch (self.type) {
            case DispatcherDemoViewControllerMostFast: {
                _danmakuPlayer.dispatcher.dispatchStrategy = LNDanmakuDispatchStrategyMostFastDisplay;
            } break;
            case DispatcherDemoViewControllerLowDensity: {
                _danmakuPlayer.dispatcher.dispatchStrategy = LNDanmakuDispatchStrategyLowDensity;
            } break;;
            default:{
                _danmakuPlayer.dispatcher.dispatchStrategy = LNDanmakuDispatchStrategyDefault;
            } break;
        }
    }
    return _danmakuPlayer;
}

@end

