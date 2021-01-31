//
//  LNDanmakuPopTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseFreeTrackController.h"
#import "LNDanmakuPopTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuPopTrackController : LNDanmakuBaseFreeTrackController

@property (nonatomic, strong, readonly) LNDanmakuPopTrack *popTrack;

@end

NS_ASSUME_NONNULL_END
