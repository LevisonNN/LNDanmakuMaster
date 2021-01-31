//
//  LNDanmakuCircleTrack.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuCircleTrack : LNDanmakuAbstractTrack

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

@end

NS_ASSUME_NONNULL_END
