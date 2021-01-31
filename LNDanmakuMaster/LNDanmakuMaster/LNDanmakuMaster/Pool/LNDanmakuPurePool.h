//
//  LNDanmakuPurePool.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * A pure pool contains one kind of obj.
 **/

@interface LNDanmakuPurePool : NSObject

@property (nonatomic, assign) NSInteger maxCapacity;

@property (nonatomic, assign) Class targetClass;
@property (nonatomic, copy) NSString *poolKey;

- (void)saveObj:(NSObject *)obj;
- (NSObject *)getObj;

- (void)clearPurePool;


@end

NS_ASSUME_NONNULL_END
