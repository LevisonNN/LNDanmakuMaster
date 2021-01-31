//
//  LNDanmakuContainerView.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNDanmakuAbstractAttributes.h"
#import "LNDanmakuAbstractTrackController.h"


NS_ASSUME_NONNULL_BEGIN

@protocol  LNDanmakuContrainerViewDelegate <NSObject>

@optional
- (void)danmakuContainerViewDidLoadAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)danmakuContainerViewDidUnloadAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)danmakuContainerDidTappedAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end


/*
 * ContainerView helps user to deal with some simple tap gesture when using CALayers.
 * In most of time, user will not touch danmuku but just watch, so is not worthy to create tap-gesture for each danmaku.
 * ContainerView hold one tap-gesture instead of 100 tap-gesture, and decide which attributes to react dynamically.
 **/

/*
 * What's more, containerView will also be delegate of track-controllers, and responsible for  add/remove danmaku-views/layers.
 **/


@interface LNDanmakuContainerView : UIView <LNDanmakuTrackControllerViewDelegate>

@property (nonatomic, weak) id <LNDanmakuContrainerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
