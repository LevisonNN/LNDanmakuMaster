//
//  LNDanmakuHorizontalMoveTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuHorizontalMoveTrackController.h"

@interface LNDanmakuHorizontalMoveTrackController ()

@property (nonatomic, strong) LNDanmakuHorizontalMoveTrack *horizontalTrack;

@end

@implementation LNDanmakuHorizontalMoveTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (LNDanmakuAbstractTrack *)track
{
    return self.horizontalTrack;
}

- (LNDanmakuHorizontalMoveTrack *)horizontalTrack
{
    if (!_horizontalTrack) {
        _horizontalTrack = [[LNDanmakuHorizontalMoveTrack alloc] init];
    }
    return _horizontalTrack;
}

@end
