//
//  LNDanmakuPlayer.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuPlayer.h"
#import "LNDanmakuPool.h"

@interface LNDanmakuPlayer ()
<
LNDanmakuClockDelegate,
LNDanmakuContrainerViewDelegate,
LNDanmakuAbstractDispatcherDelegate,
LNDanmakuAbstractDispatcherSmoothGrainDataSource
>

@property (nonatomic, strong) LNDanmakuClock *clock;
@property (nonatomic, strong) LNDanmakuContainerView *containerView;
@property (nonatomic, strong) NSMutableArray<LNDanmakuAbstractTrackController *> *trackControllerMArr;
@property (nonatomic, strong) LNDanmakuDispatcher *dispatcher;

@property (nonatomic, strong) NSMutableArray <id<LNDanmakuClockDelegate>> *clockDelegateMArr;

@property (nonatomic, assign) LNDanmakuPlayerStatus status;

@property (nonatomic, strong) LNDanmakuPool *layerPool;
@property (nonatomic, strong) LNDanmakuPool *viewPool;

@property (nonatomic, strong) NSMutableArray <LNDanmakuTrackGroup *> *trackGroupMArr;
@property (nonatomic, strong) NSMutableSet <LNDanmakuAbstractTrackController *> *trackControllerNoRepeatMSet;

@property (nonatomic, assign) NSInteger maxSmoothGrainNum;
@property (nonatomic, assign) NSInteger restSmoothGrainNum;
 
@end

@implementation LNDanmakuPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.status = LNDanmakuPlayerStatusNone;
        [self.clockDelegateMArr addObject:self.dispatcher];
        self.maxSmoothGrainNum = 1;
    }
    return self;
}

- (void)recoverAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerWillRecoverAttributes:)]) {
        [self.delegate danmakuPlayerWillRecoverAttributes:attributes];
    }
    
    if (attributes.presentLayer) {
        [self.layerPool saveInstance:attributes.presentLayer];
        attributes.presentLayer = nil;
    }
    
    if (attributes.presentView) {
        [self.viewPool saveInstance:attributes.presentView];
        attributes.presentView = nil;
    }
}

#pragma -mark dispatcher delegate
- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher drop:(LNDanmakuAbstractAttributes *)attributes {
    if(self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidDropAttributes:from:)]) {
        [self.delegate danmakuPlayerDidDropAttributes:attributes from:dispatcher];
    }
    [self recoverAttributes:attributes];
}

- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher clear:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr {
    for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidClearAttributes:from:)]) {
            [self.delegate danmakuPlayerDidClearAttributes:attributes from:dispatcher];
        }
        [self recoverAttributes:attributes];
    }
}

- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
      willDispatch:(LNDanmakuAbstractAttributes *)attributes
                to:(LNDanmakuAbstractTrackController *)trackController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerWillDispatchAttributes:from:to:)]) {
        [self.delegate danmakuPlayerWillDispatchAttributes:attributes from:dispatcher to:trackController];
    }
}

- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
       didDispatch:(LNDanmakuAbstractAttributes *)attributes
                to:(LNDanmakuAbstractTrackController *)trackController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidDispatchAttributes:from:to:)]) {
        [self.delegate danmakuPlayerDidDispatchAttributes:attributes from:dispatcher to:trackController];
    }
}

#pragma -mark dispatcher grain delegate
- (NSInteger)restGrainNumForDispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
{
    return self.restSmoothGrainNum;
}

- (void)decreaseGrainNumForDispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
{
    if (self.restSmoothGrainNum > 0) {
        self.restSmoothGrainNum --;
    }
}

#pragma -mark container delegate

- (void)danmakuContainerViewDidLoadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidDisplayAttributes:)]) {
        [self.delegate danmakuPlayerDidDisplayAttributes:attributes];
    }
}

- (void)danmakuContainerViewDidUnloadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidEndDisplayAttributes:)]) {
        [self.delegate danmakuPlayerDidEndDisplayAttributes:attributes];
    }
    [self recoverAttributes:attributes];
}

- (void)danmakuContainerDidTappedAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidTapAttributes:)]) {
        [self.delegate danmakuPlayerDidTapAttributes:attributes];
    }
}

#pragma -mark clock delegate

- (void)danmakuClockUpdateTimeInterval:(NSTimeInterval)time
{
    if (self.status != LNDanmakuPlayerStatusPlay) {
        return;
    }
    
    self.restSmoothGrainNum = self.maxSmoothGrainNum;
    
    [self.trackControllerNoRepeatMSet removeAllObjects];
    
    if (self.dispatcher && [self.dispatcher respondsToSelector:@selector(danmakuClockUpdateTimeInterval:)]) {
        [self.dispatcher danmakuClockUpdateTimeInterval:time];
    }
    
    for (LNDanmakuAbstractTrackController *trackController in self.trackControllerMArr) {
        if ([self.trackControllerNoRepeatMSet containsObject:trackController]) {

        } else {
            [trackController update:time];
            [self.trackControllerNoRepeatMSet addObject:trackController];
        }
    }
    [self.dispatcher dispatchNewAttributesToFreeTracks:[NSArray arrayWithArray:self.trackControllerMArr]];
    
    [self trackGroupUpdateTimeInterval:time];
    
}

- (void)trackGroupUpdateTimeInterval:(NSTimeInterval)time
{
    for (LNDanmakuTrackGroup *trackGroup in self.trackGroupMArr) {
        if (trackGroup.dispatcher && [trackGroup.dispatcher respondsToSelector:@selector(danmakuClockUpdateTimeInterval:)]) {
            [trackGroup.dispatcher danmakuClockUpdateTimeInterval:time];
        }
        for (LNDanmakuAbstractTrackController *trackController in trackGroup.currentTrackControllers) {
            if ([self.trackControllerNoRepeatMSet containsObject:trackController]) {

            } else {
                [trackController update:time];
                [self.trackControllerNoRepeatMSet addObject:trackController];
            }
        }
        [trackGroup.dispatcher dispatchNewAttributesToFreeTracks:[NSArray arrayWithArray:trackGroup.currentTrackControllers]];
    }
}

- (LNDanmakuContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[LNDanmakuContainerView alloc] init];
        _containerView.delegate = self;
    }
    return _containerView;
}

- (LNDanmakuClock *)clock
{
    if (!_clock) {
        _clock = [[LNDanmakuClock alloc] init];
        _clock.delegate = self;
    }
    return _clock;
}

- (NSMutableArray<LNDanmakuAbstractTrackController *> *)trackControllerMArr
{
    if (!_trackControllerMArr) {
        _trackControllerMArr = [[NSMutableArray alloc] init];
    }
    return _trackControllerMArr;
}

- (LNDanmakuDispatcher *)dispatcher
{
    if (!_dispatcher) {
        _dispatcher = [[LNDanmakuDispatcher alloc] init];
        _dispatcher.delegate = self;
        _dispatcher.grainDataSource = self;
    }
    return _dispatcher;
}

- (LNDanmakuPool *)layerPool
{
    if (!_layerPool) {
        _layerPool = [[LNDanmakuPool alloc] init];
    }
    return _layerPool;
}

- (LNDanmakuPool *)viewPool
{
    if (!_viewPool) {
        _viewPool = [[LNDanmakuPool alloc] init];
    }
    return _viewPool;
}

@end


@implementation LNDanmakuPlayer (Track)

- (void)addTrack:(LNDanmakuAbstractTrackController *)trackController
{
    if (!trackController) {
        return;
    }
    [self.trackControllerMArr addObject:trackController];
    trackController.viewDelegate = self.containerView;
}

- (void)removeTrack:(LNDanmakuAbstractTrackController *)trackController
{
    if (trackController && [self.trackControllerMArr containsObject:trackController]) {
        [self.trackControllerMArr removeObject:trackController];
        if (trackController.viewDelegate == self.containerView) {
            trackController.viewDelegate = nil;
        }
    }
}

