//
//  LNDanmakuHorizontalMoveTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseMoveTrackController.h"
#import "LNDanmakuHorizontalMoveTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuHorizontalMoveTrackController : LNDanmakuBaseMoveTrackController

@property (nonatomic, strong, readonly) LNDanmakuHorizontalMoveTrack *horizontalTrack;

@end

NS_ASSUME_NONNULL_END
