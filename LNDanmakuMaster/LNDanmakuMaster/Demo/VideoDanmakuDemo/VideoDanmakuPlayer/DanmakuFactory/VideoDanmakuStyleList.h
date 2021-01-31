//
//  VideoDanmakuStyleList.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 建议在一个公共的样式表中配置一个弹幕播放器可能播放到的所有样式参数。
 * 可能有这些好处：
 * 1.如果所有的弹幕在初始化时都需要用到CTFont/AttributesDic等这些东西，你可以统一使用一套而不用频繁创建相同的Font/Dic
 * 2.当你的弹幕有一个半透明的圆角矩形背景时，你可以全局使用一个用作背景的CALayer和图像预合成技术来不断印刷出想要的UIImage。
 * 3.修改样式时容易找到。
 **/

/*
 * 根据弹幕的不同种类可以有多个子样式表。
 **/

@interface VideoDanmakuStyleList : NSObject

@end

NS_ASSUME_NONNULL_END
