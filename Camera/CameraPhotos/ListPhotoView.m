//
//  ListPhotoView.m
//  iConCopter
//
//  Created by woddon on 13-8-7.
//
//

#if 0

    Build Phases 里面把相册改为 -fno-objc-arc
    修改相册名，

#endif


#import "ListPhotoView.h"


@implementation ListPhotoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bigPhotoArray = [[NSMutableArray alloc] initWithCapacity:100];
        PhotoArray = [[NSMutableArray alloc] initWithCapacity:100];
        VideoArray = [[NSMutableArray alloc] initWithCapacity:100];
        smallVideoPicArray = [[NSMutableArray alloc] initWithCapacity:100];
        // Initialization code
//        UIImage *image = [UIImage imageNamed:getImageName(@"wbj")];
        UIImage *image = [UIImage imageNamed:@"wbj.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        
        //选项卡背景
//        image = [UIImage imageNamed:getImageName(@"phbj")];
        image = [UIImage imageNamed:@"phbj"];
        bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 50)];
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
        item1.layer.cornerRadius = 5;
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
        
        //back
//        image = [UIImage imageNamed:getImageName(@"fhd")];
        image = [UIImage imageNamed:@"fhd.png"];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:image forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(30, 8, image.size.width, image.size.height);
//        backBtn.center = CGPointMake(30, bg.frame.size.height/2);
        [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = 112;
        [bg addSubview:backBtn];
        
        [bg release];
        
//        Engine *engine = [Engine sharedInstance];
//        engine.isPhotoVideo = YES;
        isPhotoVideo = YES;
        
        photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 480, 260)];
        photoScrollView.backgroundColor = [UIColor whiteColor];
        photoScrollView.pagingEnabled = YES;
        photoScrollView.scrollEnabled = YES;
        photoScrollView.showsHorizontalScrollIndicator = NO;
        photoScrollView.showsVerticalScrollIndicator = NO;
        [photoScrollView setContentOffset:CGPointMake(0, 0)];
        [self addSubview:photoScrollView];
        photoScrollView.hidden = NO;
        [photoScrollView release];
        
        videoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 480, 260)];
        videoScrollView.backgroundColor = [UIColor whiteColor];
        videoScrollView.pagingEnabled = YES;
        videoScrollView.scrollEnabled = YES;
        videoScrollView.showsHorizontalScrollIndicator = NO;
        videoScrollView.showsVerticalScrollIndicator = NO;
        [videoScrollView setContentOffset:CGPointMake(0, 0)];
        [self addSubview:videoScrollView];
        videoScrollView.hidden = YES;
        [videoScrollView release];
        
        
        
        [self loadTableView];
        
        //添加
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView startAnimating];
        [loadingView addSubview:activityView];
        activityView.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));
        activityView.backgroundColor = [UIColor blackColor];
        activityView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [activityView release];
        [self addSubview:loadingView];
        loadingView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        //[loadingView release];
        
        [self adJustUI];
    }
    return self;
}

-(void)adJustUI
{
    if (isiPad()) {
        //ipad
        item1.center = CGPointMake(item1.center.x, 40);
        item2.center = CGPointMake(item2.center.x, 40);
        bg.frame = CGRectMake(0, 0, 1024, 80);
        photoScrollView.frame = CGRectMake(0, 80, 1024, 688);
        videoScrollView.frame = CGRectMake(0, 80, 1024, 688);
        loadingView.frame = CGRectMake(0, 0, 1024, 768);
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[loadingView.subviews objectAtIndex:0];
        activity.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));
        
    }else if (isiPhoneFourInch())
    {
        bg.frame = CGRectMake(0, 0, 568, 50);
        photoScrollView.frame = CGRectMake(0, 50, 568, 270);
        videoScrollView.frame = CGRectMake(0, 50, 568, 270);
        loadingView.frame = CGRectMake(0, 0, 568, 320);
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[loadingView.subviews objectAtIndex:0];
        activity.center = CGPointMake(CGRectGetMidX(loadingView.bounds), CGRectGetMidY(loadingView.bounds));
    }
}

