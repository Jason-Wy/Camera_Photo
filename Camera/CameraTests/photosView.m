//
//  photosView.m
//  Camera
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 Woddon. All rights reserved.
//

#import "photosView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation photosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        PhotoArray = [NSMutableArray arrayWithCapacity:100];
        bigPhotoArray = [NSMutableArray arrayWithCapacity:100];
        VideoArray = [NSMutableArray arrayWithCapacity:100];
        smallVideoPicArray = [NSMutableArray arrayWithCapacity:100];
        
        UIImage *image = [UIImage imageNamed:@"wbj.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        
        //选项卡背景
        image = [UIImage imageNamed:@"phbj"];
        bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 50)];
        bg.backgroundColor = [UIColor grayColor];
        [self addSubview:bg];
        bg.userInteractionEnabled = YES;
        
        //选项卡
        item1 = [UIButton buttonWithType:UIButtonTypeCustom];
        item1.frame = CGRectMake(CGRectGetMidX(self.bounds)-100, 5, 100, 40);
        [item1 setTitle:@"Photo" forState:UIControlStateNormal];
        item1.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:77.0f/255.0f blue:12.0f/255.0f alpha:1];
        [item1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        item1.tag = 110;
        item1.showsTouchWhenHighlighted = YES;
        item1.layer.cornerRadius = 10;
        [bg addSubview:item1];
        
        item2 = [UIButton buttonWithType:UIButtonTypeCustom];
        item2.frame = CGRectMake(CGRectGetMidX(self.bounds)+1, 5, 100, 40);
        [item2 setTitle:@"Video" forState:UIControlStateNormal];
        item2.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:47.0f/255.0f alpha:1];
        [item2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        item2.tag = 111;
        [bg addSubview:item2];
        item2.layer.cornerRadius = 5;
        item2.showsTouchWhenHighlighted = YES;
        
        image = [UIImage imageNamed:@"fhd.png"];
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:image forState:UIControlStateNormal];
        backButton.frame = CGRectMake(30, 8, image.size.width, image.size.height);
        [backButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.tag = 112;
        [bg addSubview:backButton];
        
        //在程序里面这应该把一个单例赋值过来。
        isPhotoVideo = YES;
        
        photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, 480, 320)];
        photoScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:photoScrollView];
        photoScrollView.hidden = NO;
        
        videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, 480, 320)];
        videoScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:videoScrollView];
        videoScrollView.hidden = YES;
        
        
        [self loadTableView];
        
        loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [loadingView addSubview:activityIndicator];
        activityIndicator.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));
        activityIndicator.backgroundColor = [UIColor blackColor];
        activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:loadingView];
        loadingView.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));

        
    }
    return self;
}

- (void)loadTableView
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingFormat:@"/Movie"];
    
    if ([fileManager removeItemAtPath:path error:nil]) {
        
    }
    
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
        
    }
    
    //显示
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *myerror){
            NSLog(@"相册访问失败 = %@",[myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"User denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        ALAssetsGroupEnumerationResultsBlock groupEnumerAction =  ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result != NULL) {
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto] || [[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypeVideo]) {
                    
                    NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                    
                    NSString* resultName = [urlstr substringFromIndex:0];
                    resultName = [resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                        UIImage *img1 = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                        [PhotoArray addObject:img];
                        [bigPhotoArray addObject:img1];
                        
                    }else
                    {
                        resultName = [urlstr stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
                        NSData *data = [self imageData:result];
                        NSString *pathName = [path stringByAppendingFormat:@"/%@",result.defaultRepresentation.filename];
                        if ([data writeToFile:pathName atomically:YES]) {
                            [VideoArray addObject:pathName];
                            UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                            [smallVideoPicArray addObject:img];
                        }
                    }
                }
            }else
            {
                CGFloat width = round(self.bounds.size.width/100);
                CGFloat xx = 0;
                CGFloat yy = 0;
                
                //加载数据
                //两个图片之间是15，图片与边框是10.
                for (int i = 0; i<[PhotoArray count]; i++) {
                    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (xx >= width) {
                        xx = 0;
                        yy = yy+90;
                    }
                    else{
                        xx++;
                        
                    }
                    abtn.frame = CGRectMake(10+(xx - 1)*(80+15), yy, 80, 80);
                    abtn.layer.borderColor = [UIColor grayColor].CGColor;
                    abtn.layer.borderWidth = 1;
                    [abtn setImage:[PhotoArray objectAtIndex:i] forState:UIControlStateNormal];
                    [abtn addTarget:self action:@selector(btnActionTap:) forControlEvents:UIControlEventTouchUpInside];
                    abtn.tag = 10000+i;
                    [photoScrollView addSubview:abtn];
                    
                }
                for (int i = 0; i<[smallVideoPicArray count]; i++) {
                    if (xx >= width) {
                        xx = 0;
                        yy = yy+90;
                    }else
                    {
                        xx++;
                    }
                    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    abtn.frame = CGRectMake(10+(xx-1)*(80+15), yy, 80, 80);;
                    [abtn setImage:[smallVideoPicArray objectAtIndex:i] forState:UIControlStateNormal];
                    [abtn addTarget:self action:@selector(btnActionTap:) forControlEvents:UIControlEventTouchUpInside];
                    abtn.tag = 20000+i;
                    [videoScrollView addSubview:abtn];
                }
                
                if (loadingView) {
                    [loadingView removeFromSuperview];
                }
                
                [self ListVideoPhotoButton];
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libratyGroupsEnumeration = ^(ALAssetsGroup *group,BOOL *stop){
            if (group == nil){
                [loadingView removeFromSuperview];
            }else
            {
                NSString* g = [NSString stringWithFormat:@"%@",group];
                
                NSString *g1 = [g substringFromIndex:16];
                NSArray *arr = [NSArray arrayWithArray:[g1 componentsSeparatedByString:@","]];
                NSString *g2 = [[arr objectAtIndex:0]substringFromIndex:5];
                if ([g2 isEqualToString:@"视屏"]) {
                    [group enumerateAssetsUsingBlock:groupEnumerAction];
                }
            }
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:libratyGroupsEnumeration failureBlock:failureBlock];
        
        
    });
}