- (void)removeAllTracks
{
    [self.trackControllerMArr removeAllObjects];
}

@end

@implementation LNDanmakuPlayer (Data)

- (void)insertAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr
{
    [self insertAttributes:attributesArr toGroup:nil];
}

- (void)insertHighPriorityAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr
{
    [self insertHighPriorityAttributes:attributesArr toGroup:nil];
}

- (void)callDidInsertDelegate:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuPlayerDidInsertAttributes:to:)]) {
        for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
            [self.delegate danmakuPlayerDidInsertAttributes:attributes to:dispatcher];
        }
    }
}

- (void)registerLayer:(Class)class forKey:(NSString *)key
{
    if ([class isSubclassOfClass:[CALayer class]]) {
        [self.layerPool registerClass:class forKey:key];
    }
}

- (CALayer *)layerForKey:(NSString *)key
{
    return (CALayer *)[self.layerPool instanceForKey:key];
}

- (void)registerView:(Class)class forKey:(NSString *)key
{
    if ([class isSubclassOfClass:[UIView class]]) {
        [self.viewPool registerClass:class forKey:key];
    }
}

- (UIView *)viewForKey:(NSString *)key
{
    return (UIView *)[self.viewPool instanceForKey:key];
}

@end

@implementation LNDanmakuPlayer (Control)

- (void)start
{
    if (self.status == LNDanmakuPlayerStatusNone || self.status == LNDanmakuPlayerStatusStop) {
        self.status = LNDanmakuPlayerStatusPlay;
        [self.clock startOrResume];
    }
}

- (void)pause
{
    if (self.status == LNDanmakuPlayerStatusPlay) {
        self.status = LNDanmakuPlayerStatusPause;
    }
}

- (void)resume
{
    if (self.status == LNDanmakuPlayerStatusPause) {
        self.status = LNDanmakuPlayerStatusPlay;
    }
}

- (void)stop
{
    self.status = LNDanmakuPlayerStatusStop;
    [self.clock stop];
    [self clear];
}

- (void)clear
{
    [self clearQueue];
    [self clearScreen];
    [self clearPool];
}

- (void)clearQueue
{
    [self.dispatcher clear];
    for (LNDanmakuTrackGroup *trackGroup in self.trackGroupMArr) {
        [trackGroup.dispatcher clear];
    }
}

- (void)clearScreen
{
    for (LNDanmakuAbstractTrackController *trackController in self.trackControllerMArr) {
        [trackController clearTrack];
    }
    
    for (LNDanmakuTrackGroup *trackGroup in self.trackGroupMArr) {
        for (LNDanmakuAbstractTrackController *trackController in trackGroup.currentTrackControllers) {
            [trackController clearTrack];
        }
    }
}

- (void)clearPool
{
    [self.layerPool clearPool];
    [self.viewPool clearPool];
}

- (void)removeAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.dispatcher containsAttributes:attributes]) {
        [self.dispatcher removeAttributes:attributes];
    }
    
    for (LNDanmakuTrackGroup *trackGroup in self.trackGroupMArr) {
        if ([trackGroup.dispatcher containsAttributes:attributes]) {
            [trackGroup.dispatcher removeAttributes:attributes];
        }
    }
    
    for (LNDanmakuAbstractTrackController *trackController in self.trackControllerMArr) {
        if ([trackController containsAttributes:attributes]) {
            [trackController unloadAttributes:attributes];
        }
    }
    
    for (LNDanmakuTrackGroup *trackGroup in self.trackGroupMArr) {
        for (LNDanmakuAbstractTrackController *trackController in trackGroup.currentTrackControllers) {
            if ([trackController containsAttributes:attributes]) {
                [trackController unloadAttributes:attributes];
            }
        }
    }
}

@end

@implementation LNDanmakuPlayer(TrackGroup)

