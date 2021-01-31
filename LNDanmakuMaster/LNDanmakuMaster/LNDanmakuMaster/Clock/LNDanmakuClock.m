//
//  LNDanmakuClock.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuClock.h"
#import "LNDanmakuClockProxy.h"
#import <QuartzCore/QuartzCore.h>

@interface LNDanmakuClock ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CFTimeInterval realWorldTime;

@property (nonatomic, assign) CGFloat speedScale;

@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, assign) NSTimeInterval allTime;

@end

@implementation LNDanmakuClock

- (instancetype)init
{
    self = [super init];
    if (self) {
        _realWorldTime = CACurrentMediaTime();
        _speedScale = 1.f;
        _isPaused = YES;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)resetClock
{
    [self stop];
    self.realWorldTime = CACurrentMediaTime();
    self.speedScale = 1.f;
    self.isPaused = NO;
    _displayLink = [CADisplayLink displayLinkWithTarget:[LNDanmakuClockProxy proxyWithTarget:self] selector:@selector(callback)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)callback
{
    CFTimeInterval newRealWorldTime = CACurrentMediaTime();
    if ((!self.isPaused) &&
        self.delegate &&
        [self.delegate respondsToSelector:@selector(danmakuClockUpdateTimeInterval:)]) {
        
        [self.delegate danmakuClockUpdateTimeInterval:newRealWorldTime - self.realWorldTime];
    } else {
        NSAssert(YES, @"LNDanmakuClock is iding");
    }
    
    self.realWorldTime = newRealWorldTime;
}

- (void)startOrResume
{
    if (!_displayLink) {
        [self resetClock];
    }
    if (self.isPaused) {
        self.isPaused = NO;
    }
}

- (void)pause
{
    self.isPaused = YES;
}

- (void)stop
{
    self.isPaused = YES;
    [_displayLink invalidate];
    _displayLink = nil;
}

@end
