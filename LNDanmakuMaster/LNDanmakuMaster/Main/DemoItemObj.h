//
//  DemoItemObj.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DemoType)
{
    DemoTypeHorizontal = 0,
    DemoTypeStable = 1,
    DemoTypeCircle,
    DemoTypeChristina,
    DemoTypePop,
    DemoTypeSin,
    
    DemoTypeDispatcherDefault,
    DemoTypeDispatcherLowDensity,
    DemoTypeDispatcherMostFast,
    
    DemoTypeGesture,
    
    DemoTypeTrackGroup,
    
    DemoTypeVideoDanmaku,
    
    DemoTypeCount,
};

NS_ASSUME_NONNULL_BEGIN

@interface DemoItemObj : NSObject

@property (nonatomic, assign) DemoType type;

@end


NS_ASSUME_NONNULL_END
