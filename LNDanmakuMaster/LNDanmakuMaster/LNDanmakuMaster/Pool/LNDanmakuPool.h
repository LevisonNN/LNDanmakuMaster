//
//  LNDanmakuPool.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * A pure pool contains different kinds of obj using several pure pools.
 * Just like using UICollectionView/UITableView.
 * If you just "get" but not put back, then you have stolen an instance from this pool! ([○･｀Д´･ ○])
 **/

NS_ASSUME_NONNULL_BEGIN

@interface LNDanmakuPool : NSObject

- (void)registerClass:(Class)class forKey:(NSString *)key;
- (NSObject *)instanceForKey:(NSString *)key;
- (void)saveInstance:(NSObject *)instance;

@end

@interface LNDanmakuPool (Control)

- (void)clearPool;

@end

NS_ASSUME_NONNULL_END
