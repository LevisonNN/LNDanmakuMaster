//
//  LNDanmakuChristinaTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseMoveTrackController.h"
#import "LNDanmakuChristinaTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuChristinaTrackController : LNDanmakuBaseMoveTrackController

@property (nonatomic, strong, readonly) LNDanmakuChristinaTrack *christinaTrack;

@end

NS_ASSUME_NONNULL_END
