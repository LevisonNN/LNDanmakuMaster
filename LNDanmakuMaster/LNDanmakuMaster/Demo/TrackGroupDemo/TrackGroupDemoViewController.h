//
//  TrackGroupDemoViewController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 这个Demo用来展示如何使用TrackGroup对弹幕进行分轨
 * TrackGroup是由LNDanmaku中实现播放的基本组件(TrackController+Dispatcher)组成的最小播放逻辑单元。
 * Dispatcher类似一个工头，TrackController类似一个工人。
 * 一个工头可以管理多个工人，同时一个工人也可以被不同的工头管理。
 * TrackGroup主要被设计来克服条件弹幕的播放问题。
 * 例如：某些送较大型礼物的弹幕通常会被放在屏幕最顶端的1~2个轨道上，而不能被放在其他轨道上。
 * 在这种情况下，可以利用TrackGroup将顶端的两个轨道放在一个分组中，而这两个轨道在正常情况下也会被普通轨道占用着。
 * QA:那么如何保证送礼物的弹幕具有更高的优先级？
 * TrackGroup内置的Dispatcher会有一个高优队列，这个高优队列通常用来插入用户自己发送的弹幕或者其他优先级较高的弹幕。
 **/

/*
 * rainbow! (*^▽^*)
 **/

@interface TrackGroupDemoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
