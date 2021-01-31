//
//  TracksDemoViewController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 这个Demo用来展示每种轨道的基础用法
 * 1.Horizontal轨道是最常见的从右向左播放的轨道，也是用途最多的一种。
 * 2.Stable轨道是定点展示轨道，类似B站那种从上向下一列的定点轨道。
 * 3.Pop轨道内嵌了一个Spring动画，这种弹性动画通过一个衰减正弦函数实现：
 *   y = e^(a*x) * sinx
 *   看起来就像一个弹簧在做有阻尼的简谐振动。
 * ——————————————————————————————————————————————以上三种是相对常用的三种轨道
 * 4.Circle轨道是一开始和Horizontal轨道一起开发，用于在开发过程中纠正那些容易向条形轨道倾斜的地方，使开发成果拓展性更强。
 * 5.Christina轨道为了佐证：在某些情况下，使用空间单位"速度"定义播放进度，没有使用"时间"通用性更强。
 *   如果你所定义的速度单位是pt/s，那么这个变量就无法定义角速度。
 * 6.Sin轨道最开始用于演示如何自定义一个移动轨道。
 * ——————————————————————————————————————————————
 * 后三种轨道为了表达LNDanmaku是一个支持大规模定制的弹幕框架，在使用时无需为未来可能出现的形式和样式担忧。
 * 7. 如果希望定制TrackController的播放逻辑，也可以定制LNDanmakuAbstractTrackController。
 * 事实上这是相对复杂的，因此提供了三种BaseTrackController供使用者继承从而适应各种场景。
 **/

typedef NS_ENUM(NSInteger, TracksDemoViewControllerType)
{
    TracksDemoViewControllerHorizontal = 0,
    TracksDemoViewControllerStable,
    TracksDemoViewControllerCircle,
    TracksDemoViewControllerChristina,
    TracksDemoViewControllerPop,
    TracksDemoViewControllerSin,
};

@interface TracksDemoViewController : UIViewController

- (instancetype)initWithType:(TracksDemoViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
