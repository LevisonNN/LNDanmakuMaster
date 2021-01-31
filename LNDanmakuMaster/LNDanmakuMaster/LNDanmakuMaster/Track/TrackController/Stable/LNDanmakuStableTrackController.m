//
//  LNDanmakuStableTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuStableTrackController.h"

@interface LNDanmakuStableTrackController ()

@property (nonatomic, strong) LNDanmakuStableTrack *stableTrack;

@end

@implementation LNDanmakuStableTrackController

- (LNDanmakuAbstractTrack *)track
{
    return self.stableTrack;
}

- (LNDanmakuStableTrack *)stableTrack
{
    if (!_stableTrack) {
        _stableTrack = [[LNDanmakuStableTrack alloc] init];
    }
    return _stableTrack;
}

@end
