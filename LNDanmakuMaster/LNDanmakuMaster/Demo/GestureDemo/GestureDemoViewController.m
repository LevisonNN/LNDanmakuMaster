//
//  GestureDemoViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "GestureDemoViewController.h"
#import "LNDanmakuMaster.h"

@interface GestureDemoViewController () <LNDanmakuPlayerDelegate>

@property (nonatomic, strong) LNDanmakuPlayer* danmakuPlayer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GestureDemoViewController

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
    LNDanmakuAttributes *attributes = [[LNDanmakuAttributes alloc] init];
    if (rand()%2) {
        //Layer
        LNDanmakuLayer *danmakuLayer = [[LNDanmakuLayer alloc] init];
        danmakuLayer.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:1.f].CGColor;
        danmakuLayer.cornerRadius = 12.f;
        attributes.presentLayer = danmakuLayer;
        
    } else {
        UIView *danmakuView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTapGesture:)];
        danmakuView.backgroundColor = [UIColor blackColor];
        danmakuView.layer.cornerRadius = 12.f;
        [danmakuView addGestureRecognizer:tapGesture];
        attributes.presentView = danmakuView;
    }
    attributes.size = CGSizeMake((rand()%100)/100.f * 88.f + 22.f, 24.f);
    attributes.danmakuTime = 2.f;
    attributes.trackTime = 4.f + ((rand()%100)/100.f)*4.f;
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
        _danmakuPlayer.delegate = self;
    }
    return _danmakuPlayer;
}

- (void)danmakuPlayerDidTapAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    self.title = @"触发默认手势";
    NSLog(@"默认tap: %@", attributes);
}

- (void)customTapGesture:(UIGestureRecognizer *)tapGesture
{
    self.title = @"触发自定义手势";
    NSLog(@"自定义手势: %@",tapGesture);
}

@end
