//
//  LNDanmakuSinTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuSinTrackController.h"

@interface LNDanmakuSinTrackController ()

@property (nonatomic, strong) LNDanmakuSinTrack *sinTrack;

@end

@implementation LNDanmakuSinTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (LNDanmakuAbstractTrack *)track
{
    return self.sinTrack;
}

- (LNDanmakuSinTrack *)sinTrack
{
    if (!_sinTrack) {
        _sinTrack = [[LNDanmakuSinTrack alloc] init];
    }
    return _sinTrack;
}

@end
