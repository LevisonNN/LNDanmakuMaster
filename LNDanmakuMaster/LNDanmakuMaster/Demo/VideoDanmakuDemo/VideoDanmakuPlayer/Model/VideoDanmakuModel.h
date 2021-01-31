//
//  VideoDanmakuModel.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 请求到的网络模型
 **/

/*
 * 如果有其他类型的弹幕可以一并在这里枚举出，不同的只是UIView本身和播放的轨道
 **/

typedef NS_ENUM(NSInteger, VideoDanmakuType)
{
    VideoDanmakuTypeText, //文字
    VideoDanmakuTypeImage, //图片
    VideoDanmakuTypeGift, //礼物
};

@interface VideoDanmakuModel : NSObject

@property (nonatomic, assign) VideoDanmakuType type;

//text
@property (nonatomic, copy) NSString *textContent;
//image
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) CGSize imageSize;

//Gift 特殊类型
@property (nonatomic, strong) NSObject *giftModel;

@end

NS_ASSUME_NONNULL_END
