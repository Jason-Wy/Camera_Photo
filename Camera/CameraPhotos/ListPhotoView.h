//
//  ListPhotoView.h
//  iConCopter
//
//  Created by woddon on 13-8-7.
//
//

#import <UIKit/UIKit.h>


#import "tempMiddle.h"
//#import "VideoViewController.h"这个需要改为返回的view
//#import "Engine.h"
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface ListPhotoView : UIView
{
    NSMutableArray *PhotoArray;
    NSMutableArray *bigPhotoArray;
    NSMutableArray *VideoArray;
    NSMutableArray *smallVideoPicArray;
    
    UIView *movieView;
    AVPlayer* player;
    UIButton *item1,*item2;
    
    UIScrollView *photoScrollView;
    UIScrollView *videoScrollView;
    
    UIView *loadingView;
    
    UIImageView *bg;
    UIImageView *bg2;
    
    BOOL isPhotoVideo;
}

@end
