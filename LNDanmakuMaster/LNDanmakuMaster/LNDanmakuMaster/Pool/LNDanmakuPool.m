//
//  LNDanmakuPool.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuPool.h"
#import "LNDanmakuPurePool.h"
#import "NSObject+LNDanmakuPool.h"

@interface LNDanmakuPool ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, LNDanmakuPurePool *> *poolMDic;

@end

@implementation LNDanmakuPool

- (void)registerClass:(Class)class forKey:(NSString *)key
{
    NSAssert(key != nil, @"key为空");
    LNDanmakuPurePool *purePool = [self.poolMDic objectForKey:key];
    if (purePool) {
        [purePool setTargetClass:class];
        [purePool setPoolKey:key];
    } else {
        purePool = [[LNDanmakuPurePool alloc] init];
        purePool.targetClass = class;
        purePool.poolKey = key;
        [self.poolMDic setObject:purePool forKey:key];
    }
}

- (NSObject *)instanceForKey:(NSString *)key
{
    LNDanmakuPurePool *purePool = [self.poolMDic objectForKey:key];
    if (purePool) {
        return [purePool getObj];
    }
    return nil;
}

- (void)saveInstance:(NSObject *)instance
{
    LNDanmakuPurePool *purePool = [self.poolMDic objectForKey:instance.danmakuPoolKey];
    if (purePool) {
        [purePool saveObj:instance];
    }
}

- (NSMutableDictionary<NSString *,LNDanmakuPurePool *> *)poolMDic
{
    if (!_poolMDic) {
        _poolMDic = [[NSMutableDictionary alloc] init];
    }
    return _poolMDic;
}

@end

@implementation LNDanmakuPool (Control)

- (void)clearPool
{
    for (LNDanmakuPurePool *purePool in self.poolMDic.allValues) {
        [purePool clearPurePool];
    }
}

@end