//显示相片
-(void)ListVideoPhotoButton
{
    if (isPhotoVideo) {
        NSLog(@"photo");
    }else{
        NSLog(@"video");
    }
}

- (void)btnActionTap:(UIButton *)sender
{
    CGRect rect;
    rect = CGRectMake(0, 0, 480, 320);
    movieView = [[UIView alloc]initWithFrame:rect];
    movieView.center = CGPointMake(1500,CGRectGetMidY(self.bounds));
    movieView.backgroundColor = [UIColor blackColor];
    [self addSubview:movieView];
    
    UIView* barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(movieView.bounds), 40)];
    barView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:47.0f/255.0f alpha:1];
    barView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIImage *image = [UIImage imageNamed:@"fhd.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(30, 5, image.size.width, image.size.height);
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BackBtAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 1000;
    [barView addSubview:backBtn];
    [movieView insertSubview:barView atIndex:1];
    
    
    if (isPhotoVideo) {
        if (sender.tag >= 10000 && sender.tag <= 19999) {
            [self showImage:sender.tag];
        }
    }else{
        if (sender.tag >=20000&& sender.tag <= 29999) {
            [self PlayMovie:[VideoArray objectAtIndex:sender.tag - 20000]];
            
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^(void){
        movieView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }completion:^(BOOL finished){
        //            if (!engine.isPhotoVideo) {
        
        if (!isPhotoVideo) {
            [player play];
        }
        
    }];

    
    
}


- (void)BackBtAction:(UIButton *)sender
{
    if (sender.tag == 1000) {
        [UIView animateWithDuration:0.5 animations:^(void){
            movieView.center = CGPointMake(1500, CGRectGetMidY(self.bounds));
        }completion:^(BOOL finished){
            [movieView removeFromSuperview];
        }];
    }
}

- (void)PlayMovie:(NSString *)fileName
{
    CGRect rect;
    rect = CGRectMake(0, 0, 320, 480);
    UIView* PlayMovieView = [[UIView alloc] initWithFrame:rect];
    PlayMovieView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:fileName];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = rect;
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [PlayMovieView.layer addSublayer:playerLayer];
    
    PlayMovieView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [movieView insertSubview:PlayMovieView atIndex:0];
    
}

- (void)showImage:(int )tag
{
    UIImage *image;
    image = [bigPhotoArray objectAtIndex:tag-10000];
    CGRect rect;
    if (isiPad()) {
        rect = CGRectMake(0, 0, 1024, 768);
    }else if (isiPhoneFourInch())
    {
        rect = CGRectMake(0, 0, 568, 320);
    }else{
        rect = CGRectMake(0, 0, 480, 320);
    }
    bg2 = [[UIImageView alloc] initWithFrame:rect];
    [bg2 setImage:image];
    bg2.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [movieView insertSubview:bg2 atIndex:0];
    
}

//读取视频
- (NSData *)imageData:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    NSUInteger size = (NSUInteger )[assetRep size];
    uint8_t *buff = malloc(size);
    
    NSError *error = nil;
    NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&error];
    
    if (gotByteCount) {
        if (error) {
            free(buff);
            return nil;
        }
    }
    return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}

- (void)btnAction:(id)sender
{
    //    Engine *engine = [Engine sharedInstance];
    
    UIButton* sende = (UIButton *)sender;
    //    NSLog(@"%ld",(long)sende.tag);
    if (sende.tag == 112) {
        [self removeFromSuperview];
    }
    
    if (sende.tag == 110 || sende.tag == 111) {
        
        item1.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:47.0f/255.0f alpha:1];
        item2.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:47.0f/255.0f alpha:1];
        
        sende.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:77.0f/255.0f blue:12.0f/255.0f alpha:1];
        
        photoScrollView.hidden = YES;
        videoScrollView.hidden = YES;
        
        if (sende.tag == 110) {
            //            engine.isPhotoVideo = YES;
            isPhotoVideo = YES;
            photoScrollView.hidden = NO;
        }
        if (sende.tag == 111) {
            //            engine.isPhotoVideo = NO;
            isPhotoVideo = NO;
            videoScrollView.hidden = NO;
        }
        
        [self ListVideoPhotoButton];
    }
}




@end

























