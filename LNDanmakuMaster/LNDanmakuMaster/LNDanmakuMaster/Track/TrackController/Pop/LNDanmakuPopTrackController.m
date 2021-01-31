//
//  LNDanmakuPopTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuPopTrackController.h"

@interface LNDanmakuPopTrackController ()

@property (nonatomic, strong) LNDanmakuPopTrack *popTrack;

@end

@implementation LNDanmakuPopTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (LNDanmakuAbstractTrack *)track
{
    return self.popTrack;
}

- (LNDanmakuPopTrack *)popTrack
{
    if (!_popTrack) {
        _popTrack = [[LNDanmakuPopTrack alloc] init];
    }
    return _popTrack;
}

@end
