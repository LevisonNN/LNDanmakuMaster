# LNDanmakuMaster

#### LNDanmakuMaster是一个轻量的弹幕播放器，通过：创建播放器->创建轨道->添加弹幕的方式进行弹幕播放，提供丰富轨道样式的同时也支持自定义轨道；对传入的弹幕的视图层没有要求(任意的View/Layer)；提供多种（目前是3）弹幕分布策略；支持使用轨道组播放特殊弹幕；提供与分布策略的对应的弹幕seek策略。
#### 简书链接:[LNDanmakuMaster](https://www.jianshu.com/p/4a5448dd4a60)

* 你可以直接下载这个链接并运行上面丰富的Demo，或参考Demo代码实现自己的弹幕播放器，也可以直接使用Cocoapods👇

### Cocoapods

```
pod 'LNDanmakuMaster'
```

### 子文档

[0.iOS端弹幕相关调研](https://www.jianshu.com/p/719573470ffb)

[1.从一个弹幕开始：LNDanmakuAttributes](https://www.jianshu.com/p/7177086eaf79)

[2.动画的核心：LNDanmakuTrackController](https://www.jianshu.com/p/6280c3270762)

[3.暂存和分发：LNDanmakuDispatcher](https://www.jianshu.com/p/d7b534cb2dda)

[4.弹幕复用：LNDanmakuPool](https://www.jianshu.com/p/182b198efc69)

[5.弹幕容器和手势：LNDanmakuContainerView](https://www.jianshu.com/p/f23708dc2df2)

### 弹幕机制

1. 驱动机制

视频播放器的刷新率通常为29frame/s,弹幕播放器采用同样的刷新频率会有卡顿感，因此弹幕播放器通常使用自己的刷新驱动，要么是UIView animation，要么是CADisplayLink；CADisplaylink支持更多的细节、进度控制，因此这里我们选用的是CADisplayLink。
LNDanmakuClock是这样一个驱动，封装了CADisplayLink，增加了一些暂停、销毁的控制方法，这个时钟每次的输出就是从上一次DisplayLink回调到这次displayLink回调的一小段时间。

2. 进度控制机制

LNDanmakuMaster整体采用时间定义进度，这也是它与其他弹幕框架的主要区别之一，我们的所有进度控制、追赶控制、繁忙度控制，都是使用时间计算的。
使用时间变量替代空间变量的优势包括：
* 如果你的轨道路线并非直线：如果你希望一个弹幕既可以在水平轨道播放也可以在圆形轨道播放，既要给出角速度，也要给出线速度，如果使用时间单位，只需要给出运行的总时间。
* 如果你先控制一个曲线轨道两条弹幕之间的间距，空间间距需要计算曲线的长度，而对时间间距来说处理起来就和直线一样。
* 在做一些判断时，如果使用空间条件做判断，则需要进行速度、时间相关大量乘除法运算，使用时间可能只需要加减法，虽然我不知道具体是否有优势，但直观上感觉乘除法是没有加减法快的。
* 如果是像B站那种中间出现一列的弹幕，它不需要速度，只需要显示的时间就够了。
总之，使用时间体系替代速度体系，是能统一多种轨道进度控制的一个好方法。

3. 刷新机制

根据Clock的输出，我们可以得到一个稳定的回调得知刚刚经过了多长一段时间，那么弹幕的刷新过程就成为：在弹幕的剩余存活时间中扣除刚刚经过的那段时间，并根据扣除后的剩余时间占总时间的百分比来刷新弹幕的位置、大小等信息。
经过以上三个主要机制的介绍，已经有了实现一个弹幕框架的所有主要逻辑，剩下的就是一些模块的细分和细节上的雕琢。

### 模块分工

LNDanmakuMaster将整个弹幕框架分成以下几个部分(Abstract代表支持重写定制)：

| 模块名称 | 类名 | 备注 |
| ------ | ------ | ------ |
| 播放器 | LNDanmakuPlayer | 播放器相当于对整个弹幕框架其他组件的整合，对外提供调用方法和时机代理 |
| 分发器 | LNDanmakuAbstractDispatcher | Dispatcher类似管理轨道的工头儿，根据轨道集合的状态决定弹幕放到哪里才是最好的 |
| 轨道控制器 | LNDanmakuAbstractTrackController | 轨道控制器类似一个工人，定期使用工具(Track)维护自己的弹幕，并向Dispatcher反馈自己的（繁忙/空闲）状态 |
| 轨道 | LNDanmakuAbstractTrack | Track的职责完全符合轨道的定义，它不维护弹幕，只维护任意一条弹幕弹幕在这个轨道上的刷新的位置、大小、仿射变换等属性与时间进度的映射，像是一个空间信息与时间信息的函数 |
| 样式 | LNDanmakuAbstractAttributes | 样式是弹幕的载体，包含了一条弹幕的所有信息，例如：存活时间、位置、携带的业务模型、展示时使用的View/Layer等等。对，没错，与CollectionViewAttributes十分类似，并根据播放器特性增加了时间戳信息 |

额外的组件

| 模块名称 | 类名 | 备注 |
| ------ | ------ | ------ |
| 轨道组 | LNDanmakuTrackGroup | 这个组件是用来做一些特殊弹幕播放的，是类似一个Player的更小单元（但没有自己的驱动），内部包含了一个Dispatcher和若干TrackController |

这个组件的意义：
某些弹幕播放对轨道有一定的要求，又或是轨道对自己播放的弹幕有一定要求，例如：送礼物的轨道只能出现在屏幕顶端，而不是中央，来避免影响用户观看视频；或者是，圆形的轨道不能那些较长的文字，这样它看起来就不是那么圆了，等等。
一但从两个方面考虑这个问题，就会陷入：轨道挑选弹幕/弹幕挑选轨道的困境，而实际上两种情况是都存在的，这两个问题最后统一使用轨道组解决，用户指定一个轨道的分组，并可以跨过Player层，直接向这个轨道组抛弹幕，那么这个弹幕就只有可能出现在这个轨道组包含的轨道中；这个功能在Demo中一个彩虹样式的轨道中得以体现，我将七种颜色的弹幕分别抛入七个轨道组中（每个轨道组有三根轨道，两个相邻的轨道组公用中间那个重合的轨道），这样它们就呈现除了一种彩虹的效果。

### 使用示例

以上介绍完了这个框架的所有重要组件，这里举例介绍构建一个最简单弹幕播放器的过程：
1.懒加载一个danmakuPlayer：
这个是起码要做,不需要做任何配置它就可以正常工作
```
- (LNDanmakuPlayer *)danmakuPlayer
{
    if (!_danmakuPlayer) {
        _danmakuPlayer = [[LNDanmakuPlayer alloc] init];
    }
    return _danmakuPlayer;
}
```
2.把这个播放器的容器View加到屏幕上：
```
    [self.view addSubview:self.danmakuPlayer.containerView];
```
3.给这个Player加一些轨道：
Player支持自定义就是主要体现在自定义轨道和弹幕样式上，所以，所有的轨道都是你亲手加上去的，你可以在init/viewDidLoad等初始化的时机做这个时，也可以在Player懒加载时一并加好
```
- (void)addTrack
    for (int i = 0; i < 20; i++) {
        LNDanmakuHorizontalMoveTrackController *horizontalTrackController = [[LNDanmakuHorizontalMoveTrackController alloc] init];
        horizontalTrackController.horizontalTrack.startPosition = CGPointMake(0, 44.f + 30.f * i);
        horizontalTrackController.horizontalTrack.width = self.view.frame.size.width;
        horizontalTrackController.spaceTimeInterval = 0.f;
        [self.danmakuPlayer addTrack:horizontalTrackController];
    }
}
```
4.让播放器动起来！
现在这个播放器就可以从外界接口随便一个弹幕并播放在屏幕上了
```
- (void)startPlay {
    [self.danmakuPlayer start];
}
```
5.让我们尝试放一个简单的弹幕放上去：
```
- (void)addRandomDanmaku
{
        LNDanmakuAttributes *attributes = [[LNDanmakuAttributes alloc] init];
        UIView *colorView = [[UIView alloc] init];
        colorView.backgroundColor = [UIColor redColor];
        attributes.presentView = colorView;
        attributes.trackTime =4.f;
        attributes.size = CGSizeMake(88.f, 44.f);
        [_player insertAttributes:@[attributes]];
}
```

这个框架尽量使用最符合正常逻辑的方法定义了每个组件的分工来保证它使用起来是最舒服的，并尽可能封装了那些看起来比较复杂的逻辑：分发、刷新、追赶等等；当然，我觉得一个合理的框架应该是下限很低，上限也很高的，而不是一成不变使用规则（正如掌控疾风的某位男子应该算得上是设计得比较成功的角色），所以，当使用者需要深入探讨这些逻辑的时候，也可以从外部轻易定制他们，玩出自己的特色，这个组件也会朝着尽量少的使用规则、尽量朴素的代码、更丰富的功能方向发展。

### 最后附上几个Demo中的效果图

* 横向的轨道

[![yVlmjO.gif](https://upload-images.jianshu.io/upload_images/8942216-2d01f255d5b61f6e.gif?imageMogr2/auto-orient/strip)](https://imgchr.com/i/yVlmjO)

* pop动画轨道

[![yVlegK.gif](https://upload-images.jianshu.io/upload_images/8942216-a6efbf1514bd29a3.gif?imageMogr2/auto-orient/strip)](https://imgchr.com/i/yVlegK)

* 波浪轨道+轨道分组

[![yVluuD.gif](https://upload-images.jianshu.io/upload_images/8942216-a5badf677a749f52.gif?imageMogr2/auto-orient/strip)](https://imgchr.com/i/yVluuD)

* 心形轨道

[![yVlkNR.gif](https://upload-images.jianshu.io/upload_images/8942216-30f48a64ae7f3365.gif?imageMogr2/auto-orient/strip)](https://imgchr.com/i/yVlkNR)

