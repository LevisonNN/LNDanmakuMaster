//
//  DemoItemCollectionViewCell.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "DemoItemCollectionViewCell.h"

NSString *const kDemoItemCollectionViewCell = @"kDemoItemCollectionViewCell";

@interface DemoItemCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) DemoItemObj *itemObj;

@end

@implementation DemoItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)setItemObj:(DemoItemObj *)item
{
    _itemObj = item;
    switch (item.type) {
        case DemoTypeStable:{
            self.titleLabel.text = @"定点轨道";
        } break;
        case DemoTypeCircle:{
            self.titleLabel.text = @"圆形轨道";
        } break;
        case DemoTypeChristina:{
            self.titleLabel.text = @"心形轨道";
        } break;
        case DemoTypePop:{
            self.titleLabel.text = @"气泡轨道";
        } break;
        case DemoTypeSin:{
            self.titleLabel.text = @"正弦轨道";
        } break;
        case DemoTypeDispatcherDefault: {
            self.titleLabel.text = @"最密分发";
        } break;
        case DemoTypeDispatcherLowDensity: {
            self.titleLabel.text = @"最疏分发";
        } break;
        case DemoTypeDispatcherMostFast: {
            self.titleLabel.text = @"最快分发";
        } break;
        case DemoTypeGesture: {
            self.titleLabel.text = @"弹幕手势";
        } break;
        case DemoTypeTrackGroup: {
            self.titleLabel.text = @"轨道组";
        } break;
        case DemoTypeVideoDanmaku: {
            self.titleLabel.text = @"视频弹幕";
        } break;
        default:{
            self.titleLabel.text = @"横向轨道";
            
        } break;
    }
    self.contentView.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.f green:(rand()%255)/255.f blue:(rand()%255)/255.f alpha:(rand()%255)/255.f];
}

- (void)addSubviews
{
    [self.contentView addSubview:self.titleLabel];
}

- (void)addConstraints
{
    self.titleLabel .frame = self.contentView.frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraints];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

