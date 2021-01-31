//
//  LNDanmakuAbstractTrackController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractAttributes.h"
#import "LNDanmakuAbstractTrack.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * Open current playing count.
 **/
#define isNeedDanmakuCountDanmakuNumber NO

/*
 * Actually, it's not easy to define a trackController.
 * So we provide baseTrackControllers.
 * User can use subclasses of baseTrackControllers and return different tracks to customize.
 **/

@protocol LNDanmakuTrackControllerViewDelegate <NSObject>

@required
- (void)viewShouldLoadAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)viewShouldRemoveAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end

@interface LNDanmakuAbstractTrackController : NSObject

@property (nonatomic, strong, readonly) LNDanmakuAbstractTrack *track;

@property (nonatomic, weak) id <LNDanmakuTrackControllerViewDelegate> viewDelegate;

@end

@interface LNDanmakuAbstractTrackController (Override)

- (void)update:(NSTimeInterval)elapsingTime;
- (void)clearTrack;
- (BOOL)isFree;
//Give some time for trackController to finish current danmakus.
- (NSTimeInterval)estimatedFinishTimeForCurrentAttributes;
//In some cases, danmaku will not be displayed after it was dispatched to one trackController immediately.
- (NSTimeInterval)estimatedMinDisplayWaitTimeFor:(LNDanmakuAbstractAttributes *)attributes;

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)loadAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)unloadAttributes:(LNDanmakuAbstractAttributes *)attributes;
 
@end

@interface LNDanmakuAbstractTrackController (Recover)

// If danmakuA was delay because danmakuB(pre-danmaku), this function gives a max-currentAliveTime so that danmakuA can just follow danmakuB.
- (NSTimeInterval)estimatedMaxAliveTimeFor:(LNDanmakuAbstractAttributes *)attributes;
- (void)recoverLoadAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end

NS_ASSUME_NONNULL_END
