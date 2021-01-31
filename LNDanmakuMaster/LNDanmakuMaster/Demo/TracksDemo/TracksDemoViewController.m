//
//  TracksDemoViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "TracksDemoViewController.h"

#import "LNDanmakuMaster.h"

@interface TracksDemoViewController () <LNDanmakuPlayerDelegate>

@property (nonatomic, strong) LNDanmakuPlayer* danmakuPlayer;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) TracksDemoViewControllerType type;

@end

@implementation TracksDemoViewController

- (instancetype)initWithType:(TracksDemoViewControllerType)type
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
    
    _timer = [NSTimer timerWithTimeInterval:0.128f target:self selector:@selector(addRandomDanmaku) userInfo:nil repeats:YES];
    
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
    attributes.size = CGSizeMake((rand()%100)/100.f * 200.f + 22.f, 24.f);
//    attributes.danmakuTime = 1.f;
//    attributes.trackTime = 1.f + ((rand()%100)/100.f)*3.f;
    
    float totalTime = 5.f;
    attributes.danmakuTime = (attributes.size.width/(attributes.size.width + self.view.bounds.size.width)) * totalTime;
    attributes.trackTime = (self.view.bounds.size.width/(attributes.size.width + self.view.bounds.size.width)) * totalTime;
    
    //特殊处理
    switch (self.type) {
        case TracksDemoViewControllerCircle:
        case TracksDemoViewControllerChristina:
        case TracksDemoViewControllerSin:
        {
            //曲线适合比较短的弹幕
            attributes.size = CGSizeMake(44.f, 24.f);
        } break;
        case TracksDemoViewControllerPop: {
            //pop轨道需要设定出现位置
            attributes.position = CGPointMake((rand()%100)/100.f * self.view.bounds.size.width, (rand()%100)/100.f * self.view.bounds.size.height);
        } break;
        default:
            break;
    }
    
    
    
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
    switch (self.type) {
        case TracksDemoViewControllerStable: {
            for (int i = 0; i < 20; i++) {
                LNDanmakuStableTrackController *stableTrackController = [[LNDanmakuStableTrackController alloc] init];
                stableTrackController.stableTrack.position = CGPointMake(self.view.bounds.size.width/2.f, 44.f + 30.f * i);
                [self.danmakuPlayer addTrack:stableTrackController];
            }
        } break;
        case TracksDemoViewControllerCircle: {
            for (int i = 0; i < 4; i++) {
                LNDanmakuCircleTrackController *circleTrackController = [[LNDanmakuCircleTrackController alloc] init];
                circleTrackController.circleTrack.center = CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f);
                circleTrackController.circleTrack.radius = (self.view.bounds.size.width/2.f - 30*i);
                [self.danmakuPlayer addTrack:circleTrackController];
                if (circleTrackController.circleTrack.radius < 50.f) {
                    break;
                }
            }
        } break;
        case TracksDemoViewControllerChristina: {
            for (int i = 0; i < 4; i++) {
                LNDanmakuChristinaTrackController *christinaTrackController = [[LNDanmakuChristinaTrackController alloc] init];
                christinaTrackController.christinaTrack.center = CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f);
                christinaTrackController.christinaTrack.a = (self.view.bounds.size.width/2.f - 30*i);
                [self.danmakuPlayer addTrack:christinaTrackController];
                if (christinaTrackController.christinaTrack.a < 50.f) {
                    break;
                }
            }
        } break;
        case TracksDemoViewControllerPop: {
            LNDanmakuPopTrackController *popTrackController = [[LNDanmakuPopTrackController alloc] init];

            [self.danmakuPlayer addTrack:popTrackController];
            popTrackController.popTrack.strategy = LNDanmakuPopTrackStrategyStatic;
        } break;
        case TracksDemoViewControllerSin: {
            //horizontal
            for (int i = 0; i < 4; i++) {
                LNDanmakuSinTrackController *sinTrackController = [[LNDanmakuSinTrackController alloc] init];
                sinTrackController.sinTrack.startPosition = CGPointMake(0, i*20.f + 132.f);
                sinTrackController.sinTrack.width = self.view.frame.size.width;
                sinTrackController.sinTrack.A = 80.f;
                sinTrackController.sinTrack.T = 1.f;
                sinTrackController.spaceTimeInterval = 0.f;
                [self.danmakuPlayer addTrack:sinTrackController];
            }
        } break;
        default:{
            //horizontal
            for (int i = 0; i < 20; i++) {
                LNDanmakuHorizontalMoveTrackController *horizontalTrackController = [[LNDanmakuHorizontalMoveTrackController alloc] init];
                horizontalTrackController.horizontalTrack.startPosition = CGPointMake(0, 44.f + 30.f * i);
                horizontalTrackController.horizontalTrack.width = self.view.frame.size.width;
                horizontalTrackController.spaceTimeInterval = 0.f;
                [self.danmakuPlayer addTrack:horizontalTrackController];
            }
        } break;
    }
    
    [self.danmakuPlayer start];
}

- (LNDanmakuPlayer *)danmakuPlayer
{
    if (!_danmakuPlayer) {
        _danmakuPlayer = [[LNDanmakuPlayer alloc] init];
        _danmakuPlayer.delegate = self;
    }
    return _danmakuPlayer;
}

@end

