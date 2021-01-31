//
//  VideoPlayer.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 假设这就是一个视频播放器! (⊙_⊙)
 **/

/*
 * 视频的弹幕信息通常是这样下发的：
 * a. 通常的音视频流会有三种类型数据：视频、音频、字幕，专业搞弹幕业务的团队可能会将弹幕信息融入到直播流或是视频文件中。
 * 这涉及到流媒体的一些技术，一般不是专门做弹幕业务的公司不会这样做，三方音视频播放器通常也没有内嵌弹幕功能，所以我谨慎地推测大部分情况应该是采用下面这种方法。
 * b. 根据播放进度分片请求弹幕数据，这种相对第一种显得不是很优雅，但只要能够对准弹幕和视频的播放时间点，体验差别其实不是很大。
 *
 * 我并没有搞到音视频流，只是大致模仿一下采用分片请求弹幕数据的方法，提出了一种这样实现的思路。
 * 不论哪种拉弹幕数据的方式，只要能保证播放器播放时能够及时取到弹幕数据，用户体验其实差别不大。
 **/

/*
 * 保证弹幕和视频同步的核心：
 * 1.根据弹幕数量、轨道数量设置一个合理的队列(之前说的B队列)长度。
 * 队列越长实时性越差，但容错率更高；反之实时性更强，容错率更低；所以应该尝试在一个可接受的延时内选择最长长度。
 * 2.根据我调研的一些主流的视频App，目前能够做到在seek时弹幕瞬间恢复弹幕的只有B站的App(就是因为这个我感觉他应该是用a那种方法实现的)。
 * 腾讯视频和其他的一些App通常是seek后弹幕再从右侧重新播放出来。
 * 我们采用b方法虽然达不到a那种理想的效果，但LNDanmaku提供了弹幕恢复接口，使用这些方法可以实现seek到某个时间点后，该时间点附近的弹幕瞬间恢复。
 * 弹幕恢复在弹幕稀疏时与a方法结果是一致的，因为稀疏的几个弹幕不会因为追赶或者抛弃问题影响后面的弹幕。
 * 在拥塞时，恢复机制和队列本身的抛弃机制都会稍微影响恢复结果，但总能保证最优先考虑距离seek时间点最近的弹幕。
 * 由于弹幕本身只是一种烘托氛围的工具，所以只要能保证seek后也是满屏的弹幕，看着热闹就行了。(p≧w≦q)
 **/

@interface VideoModel : NSObject

@property (nonatomic, assign) NSTimeInterval totalTime;

//no use
@property (nonatomic, copy) NSString *url;

@end

typedef NS_ENUM(NSInteger, VideoPlayerStatus) {
    VideoPlayerStatusNone, //刚初始化
    //VideoPlayerStatusPreparing,
    VideoPlayerStatusPlaying,
    //VideoPlayerStatusLoading,
    VideoPlayerStatusPaused,
    VideoPlayerStatusStopped,
};

@protocol VideoPlayerDelegate <NSObject>

@optional
- (void)videoPlayerDidLoadModel:(VideoModel *)videoModel;
- (void)videoPlayerProgress:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
- (void)videoPlayerStatusDidChangeFrom:(VideoPlayerStatus)originStatus to:(VideoPlayerStatus)targetStatus;

@end


@interface VideoPlayer : NSObject

@property (nonatomic, weak) NSObject <VideoPlayerDelegate> *delegate;

@property (nonatomic, strong, readonly) UIView *playerView;

@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, assign, readonly) VideoPlayerStatus status;

- (instancetype)initWithVideoModel:(VideoModel *)videoModel;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

- (void)seek:(NSTimeInterval)targetTime;

@end

NS_ASSUME_NONNULL_END
