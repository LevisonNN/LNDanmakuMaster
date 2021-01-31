//
//  LNDanmakuPurePool.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuPurePool.h"
#import "NSObject+LNDanmakuPool.h"

@interface LNDanmakuPurePool ()

@property (nonatomic, strong) NSMutableSet *poolMSet;

@end

@implementation LNDanmakuPurePool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCapacity = 300;
        self.targetClass = [NSObject class];
        self.poolKey = @"kNSObject";
    }
    return self;
}

- (void)saveObj:(NSObject *)obj
{
    if (self.poolMSet.count > self.maxCapacity) {
        while (self.poolMSet.count > self.maxCapacity) {
            [self.poolMSet removeObject:self.poolMSet.anyObject];
        }
    } else if (self.poolMSet.count == self.maxCapacity) {
        //Fulled .
    } else {
        if ([obj isKindOfClass:self.targetClass] && [[obj danmakuPoolKey] isEqualToString:self.poolKey]) {
            [self.poolMSet addObject:obj];
        }
    }
}

- (NSObject *)getObj
{
    NSObject *resultObj = nil;
    while (self.poolMSet.count > 0) {
        NSObject *obj = [self.poolMSet anyObject];
        if ([obj isKindOfClass:self.targetClass] && [obj.danmakuPoolKey isEqualToString:self.poolKey]) {
            resultObj = obj;
            [self.poolMSet removeObject:obj];
            break;
        } else {
            [self.poolMSet removeObject:obj];
        }
    }
    
    if (resultObj) {
        return resultObj;
    } else {
        resultObj = [[self.targetClass alloc] init];
        [resultObj setDanmakuPoolKey:self.poolKey];
        return resultObj;
    }
}

- (void)clearPurePool
{
    [self.poolMSet removeAllObjects];
}


- (void)setTargetClass:(Class)targetClass
{
    if (targetClass != _targetClass) {
        [self.poolMSet removeAllObjects];
        _targetClass = targetClass;
    }
}

- (void)setPoolKey:(NSString *)poolKey
{
    if (poolKey != _poolKey) {
        [self.poolMSet removeAllObjects];
        _poolKey = [poolKey copy];
    }
}

- (NSMutableSet *)poolMSet
{
    if (!_poolMSet) {
        _poolMSet = [[NSMutableSet alloc] init];
    }
    return _poolMSet;
}

@end