- (void)insertAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group
{
    if (self.status == LNDanmakuPlayerStatusPlay || self.status == LNDanmakuPlayerStatusPause) {
        if (group && [self.trackGroupMArr containsObject:group]) {
            [group.dispatcher insertNewAttributes:attributesArr];
            [self callDidInsertDelegate:attributesArr dispatcher:group.dispatcher];
        } else {
            [self.dispatcher insertNewAttributes:attributesArr];
            [self callDidInsertDelegate:attributesArr dispatcher:self.dispatcher];
        }
    } else {
        for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
            [self recoverAttributes:attributes];
        }
    }
}
- (void)insertHighPriorityAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group {
    if (self.status == LNDanmakuPlayerStatusPlay || self.status == LNDanmakuPlayerStatusPause) {
        if (group && [self.trackGroupMArr containsObject:group]) {
            [group.dispatcher insertHighPriorityAttributes:attributesArr];
            [self callDidInsertDelegate:attributesArr dispatcher:group.dispatcher];
        } else {
            [self.dispatcher insertHighPriorityAttributes:attributesArr];
            [self callDidInsertDelegate:attributesArr dispatcher:self.dispatcher];
        }
    } else {
        for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
            [self recoverAttributes:attributes];
        }
    }
}

- (void)addTrackGroup:(LNDanmakuTrackGroup *)trackGroup
{
    if (![self.trackGroupMArr containsObject:trackGroup]) {
        [self.trackGroupMArr addObject:trackGroup];
    }
    trackGroup.dispatcher.delegate = self;
    trackGroup.dispatcher.grainDataSource = self;
    
    for (LNDanmakuAbstractTrackController *trackController in trackGroup.currentTrackControllers) {
        trackController.viewDelegate = self.containerView;
    }
    if (trackGroup.dispatcher && (![self.clockDelegateMArr containsObject:trackGroup.dispatcher])) {
        [self.clockDelegateMArr addObject:trackGroup.dispatcher];
    }
}
- (void)removeTrackGroup:(LNDanmakuTrackGroup *)trackGroup
{
    if ([self.trackGroupMArr containsObject:trackGroup]) {
        [trackGroup clear];
        [self.trackGroupMArr removeObject:trackGroup];
    }
    if (trackGroup.dispatcher.delegate == self) {
        trackGroup.dispatcher.delegate = nil;
    }
    if (trackGroup.dispatcher.grainDataSource == self) {
        trackGroup.dispatcher.grainDataSource = nil;
    }
    for (LNDanmakuAbstractTrackController *trackController in trackGroup.currentTrackControllers) {
        if (trackController.viewDelegate == self.containerView) {
            trackController.viewDelegate = nil;
        }
    }
    if (trackGroup.dispatcher && ([self.clockDelegateMArr containsObject:trackGroup.dispatcher])) {
        [self.clockDelegateMArr removeObject:trackGroup.dispatcher];
    }
}

- (NSMutableArray<LNDanmakuTrackGroup *> *)trackGroupMArr
{
    if (!_trackGroupMArr) {
        _trackGroupMArr = [[NSMutableArray alloc] init];
    }
    return _trackGroupMArr;
}

- (NSArray<LNDanmakuTrackGroup *> *)currentTrackGroups
{
    return [NSArray arrayWithArray:self.trackGroupMArr];
}

- (NSMutableSet<LNDanmakuAbstractTrackController *> *)trackControllerNoRepeatMSet
{
    if (!_trackControllerNoRepeatMSet) {
        _trackControllerNoRepeatMSet = [[NSMutableSet alloc] init];
    }
    return _trackControllerNoRepeatMSet;
}

@end

@implementation LNDanmakuPlayer (Recover)

- (void)recoverLoadAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr
{
    [self recoverLoadAttributes:attributesArr toGroup:nil];
}

- (void)recoverLoadAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr toGroup:(LNDanmakuTrackGroup *_Nullable)group
{
    if (group) {
        [group.dispatcher recoverInsertAttributes:attributesArr toTrackControllers:group.currentTrackControllers];
    } else {
        [self.dispatcher recoverInsertAttributes:attributesArr toTrackControllers:[NSArray arrayWithArray:self.trackControllerMArr]];
    }
}

@end
