//
//  VideoDanmakuFactory.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAttributes.h"
#import "VideoDanmakuModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * 这个工厂做 Model -> Attributes 转换
 * model通常被放在attributes的customObj中，通过attributs.customObj自省、强转访问
 * 正常的封装逻辑是：
 * LNDanmakuPlayer层的回调对外传递的都是attributes。
 * VideoDanmakuPlayer(业务层)回调对外传递的都是业务模型，即attributes.customObj。
 **/

@interface VideoDanmakuFactory : NSObject

- (LNDanmakuAttributes *)attributesForDanmakuModel:(VideoDanmakuModel *)danmakuModel;

@end

NS_ASSUME_NONNULL_END
