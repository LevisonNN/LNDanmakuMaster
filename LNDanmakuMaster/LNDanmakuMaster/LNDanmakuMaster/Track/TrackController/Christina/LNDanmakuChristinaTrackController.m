//
//  LNDanmakuChristinaTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuChristinaTrackController.h"

@interface LNDanmakuChristinaTrackController ()

@property (nonatomic, strong) LNDanmakuChristinaTrack *christinaTrack;

@end

@implementation LNDanmakuChristinaTrackController

- (LNDanmakuAbstractTrack *)track
{
    return self.christinaTrack;
}

- (LNDanmakuChristinaTrack *)christinaTrack
{
    if (!_christinaTrack) {
        _christinaTrack = [[LNDanmakuChristinaTrack alloc] init];
    }
    return _christinaTrack;
}

@end
