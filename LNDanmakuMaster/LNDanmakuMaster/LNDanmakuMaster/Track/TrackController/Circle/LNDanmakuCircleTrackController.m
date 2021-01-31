//
//  LNDanmakuCircleTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuCircleTrackController.h"

@interface LNDanmakuCircleTrackController ()

@property (nonatomic, strong) LNDanmakuCircleTrack *circleTrack;

@end

@implementation LNDanmakuCircleTrackController

- (LNDanmakuAbstractTrack *)track
{
    return self.circleTrack;
}

- (LNDanmakuCircleTrack *)circleTrack
{
    if (!_circleTrack) {
        _circleTrack = [[LNDanmakuCircleTrack alloc] init];
    }
    return _circleTrack;
}

@end
