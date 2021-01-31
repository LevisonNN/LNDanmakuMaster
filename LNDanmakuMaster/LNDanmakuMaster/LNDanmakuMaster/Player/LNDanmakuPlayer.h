//
//  LNDanmakuPlayer.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractDispatcher.h"
#import "LNDanmakuContainerView.h"
#import "LNDanmakuTrackGroup.h"
#import "LNDanmakuDispatcher.h"


NS_ASSUME_NONNULL_BEGIN

/*
 * The player combines and packages dispatcher、container、track controller、clock.
 **/

typedef NS_ENUM(NSUInteger, LNDanmakuPlayerStatus) {
    LNDanmakuPlayerStatusNone = 0, //Just initialized.
    LNDanmakuPlayerStatusPlay = 1, //Playing.
    LNDanmakuPlayerStatusStop = 2, //Terminated,
    LNDanmakuPlayerStatusPause = 3, //Paused.
};

@protocol LNDanmakuPlayerDelegate <NSObject>

@optional
//Queue life circle.
- (void)danmakuPlayerDidInsertAttributes:(LNDanmakuAbstractAttributes *)attributes to:(LNDanmakuAbstractDispatcher *)dispatcher;
- (void)danmakuPlayerDidDropAttributes:(LNDanmakuAbstractAttributes *)attributes from:(LNDanmakuAbstractDispatcher *)dispatcher;
- (void)danmakuPlayerDidClearAttributes:(LNDanmakuAbstractAttributes *)attributes from:(LNDanmakuAbstractDispatcher *)dispatcher;
- (void)danmakuPlayerWillDispatchAttributes:(LNDanmakuAbstractAttributes *)attributes
                                       from:(LNDanmakuAbstractDispatcher *)dispatcher
                                         to:(LNDanmakuAbstractTrackController *)trackController;
- (void)danmakuPlayerDidDispatchAttributes:(LNDanmakuAbstractAttributes *)attributes
                                      from:(LNDanmakuAbstractDispatcher *)dispatcher
                                        to:(LNDanmakuAbstractTrackController *)trackController;
//Track life circle.
- (void)danmakuPlayerDidDisplayAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)danmakuPlayerDidEndDisplayAttributes:(LNDanmakuAbstractAttributes *)attributes;

//Will be put into pool.
- (void)danmakuPlayerWillRecoverAttributes:(LNDanmakuAbstractAttributes *)attributes;

//Was tapped.
- (void)danmakuPlayerDidTapAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end

@interface LNDanmakuPlayer : NSObject

@property (nonatomic, weak) id <LNDanmakuPlayerDelegate> delegate;

//@property (nonatomic, strong, readonly) LNDanmakuClock *clock;
@property (nonatomic, strong, readonly) LNDanmakuContainerView *containerView;
//@property (nonatomic, strong, readonly) NSMutableArray<LNDanmakuAbstractTrackController *> *trackControllerMArr;
@property (nonatomic, strong, readonly) LNDanmakuDispatcher *dispatcher;

@property (nonatomic, assign, readonly) LNDanmakuPlayerStatus status;

@end

@interface LNDanmakuPlayer (Track)

- (void)addTrack:(LNDanmakuAbstractTrackController *)trackController;

- (void)removeTrack:(LNDanmakuAbstractTrackController *)trackController;

- (void)removeAllTracks;

@end


@interface LNDanmakuPlayer (Data)

- (void)insertAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr;
- (void)insertHighPriorityAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr;

- (void)registerLayer:(Class)class forKey:(NSString *)key;
- (CALayer *)layerForKey:(NSString *)key;

- (void)registerView:(Class)class forKey:(NSString *)key;
- (UIView *)viewForKey:(NSString *)key;

@end


@interface LNDanmakuPlayer (Control)

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

//Clear all.
- (void)clear;
//Clear queue.
- (void)clearQueue;
//Clear screen/containerView.
- (void)clearScreen;
//Clear pool.
- (void)clearPool;

- (void)removeAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end

@interface LNDanmakuPlayer (TrackGroup)

//@property (nonatomic, copy, readonly) NSArray <LNDanmakuTrackGroup *> *currentTrackGroups;

- (void)addTrackGroup:(LNDanmakuTrackGroup *)trackGroup;
- (void)removeTrackGroup:(LNDanmakuTrackGroup *)trackGroup;

- (void)insertAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group;
- (void)insertHighPriorityAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group;


@end

@interface LNDanmakuPlayer (Recover)

- (void)recoverLoadAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr;
- (void)recoverLoadAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group;

@end



NS_ASSUME_NONNULL_END
