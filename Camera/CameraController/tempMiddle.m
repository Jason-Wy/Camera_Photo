//
//  tempMiddle.m
//  Camera
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 Woddon. All rights reserved.
//

/*

现demo存在的问题：
 1、点击照相和录像时应有一秒的间隔，否则会出现反应慢
 2、在加载图像和视频时，应分开加载
 3、在单独加载视频和图像时，应该分步加载，这样可以减少内存消耗，不出现闪退情况。
 4、在播放视频时应放在支线程上，并加载暂停
 5、在阅览照片和视频时应有可以前后阅览。
 6、添加手势，可以左右切换相册和视频




*/
#import "tempMiddle.h"
#import "ListPhotoView.h"
#import "photosView.h"

@implementation tempMiddle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.height;
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        
        self.backgroundColor = [UIColor redColor];
        
        
        
        mobileCamera = [[CamController alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        mobileCamera.center = CGPointMake(screenWidth/2, screenHeight/2);
        [self addSubview:mobileCamera];
        
        
        
        
        
        
        UIButton* bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 80, 44)];
        [bt setTitle:@"照相" forState:UIControlStateNormal];
        [bt setTitle:@"正在照相" forState:UIControlStateHighlighted];
        [self addSubview:bt];
        [bt addTarget:self action:@selector(gotoCamera) forControlEvents:UIControlEventTouchUpInside];
        
        btvedio = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 80, 44)];
        [btvedio setTitle:@"录相" forState:UIControlStateNormal];
        [btvedio setTitle:@"正在录相" forState:UIControlStateHighlighted];
        [self addSubview:btvedio];
        [btvedio addTarget:self action:@selector(gotoCameraVedio) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* bt_photo = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 44)];
        [bt_photo setTitle:@"相册" forState:UIControlStateNormal];
        [self addSubview:bt_photo];
        [bt_photo addTarget:self action:@selector(gotophoto) forControlEvents:UIControlEventTouchUpInside];
        
        isVedio = NO;
    }
    return self;
}

- (void)gotoCamera
{
//    [mobileCamera setupPhotoSession];这个和下面的视频是我们每次选择录像和照相时，需要初始化格式，
//    照相是默认的
//    只有初始化后才能拍照或录像
    /*
     if([videoPhotoButton imageForState:UIControlStateNormal]==[UIImage imageNamed:@"on1.png"])
     
     - (void)changeCameraState
     {
     if (isVedioOrCamera_t == NO) {
     
     vedioTimeLable_t.hidden = NO;
     [mobileCamera setupCaptureSession];
     }else{
     
     vedioTimeLable_t.hidden = YES;
     [mobileCamera setupPhotoSession];
     }
     }
     
     if (engine.isRotated) {
     self.view.transform = CGAffineTransformMakeRotation(M_PI);
     if (!CamView.hidden) {
     [camcontroller changeRotateScreen:NO];
     }
     }else{
     self.view.transform = CGAffineTransformMakeRotation(0);
     if (!CamView.hidden) {
     [camcontroller changeRotateScreen:YES];
     }
     }


     */
    
    [mobileCamera Captureimage];//启动照相
}

- (void)gotoCameraVedio
{
    if (isVedio == NO) {
        [mobileCamera setupCaptureSession];//启动摄像
        isVedio = YES;
        [mobileCamera startRecord];
        [btvedio setTitle:@"正在录相" forState:UIControlStateNormal];
    }
    else
    {
        [mobileCamera stopRecord];
        isVedio = NO;
        [btvedio setTitle:@"录相" forState:UIControlStateNormal];
    }
}

- (void)gototextPhoto
{
    CGRect rect;
    rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    photosView *listphotoview = [[photosView alloc] initWithFrame:rect];
    [self addSubview:listphotoview];
    
    listphotoview.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

}

- (void)gotophoto
{
    CGRect rect;
    if (isiPad()) {
        rect = CGRectMake(10, 10, 1024, 768);
    }else if (isiPhoneFourInch())
    {
        rect = CGRectMake(10, 10, 568, 320);
    }else{
        rect = CGRectMake(10, 10, 480, 320);
    }
//    rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    ListPhotoView *listphotoview = [[ListPhotoView alloc] initWithFrame:rect];
    [self addSubview:listphotoview];
    
    listphotoview.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    
    
}


@end
