//
//  LNDanmakuTrackGroup.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuTrackGroup.h"
#import "LNDanmakuDispatcher.h"

@interface LNDanmakuTrackGroup ()

@property (nonatomic, strong) LNDanmakuDispatcher *dispatcher;

@property (nonatomic, strong) NSMutableArray <LNDanmakuAbstractTrackController *> *trackControllerMArr;

@end

@implementation LNDanmakuTrackGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addTrack:(LNDanmakuAbstractTrackController *)trackController
{
    if ([trackController isKindOfClass:[LNDanmakuAbstractTrackController class]] && (![self.trackControllerMArr containsObject:trackController])) {
        [self.trackControllerMArr addObject:trackController];
    }
}
- (void)removeTrack:(LNDanmakuAbstractTrackController *)trackController
{
    if ([self.trackControllerMArr containsObject:trackController]) {
        [self.trackControllerMArr removeObject:trackController];
    }
}

- (void)clear
{
    [self.dispatcher clear];
    for (LNDanmakuAbstractTrackController *trackController in self.trackControllerMArr) {
        [trackController clearTrack];
    }
}

- (NSArray<LNDanmakuAbstractTrackController *> *)currentTrackControllers
{
    return [NSArray arrayWithArray:self.trackControllerMArr];
}

- (NSMutableArray<LNDanmakuAbstractTrackController *> *)trackControllerMArr
{
    if (!_trackControllerMArr) {
        _trackControllerMArr = [[NSMutableArray alloc] init];
    }
    return _trackControllerMArr;
}

- (LNDanmakuAbstractDispatcher *)dispatcher
{
    if (!_dispatcher) {
        _dispatcher = [[LNDanmakuDispatcher alloc] init];
    }
    return _dispatcher;
}

@end