-(void)loadTableView
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0] stringByAppendingFormat:@"/Movie"];
    
   
    if ([fileManager removeItemAtPath:path error:nil]) {
        NSLog(@"OK");
    }
    
//    如果不存在文件，则创建文件。
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"Create Director");
    }
    
    //显示
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto] || [[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypeVideo]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                    NSLog(@"url is %@",urlstr);
                    
                    
                    //NSRange range1=[urlstr rangeOfString:@"id="];
                    NSString *resultName=[urlstr substringFromIndex:0];
                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
                    NSLog(@"result name  is %@",resultName);
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                        UIImage *img1 = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                        [PhotoArray addObject:img];
                        [bigPhotoArray addObject:img1];
                    }else{
                        resultName=[urlstr stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];
                        
                        NSData *data = [self imageData:result];
                        NSString *pathName = [path stringByAppendingFormat:@"/%@",result.defaultRepresentation.filename];
                        if ([data writeToFile:pathName atomically:YES]) {
                            [VideoArray addObject:pathName];
                            UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                            [smallVideoPicArray addObject:img];
                        }
                    }
                }
                
            }else{
                CGFloat width = round(self.bounds.size.width/100);//ceil(x)返回不小于x的最小整数值（然后转换为double型）。
                //floor(x)返回不大于x的最大整数值。
                //round(x)返回x的四舍五入整数值。
                CGFloat xx = 0;
                CGFloat yy = 10;
                
                //加载数据
                int tempPhotoCount = [PhotoArray count]/width;
                if (isiPad()) {
                    if (tempPhotoCount > 7) {
                        photoScrollView.contentSize = CGSizeMake(1024, tempPhotoCount*(90)+10);
                    }
                    
                }
                else
                {
                    if (tempPhotoCount > 2) {
                        photoScrollView.contentSize = CGSizeMake(480, tempPhotoCount*(90)+10);
                    }
                    
                }
                for (int i=0; i<[PhotoArray count]; i++) {
                    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (xx>=width) {
                        xx = 1;
                        yy=yy+90;
                    }else{
                        xx++;
                    }
                    
                    abtn.frame = CGRectMake(10+(xx-1)*(80+15), yy, 80, 80);
                    abtn.layer.borderColor = [UIColor grayColor].CGColor;
                    abtn.layer.borderWidth = 1;
                    [abtn setImage:[PhotoArray objectAtIndex:i] forState:UIControlStateNormal];
                    [abtn addTarget:self action:@selector(btnActionTap:) forControlEvents:UIControlEventTouchUpInside];
                    abtn.tag = 10000+i;
                    [photoScrollView addSubview:abtn];
                }
//                if (yy > 260) {
//                    photoScrollView.contentSize = CGSizeMake(480, yy+105);
//                }
                
                
                xx = 0;
                yy = 10;
                int tempVideoCount = [smallVideoPicArray count]/width;
                
                if (isiPad()) {
                    if (tempVideoCount > 7) {
                        videoScrollView.contentSize = CGSizeMake(1024, tempVideoCount*(90)+10);
                    }

                }
                else
                {
                    if (tempVideoCount > 2) {
                        videoScrollView.contentSize = CGSizeMake(480, tempVideoCount*(90)+10);
                    }

                }
                for (int i=0; i<[smallVideoPicArray count]; i++) {
                    if (xx>=width) {
                        xx = 1;
                        yy=yy+90;
                    }else{
                        xx++;
                    }

                    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    abtn.frame = CGRectMake(10+(xx-1)*(80+15), yy, 80, 80);;
                    [abtn setImage:[smallVideoPicArray objectAtIndex:i] forState:UIControlStateNormal];
                    [abtn addTarget:self action:@selector(btnActionTap:) forControlEvents:UIControlEventTouchUpInside];
                    abtn.tag = 20000+i;
                    [videoScrollView addSubview:abtn];
                }
                
                
                [self ListVideoPhotoButton];
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group == nil)
            {
                [loadingView removeFromSuperview];
            }
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;//省略前边的16个字符。
                NSLog(@"g1  is %@",g1);
                NSArray *arr=[NSArray arrayWithArray:[g1 componentsSeparatedByString:@","]];//以，号进行分割。
                NSString *g2=[[arr objectAtIndex:0]substringFromIndex:5];//arr第一个数组5个字符以后。
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    //g2=@"相机胶卷";
                }
                NSString *groupName=g2;//组的name
