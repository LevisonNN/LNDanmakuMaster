//
//  NSObject+LNDanmakuPool.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "NSObject+LNDanmakuPool.h"
#import <objc/runtime.h>

NSString *const kLNDanmakuPoolKey = @"kLNDanmakuPoolKey";

@implementation NSObject (LNDanmakuPool)

- (void)setDanmakuPoolKey:(NSString *)string
{
    objc_setAssociatedObject(self, kLNDanmakuPoolKey.UTF8String, string, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)danmakuPoolKey
{
    return objc_getAssociatedObject(self, kLNDanmakuPoolKey.UTF8String);
}


@end
