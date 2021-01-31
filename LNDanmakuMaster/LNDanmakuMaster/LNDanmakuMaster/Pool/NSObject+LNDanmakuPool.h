//
//  NSObject+LNDanmakuPool.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LNDanmakuPool)

- (void)setDanmakuPoolKey:(NSString *)string;
- (NSString *)danmakuPoolKey;

@end

NS_ASSUME_NONNULL_END
