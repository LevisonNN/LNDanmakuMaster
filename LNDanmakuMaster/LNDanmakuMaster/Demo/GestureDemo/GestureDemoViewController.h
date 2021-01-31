//
//  GestureDemoViewController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 这个Demo用来演示如何同时让弹幕框架默认的手势和用户自定义的手势同时生效.
 * CALayer:如果使用CALayer系列视图来承载弹幕，那么只能使用LNDanmaku自带的唯一一个Tap手势。
 * 通常情况下弹幕更注重"看"而非"点"，因此通用的tap手势能满足大部分业务场景
 * UIView:如果不得不使用自定义手势，那么你需要使用自己的UIView并添加自定义手势。
 * 当然，如果你UIView没有添加自定义手势，LNDanmaku的点击手势也能识别它。
 * LNDanmaku不会阻拦任何用户的自定义手势，即便它们与本身的Gesture冲突，也会优先响应自定义手势。
 **/

/*
 * 那些黑色的弹幕使用UIView和自定义手势
 * 其他颜色的弹幕是用默认的手势
 **/

@interface GestureDemoViewController : UIViewController

@end
NS_ASSUME_NONNULL_END
