//
//  LNDanmakuTrackGroup.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractDispatcher.h"
#import "LNDanmakuAbstractTrackController.h"


NS_ASSUME_NONNULL_BEGIN

/*
 * A track group contains one dispatcher and several track controllers.
 * They form the smallest unit that can work independently.
 * You insert attributes into track groups instead of player, so that they can work on specific tracks with specific strategies.
 * Different track groups can share tracks with each other or player.
 **/

@interface LNDanmakuTrackGroup : NSObject

@property (nonatomic, strong, readonly) LNDanmakuAbstractDispatcher *dispatcher;

@property (nonatomic, copy, readonly) NSArray<LNDanmakuAbstractTrackController *> *currentTrackControllers;
- (void)addTrack:(LNDanmakuAbstractTrackController *)trackController;
- (void)removeTrack:(LNDanmakuAbstractTrackController *)trackController;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
