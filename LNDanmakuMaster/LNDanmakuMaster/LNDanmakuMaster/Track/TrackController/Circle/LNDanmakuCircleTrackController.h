//
//  LNDanmakuCircleTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseMoveTrackController.h"
#import "LNDanmakuCircleTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuCircleTrackController : LNDanmakuBaseMoveTrackController

@property (nonatomic, strong, readonly) LNDanmakuCircleTrack *circleTrack;

@end

NS_ASSUME_NONNULL_END
