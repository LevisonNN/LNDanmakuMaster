//
//  TrackGroupDemoViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "TrackGroupDemoViewController.h"
#import "LNDanmakuMaster.h"

@interface TrackGroupDemoViewController ()

@property (nonatomic, strong) LNDanmakuPlayer* danmakuPlayer;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) LNDanmakuTrackGroup *redGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *orangeGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *yellowGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *greenGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *cyanGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *blueGroup;
@property (nonatomic, strong) LNDanmakuTrackGroup *purpleGroup;

@end

@implementation TrackGroupDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayer];
    [self addSubviews];
    [self addConstraints];
    
    _timer = [NSTimer timerWithTimeInterval:0.032f target:self selector:@selector(addRandomDanmaku) userInfo:nil repeats:YES];
    
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
    LNDanmakuLayer *danmakuLayer = [[LNDanmakuLayer alloc] init];
    
    danmakuLayer.cornerRadius = 12.f;
    attributes.presentLayer = danmakuLayer;

    attributes.size = CGSizeMake(44.f, 24.f);
    attributes.trackTime = 4.f + ((rand()%100)/100.f)*4.f;
    attributes.danmakuTime = (attributes.size.width/self.view.bounds.size.width) * attributes.trackTime;
    
    switch (random()%7) {
        case 0: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:255.f/255.f green:0.f blue:0.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.redGroup];
        } break;
        case 1: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:255.f/255.f green:165.f/255.f blue:0.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.orangeGroup];
        } break;
        case 2: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:0.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.yellowGroup];
        } break;
        case 3: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:0.f/255.f green:255.f/255.f blue:0.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.greenGroup];
        } break;
        case 4: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:0.f/255.f green:127.f/255.f blue:255.f/255.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.blueGroup];
        } break;
        case 5: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:255.f/255.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.cyanGroup];
        } break;
        case 6: {
            danmakuLayer.backgroundColor = [UIColor colorWithRed:139.f/255.f green:0.f/255.f blue:255.f/255.f alpha:0.5f].CGColor;
            [self.danmakuPlayer insertAttributes:@[attributes] toGroup:self.purpleGroup];
        } break;
        default:
            break;
    }
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
    NSInteger times = 2;
    for (int i = 0; i < 13 * times; i++) {
        LNDanmakuSinTrackController *sinTrackController = [[LNDanmakuSinTrackController alloc] init];
        sinTrackController.sinTrack.startPosition = CGPointMake(0, i*10.f + 100.f);
        sinTrackController.sinTrack.width = self.view.frame.size.width;
        sinTrackController.sinTrack.A = 80.f;
        sinTrackController.sinTrack.T = 1.f;
        sinTrackController.spaceTimeInterval = 0.f;
        if (i < 1 * times) {
            [self.redGroup addTrack:sinTrackController];
        } else if (i < 2 * times) {
            [self.redGroup addTrack:sinTrackController];
            [self.orangeGroup addTrack:sinTrackController];
        } else if (i < 3 * times) {
            [self.orangeGroup addTrack:sinTrackController];
        } else if (i < 4 * times) {
            [self.orangeGroup addTrack:sinTrackController];
            [self.yellowGroup addTrack:sinTrackController];
        } else if (i < 5 * times) {
            [self.yellowGroup addTrack:sinTrackController];
        } else if (i < 6 * times) {
            [self.yellowGroup addTrack:sinTrackController];
            [self.greenGroup addTrack:sinTrackController];
        } else if (i < 7 * times) {
            [self.greenGroup addTrack:sinTrackController];
        } else if (i < 8 * times) {
            [self.greenGroup addTrack:sinTrackController];
            [self.cyanGroup addTrack:sinTrackController];
        } else if (i < 9 * times) {
            [self.cyanGroup addTrack:sinTrackController];
        } else if (i < 10 * times) {
            [self.cyanGroup addTrack:sinTrackController];
            [self.blueGroup addTrack:sinTrackController];
        } else if (i < 11 * times) {
            [self.blueGroup addTrack:sinTrackController];
        } else if (i < 12 * times) {
            [self.blueGroup addTrack:sinTrackController];
            [self.purpleGroup addTrack:sinTrackController];
        } else {
            [self.purpleGroup addTrack:sinTrackController];
        }
    }
    
    [self.danmakuPlayer addTrackGroup:self.redGroup];
    [self.danmakuPlayer addTrackGroup:self.orangeGroup];
    [self.danmakuPlayer addTrackGroup:self.yellowGroup];
    [self.danmakuPlayer addTrackGroup:self.greenGroup];
    [self.danmakuPlayer addTrackGroup:self.cyanGroup];
    [self.danmakuPlayer addTrackGroup:self.blueGroup];
    [self.danmakuPlayer addTrackGroup:self.purpleGroup];
    
    [self.danmakuPlayer start];
}

- (LNDanmakuPlayer *)danmakuPlayer
{
    if (!_danmakuPlayer) {
        _danmakuPlayer = [[LNDanmakuPlayer alloc] init];
    }
    return _danmakuPlayer;
}

- (LNDanmakuTrackGroup *)redGroup
{
    if (!_redGroup) {
        _redGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _redGroup;
}

- (LNDanmakuTrackGroup *)orangeGroup
{
    if (!_orangeGroup) {
        _orangeGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _orangeGroup;
}


- (LNDanmakuTrackGroup *)yellowGroup
{
    if (!_yellowGroup) {
        _yellowGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _yellowGroup;
}

- (LNDanmakuTrackGroup *)greenGroup
{
    if (!_greenGroup) {
        _greenGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _greenGroup;
}

- (LNDanmakuTrackGroup *)blueGroup
{
    if (!_blueGroup) {
        _blueGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _blueGroup;
}

- (LNDanmakuTrackGroup *)cyanGroup
{
    if (!_cyanGroup) {
        _cyanGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _cyanGroup;
}

- (LNDanmakuTrackGroup *)purpleGroup
{
    if (!_purpleGroup) {
        _purpleGroup = [[LNDanmakuTrackGroup alloc] init];
    }
    return _purpleGroup;
}
@end

