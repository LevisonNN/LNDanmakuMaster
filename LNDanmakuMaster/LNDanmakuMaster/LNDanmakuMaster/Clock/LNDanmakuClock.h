//
//  LNDanmakuClock.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * Clock is used as an engine for every DanmakuPlayer.
 * Common video maybe 24 FPS, danmaku player needs 60FPS to keep fluency.
 * Danmakus will keep moving even if video player stopped. So we should not use video-player's callback to drive danmaku player.
 * Clock encapsulates CADisplayLink and provides easy interfaces for use.
 **/

/*
 * LNDanmakuClock provides interval between last callback and current callback for trackController/dispatcher to control the progress.
 * This little piece of time was called "elapsingTime".
 **/

@protocol LNDanmakuClockDelegate <NSObject>

- (void)danmakuClockUpdateTimeInterval:(NSTimeInterval)time;

@end

@interface LNDanmakuClock : NSObject

@property (nonatomic, assign, readonly) BOOL isPaused;
@property (nonatomic, weak) id <LNDanmakuClockDelegate> delegate;

- (void)startOrResume;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