//                NSLog(@"name=%@",groupName);
                if ([groupName isEqualToString:@"视屏"]) {
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];//往相册里加载数据，运行上一行的ALAssetsGroupEnumerationResultsBlock这个函数。
                }
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        [library release];
        [pool release];
    });

}

//改变图片的大小。
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



//显示相片
-(void)ListVideoPhotoButton
{
//    Engine *engine = [Engine sharedInstance];
//    if (engine.isPhotoVideo) {
//        NSLog(@"photo");
//    }else{
//        NSLog(@"video");
//    }
    
    if (isPhotoVideo) {
        NSLog(@"photo");
    }else{
        NSLog(@"video");
    }
}
-(void)BackBtnAction:(UIButton *)sender
{
    if (sender.tag == 1000) {
        
        [UIView animateWithDuration:0.5 animations:^(void){
            movieView.center = CGPointMake(1500, CGRectGetMidY(self.bounds));
        }completion:^(BOOL finished){
            [movieView removeFromSuperview];
        }];
    }
}

-(void)btnActionTap:(UIButton *)sender
{
   
    CGRect rect;
    if (isiPad()) {
        rect = CGRectMake(0, 0, 1024, 768);
    }else if (isiPhoneFourInch())
    {
        rect = CGRectMake(0, 0, 568, 320);
    }else{
        rect = CGRectMake(0, 0, 480, 320);
    }
    movieView = [[UIView alloc] initWithFrame:rect];
    movieView.center = CGPointMake(1500, CGRectGetMidY(self.bounds));
    movieView.backgroundColor = [UIColor blackColor];
    [self addSubview:movieView];
    [movieView release];
    UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(movieView.bounds), (isiPad()?80:40))];
    barView.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:46.0f/255.0f blue:47.0f/255.0f alpha:1];
    barView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    UIImage *image = [UIImage imageNamed:getImageName(@"fhd")];
    UIImage *image = [UIImage imageNamed:@"fhd.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(30, 5, image.size.width, image.size.height);
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 1000;
    [barView addSubview:backBtn];
    [movieView insertSubview:barView atIndex:1];
    [barView release];

//    Engine *engine = [Engine sharedInstance];
    
//    if (engine.isPhotoVideo) {
    if (isPhotoVideo) {
    
            if (sender.tag>=10000 && sender.tag<=19999) {
                [self showImage:sender.tag];
            }

    }else{
        if (sender.tag>=20000 && sender.tag<=29999) {
            [self PlayMovie:[VideoArray objectAtIndex:sender.tag-20000]];
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

#pragma mark -
#pragma mark Play Movie
-(void)PlayMovie:(NSString *)filename
{
    CGRect rect;
    if (isiPad()) {
        rect = CGRectMake(0, 0, 768, 1024);
    }else if (isiPhoneFourInch())
    {
        rect = CGRectMake(0, 0, 320, 568);
    }else{
        rect = CGRectMake(0, 0, 320, 480);
    }
    
    UIView* PlayMovieView = [[UIView alloc] initWithFrame:rect];
    PlayMovieView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filename];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = rect;
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [PlayMovieView.layer addSublayer:playerLayer];
    
    PlayMovieView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [movieView insertSubview:PlayMovieView atIndex:0];
    [PlayMovieView release];
}

//显示图片
-(void)showImage:(int)tag
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
    [bg2 release];
}

//读取视频
- (NSData *)imageData:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    NSUInteger size = (NSUInteger )[assetRep size];
    uint8_t *buff = malloc(size);
    
    NSError *err = nil;
    NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
    
    if (gotByteCount) {
        if (err) {
            NSLog(@"!!! Error reading asset: %@", [err localizedDescription]);
            [err release];
            free(buff);
            return nil;
        }
    }
    NSLog(@"%d,%s,%d",size,buff,gotByteCount)
    ;
    
    return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}



@end












