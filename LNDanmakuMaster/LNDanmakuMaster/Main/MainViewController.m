//
//  MainViewController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "MainViewController.h"
#import "DemoItemCollectionViewCell.h"
#import "DemoItemObj.h"
#import "TracksDemoViewController.h"
#import "DispatcherDemoViewController.h"
#import "GestureDemoViewController.h"
#import "TrackGroupDemoViewController.h"
#import "VideoDanmakuDemoViewController.h"

#import "LNDanmakuMaster.h"

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray <DemoItemObj *> *demoList;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self loadDemoList];

    [self addSubviews];
    [self addConstraints];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)addSubviews
{
    [self.view addSubview:self.collectionView];
}

- (void)addConstraints
{
    self.collectionView.frame = self.view.bounds;
}

- (void)loadDemoList
{
    NSMutableArray *listMArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < DemoTypeCount; i++) {
        DemoItemObj *horizontalItem = [[DemoItemObj alloc] init];
        horizontalItem.type = i;
        [listMArr addObject:horizontalItem];
    }
    
    self.demoList = [listMArr copy];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:DemoItemCollectionViewCell.class forCellWithReuseIdentifier:kDemoItemCollectionViewCell];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    }
    return _flowLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100.f, 44.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoItemCollectionViewCell *cell = (DemoItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDemoItemCollectionViewCell forIndexPath:indexPath];
    [cell setItemObj:self.demoList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    switch (self.demoList[indexPath.row].type) {
        //track
        case DemoTypeStable: {
            TracksDemoViewController *stableController = [[TracksDemoViewController alloc] initWithType:TracksDemoViewControllerStable];
            [self.navigationController pushViewController:stableController animated:YES];
        } break;
        case DemoTypeCircle: {
            TracksDemoViewController *circleController = [[TracksDemoViewController alloc] initWithType:TracksDemoViewControllerCircle];
            [self.navigationController pushViewController:circleController animated:YES];
        } break;
        case  DemoTypeChristina: {
            TracksDemoViewController *christinaController = [[TracksDemoViewController alloc] initWithType:TracksDemoViewControllerChristina];
            [self.navigationController pushViewController:christinaController animated:YES];
        } break;
        case DemoTypePop: {
            TracksDemoViewController *popController = [[TracksDemoViewController alloc] initWithType:TracksDemoViewControllerPop];
            [self.navigationController pushViewController:popController animated:YES];
        } break;
        case DemoTypeSin: {
            TracksDemoViewController *sinController = [[TracksDemoViewController alloc] initWithType:TracksDemoViewControllerSin];
            [self.navigationController pushViewController:sinController animated:YES];
        } break;
            
        //dispatcher
        case DemoTypeDispatcherDefault: {
            DispatcherDemoViewController *defaultController = [[DispatcherDemoViewController alloc] initWithType:DispatcherDemoViewControllerDefault];
            [self.navigationController pushViewController:defaultController animated:YES];
        } break;
        case DemoTypeDispatcherLowDensity: {
            DispatcherDemoViewController *lowDensityController = [[DispatcherDemoViewController alloc] initWithType:DispatcherDemoViewControllerLowDensity];
            [self.navigationController pushViewController:lowDensityController animated:YES];
        } break;
        case DemoTypeDispatcherMostFast: {
            DispatcherDemoViewController *mostFastController = [[DispatcherDemoViewController alloc] initWithType:DispatcherDemoViewControllerMostFast];
            [self.navigationController pushViewController:mostFastController animated:YES];
        } break;
            
        //gesture
        case DemoTypeGesture: {
            GestureDemoViewController *gestureController = [[GestureDemoViewController alloc] init];
            [self.navigationController pushViewController:gestureController animated:YES];
        } break;
        
        //trackGroup
        case DemoTypeTrackGroup: {
            TrackGroupDemoViewController *trackGroupController = [[TrackGroupDemoViewController alloc] init];
            [self.navigationController pushViewController:trackGroupController animated:YES];
        } break;
            
        case DemoTypeVideoDanmaku: {
            VideoDanmakuDemoViewController *videoDanmakuController = [[VideoDanmakuDemoViewController alloc] init];
            [self.navigationController pushViewController:videoDanmakuController animated:YES];
        } break;
            
        default: {
            TracksDemoViewController *horizontalController = [[TracksDemoViewController alloc] init];
            [self.navigationController pushViewController:horizontalController animated:YES];
        } break;
    }
}

@end

