//
//  photosView.h
//  Camera
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 Woddon. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <AVFoundation/AVFoundation.h>

@interface photosView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *bg;
    UIButton *item1,*item2,*backButton;
    
    UIScrollView *photoScrollView;
    UIScrollView *videoScrollView;
    
    BOOL isPhotoVideo;
    
    UIView *loadingView;
    
    NSMutableArray *PhotoArray;
    NSMutableArray *bigPhotoArray;//这里一个是小型缩小的图片，一个是放大后全屏的图片
    NSMutableArray *VideoArray;
    NSMutableArray *smallVideoPicArray;
    
    UIView *movieView;
    UIImageView *bg2;
    
    AVPlayer *player;
}

@end
