//
//  CamController.h
//  iConGolf
//
//  Created by TempUser on 13-4-1.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <ImageIO/ImageIO.h>

@interface CamController : UIView<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate,UIImagePickerControllerDelegate>
{
    AVCaptureMovieFileOutput *aMovieFileOut;
    AVCaptureSession *session;
    ////////
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *output;
    AVCaptureStillImageOutput* stillImageOutput;
    //
    UIImage *image;
    //
    AVCaptureVideoPreviewLayer* preLayer1;
    
    UIImageOrientation imageorientation;
    AVCaptureVideoOrientation avcapturevideoorientation;
}
-(void)startRecord;
-(void)stopRecord;
-(void)exitVideo;

-(void)Captureimage;

- (void)setupCaptureSession;
-(void)setupPhotoSession;

-(void)removeDevice;

-(void)changeRotateScreen:(BOOL)type;
-(void)changeVRotateScreen:(BOOL)type;
@end
