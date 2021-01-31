//
//  LNDanmakuStableTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseStableTrackController.h"
#import "LNDanmakuStableTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuStableTrackController : LNDanmakuBaseStableTrackController

@property (nonatomic, strong, readonly) LNDanmakuStableTrack *stableTrack;

@end

NS_ASSUME_NONNULL_END
