//
//  CamController.m
//  iConGolf
//
//  Created by TempUser on 13-4-1.
//
//

#import "CamController.h"

#define TEMP_MOVE_NAME @"TEMP_FILE.MOV"

@implementation CamController

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        imageorientation = UIImageOrientationDown;
        [self initCaptureSession];
        [self setupPhotoSession];

    }
    
    return self;
}

-(void)removeDevice
{
    [session removeOutput:aMovieFileOut];
    [session removeOutput:stillImageOutput];
    [session removeOutput:output];
}

//初始化
-(void)initCaptureSession
{
    
    CGFloat screenW,screenH;
    screenW = CGRectGetWidth(self.bounds);
    screenH = CGRectGetHeight(self.bounds);
    
    NSError *error = nil;
    // Create the session
    session = [[[AVCaptureSession alloc] init] autorelease];
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头,
    
    if ([device position] == AVCaptureDevicePositionBack) {
        NSLog(@"开启后闪光灯");
    }
    else
    {
        NSLog(@"开启前闪光灯");
    }
    //闪光灯[device hasTorch]
    // Create a device input with the device and add it to the session.
    input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                  error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    
    // Create a VideoDataOutput and add it to the session
    output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    output.alwaysDiscardsLateVideoFrames = YES;
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    [session setSessionPreset:AVCaptureSessionPresetMedium];//中等像素
    
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                            [NSNumber numberWithInt: screenW], (id)kCVPixelBufferWidthKey,
                            [NSNumber numberWithInt: screenH], (id)kCVPixelBufferHeightKey,
                            nil];
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //output.minFrameDuration = CMTimeMake(1, 15);
    
    preLayer1 = [AVCaptureVideoPreviewLayer layerWithSession: session];
    preLayer1.frame = CGRectMake(0, 0, screenW, screenH);
    preLayer1.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [preLayer1 setOrientation:AVCaptureVideoOrientationLandscapeLeft];
//    preLayer1.orientation = AVCaptureVideoOrientationLandscapeLeft;//控制视频拍摄方向。
    [self.layer addSublayer:preLayer1];
    // Start the session running to start the flow of data
    [session startRunning];
    avcapturevideoorientation = AVCaptureVideoOrientationLandscapeLeft;
}

//转屏
-(void)changeRotateScreen:(BOOL)type
{
    if (type) {
        preLayer1.orientation = AVCaptureVideoOrientationLandscapeLeft;
        imageorientation = UIImageOrientationDown;
        avcapturevideoorientation = AVCaptureVideoOrientationLandscapeLeft;
    }else{
        preLayer1.orientation = AVCaptureVideoOrientationLandscapeRight;
        imageorientation = UIImageOrientationUp;
        avcapturevideoorientation = AVCaptureVideoOrientationLandscapeRight;
    }
}

//竖屏转屏
-(void)changeVRotateScreen:(BOOL)type
{
    if (type) {
        preLayer1.orientation = AVCaptureVideoOrientationPortrait;
        imageorientation = UIImageOrientationRight;
        avcapturevideoorientation = AVCaptureVideoOrientationPortrait;
    }else{
        preLayer1.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        avcapturevideoorientation = AVCaptureVideoOrientationPortraitUpsideDown;
        imageorientation = UIImageOrientationLeft;
    }
}

//拍照
-(void)setupPhotoSession
{
    [self startanimate];
    //相机
    stillImageOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [outputSettings release];
    
    //照相
    [session beginConfiguration];
    [session removeOutput:aMovieFileOut];
    [session addOutput:stillImageOutput];
    [session commitConfiguration];
    
}

//照相获取照片
-(void)Captureimage
{
    [self startanimate];
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [[UIImage alloc] initWithData:imageData] ;
         image = [[[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:imageorientation] autorelease];
         
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         //保存照片到相册
         [library writeImageToSavedPhotosAlbum:[image CGImage]
                                   orientation:(ALAssetOrientation)[image imageOrientation]
                               completionBlock:^(NSURL *assetURL, NSError *error){
//                                   NSLog(@"assetURL   is  %@",assetURL);
                                   if (error) {
                                       //NSLog(@"Eror");
                                   }else{
                                       //NSLog(@"finished");
                                   }
                               }];
         
         
         [t_image release];
         //为了下面的存照片时的错误处理。
         void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
             if (error) {
                 //NSLog(@"!!!ERROR,  write the image data to the assets library (camera roll): %@",
                 //[error description]);
             }else{
                 //#if 0
                 //NSLog(@"finished");
             }
             //#endif
         };
         [library saveImage:image toAlbum:@"视屏" completionBlock:completionBlock failureBlock:nil];//添加相片到iConGolf这个相册里面。
         

     }];
}

//摄像
- (void)setupCaptureSession
{

    avcapturevideoorientation = AVCaptureVideoOrientationPortraitUpsideDown;
    [self startanimate];
    //录制视频
    aMovieFileOut = [[[AVCaptureMovieFileOutput alloc] init] autorelease];
    aMovieFileOut.maxRecordedDuration = CMTimeMake(3600, 1);//3600表示当前第3600帧，1表示每秒钟为1帧
    aMovieFileOut.minFreeDiskSpaceLimit = 1024 * 1024 * 1024;
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[aMovieFileOut connections]];
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:avcapturevideoorientation];
         NSLog(@"avcapturevideoorientation   %ld",avcapturevideoorientation);
    }
   
    [session beginConfiguration];
    [session removeOutput:stillImageOutput];
    [session addOutput:aMovieFileOut];
    [session commitConfiguration];
    
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

- (NSURL *) tempFileURL {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"destinationPath   %@",destinationPath);
    [dateFormatter release];
    
    return [NSURL fileURLWithPath:destinationPath];
}

-(void)startRecord
{
    NSURL *outputFileUrl = [self tempFileURL];
    [aMovieFileOut startRecordingToOutputFileURL:outputFileUrl recordingDelegate:self];
}

-(void)stopRecord
{
    [aMovieFileOut stopRecording];
}

-(void)exitVideo
{
    
}

//这个是在摄像开启时运行的
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    //#if 0
    //NSLog(@"Start");
    //#endif
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    ALAssetsLibrary *alassetslibrary = [[ALAssetsLibrary alloc] init];
    
    // The completion block to be executed after image taking action process done
    void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
        if (error) {
            //NSLog(@"!!!ERROR,  write the image data to the assets library (camera roll): %@",
                  //[error description]);
        }else{
            //#if 0
            //NSLog(@"finished");
        }
        //#endif
    };
    
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        if (error == nil) return;
        //NSLog(@"!!!ERROR, failed to add the asset to the custom photo album: %@", [error description]);
    };
    [alassetslibrary saveVideo:outputFileURL toAlbum:@"视屏" completionBlock:completionBlock failureBlock:failureBlock];//创建相册并添加video
    [alassetslibrary release];
    
}

-(void)startanimate
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFilterLinear;
    animation.type = @"cameraIris";
    [self.window.rootViewController.view.layer addAnimation:animation forKey:@"animation"];
}


@end
