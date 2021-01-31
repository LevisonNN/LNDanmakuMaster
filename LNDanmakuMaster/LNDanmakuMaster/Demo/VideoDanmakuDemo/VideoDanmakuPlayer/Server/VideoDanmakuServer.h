//
//  VideoDanmakuServer.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoDanmakuServer : NSObject

- (void)requestDanmakuInfo:(NSString *)videoId
                 startTime:(NSTimeInterval)startTime
                   endTime:(NSTimeInterval)endTime;

@end

NS_ASSUME_NONNULL_END
