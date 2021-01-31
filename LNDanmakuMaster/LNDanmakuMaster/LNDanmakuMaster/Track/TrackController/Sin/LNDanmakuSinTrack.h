//
//  LNDanmakuSinTrack.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuSinTrack : LNDanmakuAbstractTrack

@property (nonatomic, assign) CGPoint startPosition;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat A;

@property (nonatomic, assign) CGFloat T;//percent

@end

NS_ASSUME_NONNULL_END
