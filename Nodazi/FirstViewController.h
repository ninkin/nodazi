//
//  FirstViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "ZoomableImage.h"

// conditionally import or forward declare to contain objective-c++ code to here.
#ifdef __cplusplus
#import "baseapi.h"
using namespace tesseract;
#else
@class TessBaseAPI;
#endif

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412 //use this is for iOS 3.x
#define CAMERA_TRANSFORM_Y 1.24299 // use this is for iOS 4.x

// iPhone screen dimensions:
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@interface FirstViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIActivityIndicatorView *activityView;
    IBOutlet ZoomableImage    *thumbImageView;
    NSString *outputString;
    TessBaseAPI *tess;
    IBOutlet UITextView *outputView;
    
    AVCaptureSession *_captureSession;
	UIImageView *_imageView;
	CALayer *_customLayer;
	//AVCaptureVideoPreviewLayer *_prevLayer;
    
    bool bCapture;
    bool bThreadRun;
    NSTimer *timer; 
    
    bool bViewTag;
    UIButton * scanButton;
    UIButton * tagButton;
    UILabel * tagLabel;
    UILabel * tagLabel2;
    
    bool bShowScreen;
}

@property(nonatomic,retain)IBOutlet UITextView *outputView;
@property(nonatomic,retain)IBOutlet ZoomableImage *thumbImageView;
@property(nonatomic,retain)NSString *outputString;

- (NSString *)applicationDocumentsDirectory;
- (void)threadedReadAndProcessImage:(UIImage *)uiImage;
-(void)updateTextDisplay;

- (IBAction) receiptClick;
- (IBAction) tagClick;
- (void) takepicture;


/*!
 @brief	The capture session takes the input from the camera and capture it
 */
@property (nonatomic, retain) AVCaptureSession *captureSession;

/*!
 @brief	The UIImageView we use to display the image generated from the imageBuffer
 */
@property (nonatomic, retain) UIImageView *imageView;
/*!
 @brief	The CALayer we use to display the CGImageRef generated from the imageBuffer
 */
@property (nonatomic, retain) CALayer *customLayer;
/*!
 @brief	The CALAyer customized by apple to display the video corresponding to a capture session
 */
//@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;

/*!
 @brief	This method initializes the capture session
 */
- (void)initCapture;

- (void)takereceipt;

@end
