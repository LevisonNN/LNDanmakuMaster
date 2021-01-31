//
//  LNDanmakuSinTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseMoveTrackController.h"
#import "LNDanmakuSinTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuSinTrackController : LNDanmakuBaseMoveTrackController

@property (nonatomic, strong, readonly) LNDanmakuSinTrack *sinTrack;

@end

NS_ASSUME_NONNULL_END
