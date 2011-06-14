//
//  FirstViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "FirstViewController.h"

#import "NodaziAppDelegate.h"
#import "OverlayView.h"

#import "baseapi.h"
#import "UIImage+Resize.h"
#import <math.h>



@implementation FirstViewController

@synthesize thumbImageView, outputString, outputView;

@synthesize captureSession = _captureSession;
@synthesize customLayer = _customLayer;
@synthesize imageView = _imageView;
//@synthesize prevLayer = _prevLayer;

NSLock *myLock = nil;

#pragma mark -
#pragma mark Initialization
- (id)init {
	self = [super init];
	if (self) {
		/*We initialize some variables (they might be not initialized depending on what is commented or not)*/
		self.imageView = nil;
		//self.prevLayer = nil;
		self.customLayer = nil;
        bShowScreen = false;
        bCaptureReceipt = false;
        outCaptureReceipt = 0;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myLock = [[NSLock alloc] init];
    
    
    
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath])
    {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata-svn"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    /*
    NSDirectoryEnumerator *directoryEnum;
    NSString* str;
    
    directoryEnum = [fileManager enumeratorAtPath: 
                     [[NSBundle mainBundle] bundlePath]];
    
    while ((str = [directoryEnum nextObject]) != nil) {
        NSDictionary *dic = [fileManager attributesOfItemAtPath:str error:NULL];
        
        NSLog(@"%@: %@, %@byte, %@", str, 
              [dic objectForKey: NSFileType], 
              [dic objectForKey: NSFileSize], 
              [dic objectForKey: NSFileOwnerAccountName]);
    }
    */
    
    NSString *dataPathWithSlash = [[self applicationDocumentsDirectory] stringByAppendingString:@"/"];
    setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
    
    // init the tesseract engine.
    tess = new TessBaseAPI();
    tess->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding],    
               "eng"); 

    
    bCapture = false;
    bThreadRun = false;
    nViewTag = 0;
    
    [self initCapture];
    /*
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handleTimer:)
                                           userInfo: nil repeats: YES];*/
}

- (NSString *)applicationDocumentsDirectory 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
    
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);
    
	return ret;
}

- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    /*
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);*/
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
	self.customLayer = nil;
	//self.prevLayer = nil;
}


- (void)dealloc
{
    [super dealloc];
    tess->End();
    [thumbImageView release];
    [super dealloc];
}

- (void) viewDidAppear:(BOOL)animated {
    [myLock lock];
    [activityView stopAnimating];
    bCaptureReceipt = false;
    outCaptureReceipt = 0;
    bShowScreen = true;
    bCapture = false;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(handleTimer:)
                                           userInfo: nil repeats: YES];
    [myLock unlock];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [myLock lock];
    bCaptureReceipt = false;
    outCaptureReceipt = 0;
    bShowScreen = false;
    bCapture = true;
    
    [timer invalidate];
    timer = nil;
    [myLock unlock];
}

- (IBAction) receiptClick {
    [self takepicture];
}

- (IBAction) tagClick {
    [self takepicture];
}

- (void) takepicture {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        /*
        OverlayView *overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setDelegate:self];
        
        picker.cameraOverlayView = overlay;
        //[picker allowsEditing]; 
        
        overlay.take = picker;
        
        // allowing editing is nice, but only returns a small 320px image
        //[picker setAllowsImageEditing:YES]; 
        //[picker allowsEditing];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        */
        
		OverlayView *overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        
        // Create a new image picker instance:
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // Set the image picker source:
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Hide the controls:
        picker.showsCameraControls = NO;
        picker.navigationBarHidden = NO;
        
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
        
        picker.delegate = self; 
        
        // Insert the overlay:
        picker.cameraOverlayView = overlay;        
        overlay.take = picker;
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
	}
}

- (void) takereceipt
{
    //[self.captureSession release];
    /*
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];*/
    outCaptureReceipt = 0;
    bCaptureReceipt = true;
    [activityView startAnimating];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Picker has returned");
    [self dismissModalViewControllerAnimated:YES];
    
    // process the selected image:
    [activityView startAnimating];
    
    // send the edited image to the thumbnail view:
    UIImage *thumbImage = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    
    // set the thumbnail image:    
    [thumbImageView setImage:thumbImage];
    [thumbImage release];
    
    // zoom the thumbnail
    [thumbImageView zoomImageToCenter];
    
    // TODO: make this all threaded?
    // crop the image to the bounds provided
    UIImage *origImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];    
    NSLog(@"orig image size: %@", [[NSValue valueWithCGSize:origImage.size] description]);
    
    // save the image, only if it's a newly taken image:
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(origImage, nil, nil, nil); 
    }
    
    CGRect rect;
    [[info objectForKey:UIImagePickerControllerCropRect] getValue:&rect];
    
    // fake resize to get the orientation right
    
    //UIImage *croppedImage= [origImage resizedImage:origImage.size interpolationQuality:kCGInterpolationDefault];
    //[origImage release];
    UIImage *croppedImage = origImage;
    
    // crop, but maintain original size:
    //croppedImage = [croppedImage croppedImage:rect];
    NSLog(@"cropped image size: %@", [[NSValue valueWithCGSize:croppedImage.size] description]);
    
    // for testing.
    //[self.view addSubview:[[UIImageView alloc] initWithImage:image]];
    
    // resize, so as to not choke tesseract:
    // scaling up a low resolution image (eg. screenshots) seems to help the recognition.
    // 1200 pixels is an arbitrary value, but seems to work well.
    CGFloat newWidth = 1200; //(1000 < croppedImage.size.width) ? 1000 : croppedImage.size.width;
    CGSize newSize = CGSizeMake(newWidth,newWidth);
    
    croppedImage = [croppedImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    NSLog(@"resized image size: %@", [[NSValue valueWithCGSize:croppedImage.size] description]);
    
    //for debugging:
    //    [thumbImageView setImage:croppedImage];
     
    // process image, threaded:
    [self performSelector:@selector(threadedReadAndProcessImage:) withObject:croppedImage afterDelay:0.01];
}

// preferred, threaded method:
- (void)threadedReadAndProcessImage:(UIImage *)uiImage 
{
    NSLog(@"tesseract start");
    
    [myLock lock];
    bThreadRun = true;
    [myLock unlock];
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    CGSize imageSize = [uiImage size];
    int bytes_per_line  = (int)CGImageGetBytesPerRow([uiImage CGImage]);
    int bytes_per_pixel = (int)CGImageGetBitsPerPixel([uiImage CGImage]) / 8.0;
    
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([uiImage CGImage]));
    const UInt8 *imageData = CFDataGetBytePtr(data);
    
    // this could take a while.
    char* text = tess->TesseractRect(imageData,
                                     bytes_per_pixel,
                                     bytes_per_line,
                                     0, 0,
                                     imageSize.width, imageSize.height);
    
    
    NSString * outputText = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    [self setOutputString:outputText];
    NSLog(@"tesseract out: %@", outputText);
    
    delete[] text;
    CFRelease(data);
    
    // Check to Price
    NSArray * prices = [outputText componentsSeparatedByString:@"\n"];
    
    nViewTag = 0;
    for (NSString *string in prices)
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSRange range = [string rangeOfString:@"4.20"];
        if (range.length != 0)
            nViewTag = 1;
        
        range = [string rangeOfString:@"4_2"];
        if (range.length != 0)
            nViewTag = 1;
        
        range = [string rangeOfString:@"20"];
        if (range.length != 0)
            nViewTag = 1;
        
        range = [string rangeOfString:@"99"];
        if (range.length != 0)
            nViewTag = 2;
        
        range = [string rangeOfString:@"3_9"];
        if (range.length != 0)
            nViewTag = 2;
        
        range = [string rangeOfString:@"1,023"];
        if (range.length != 0)
            nViewTag = 3;
        
        //NSLog(@"out data by line:%@", string);
        
        range = [string rangeOfString:@"hoco"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 1;
        
        range = [string rangeOfString:@"8"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 1;
        
        range = [string rangeOfString:@"ilk"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 1;
        
        range = [string rangeOfString:@"10"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 2;
        
        range = [string rangeOfString:@"oup"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 2;
        
        range = [string rangeOfString:@"aga"];
        if (range.length != 0 && bCaptureReceipt == true)
            outCaptureReceipt = 2;
        
        /*
        if (bCaptureReceipt == true)
            outCaptureReceipt = 1;*/
    }
    
    
    // Update the display text. Since we're in a threaded method, run the UI stuff on the main thread.
    //[self performSelectorOnMainThread:@selector(updateTextDisplay) withObject:nil waitUntilDone:NO];
    
    [pool release];
    
    [myLock lock];
    if (outCaptureReceipt == 0)
        bCapture = false;
    bThreadRun = false;
    //bCapture = false;
    [myLock unlock];
}

-(void)updateTextDisplay;
{
    [activityView stopAnimating];
    
    [outputView setText:outputString]; 
    
    [thumbImageView shrinkToThumbnail];
}

-  (void)initCapture {
	/*We setup the input*/
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput 
										  deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] 
										  error:nil];
	/*We setupt the output*/
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	/*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
	 If you don't want this behaviour set the property to NO */
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 
	/*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
	 in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
	 In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
	 we are not able to process more than 10 frames per second.*/
	//captureOutput.minFrameDuration = CMTimeMake(1, 10);
	
	/*We create a serial queue to handle the processing of our frames*/
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
	// Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[captureOutput setVideoSettings:videoSettings]; 
	/*And we create a capture session*/
	self.captureSession = [[AVCaptureSession alloc] init];
	/*We add input and output*/
	[self.captureSession addInput:captureInput];
	[self.captureSession addOutput:captureOutput];
	/*We start the capture*/
	[self.captureSession startRunning];
	/*We add the Custom Layer (We need to change the orientation of the layer so that the video is displayed correctly)*/
	self.customLayer = [CALayer layer];
	self.customLayer.frame = self.view.bounds;
	self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
	self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
	[self.view.layer addSublayer:self.customLayer];
	/*We add the imageView*/
	self.imageView = [[UIImageView alloc] init];
	self.imageView.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:self.imageView];
	/*We add the preview layer*/
	//self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
	//self.prevLayer.frame = CGRectMake(100, 0, 100, 100);
	//self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	//[self.view.layer addSublayer: self.prevLayer];
    
    
    
    scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [scanButton setFrame:CGRectMake(35, 170, 250, 100)];
    [scanButton setTitle:@"Touch to take a receipt\nor\nFocus on the price tag" forState:UIControlStateNormal];
    [scanButton setOpaque:TRUE];
    [scanButton setAlpha:0.4];
    [scanButton setBackgroundColor:[UIColor whiteColor]];
    [scanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    scanButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    scanButton.titleLabel.textAlignment = UITextAlignmentCenter;
    scanButton.titleLabel.numberOfLines = 3;
    
    // Add a target action for the button:
    [scanButton addTarget:self action:@selector(takereceipt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 480, 150)];
    [tagLabel setFrame:CGRectMake(35, 180, 240, 100)];
    [tagLabel setText:@"The nearby market\nin 1 Km"];
    [tagLabel setOpaque:TRUE];
    [tagLabel setAlpha:0.0];
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.font = [UIFont fontWithName:@"Courier" size: 20.0];
    [tagLabel setTextColor:[UIColor magentaColor]];
    tagLabel.lineBreakMode = UILineBreakModeWordWrap;
    tagLabel.textAlignment = UITextAlignmentCenter;
    tagLabel.numberOfLines = 3;
    [self.view addSubview:tagLabel];
    
    tagLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 480, 150)];
    [tagLabel2 setFrame:CGRectMake(50, 100, 240, 100)];
    [tagLabel2 setText:@"$ 3.99"];
    [tagLabel2 setOpaque:TRUE];
    [tagLabel2 setAlpha:0.0];
    tagLabel2.backgroundColor = [UIColor clearColor];
    tagLabel2.font = [UIFont fontWithName:@"Courier" size: 50.0];
    [tagLabel2 setTextColor:[UIColor redColor]];
    tagLabel2.lineBreakMode = UILineBreakModeWordWrap;
    tagLabel2.textAlignment = UITextAlignmentCenter;
    tagLabel2.numberOfLines = 3;
    [self.view addSubview:tagLabel2];
    
    tagLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 480, 150)];
    [tagLabel4 setFrame:CGRectMake(45, 100, 250, 100)];
    [tagLabel4 setText:@"$ 1,000"];
    [tagLabel4 setOpaque:TRUE];
    [tagLabel4 setAlpha:0.0];
    tagLabel4.backgroundColor = [UIColor clearColor];
    tagLabel4.font = [UIFont fontWithName:@"Courier" size: 50.0];
    [tagLabel4 setTextColor:[UIColor redColor]];
    tagLabel4.lineBreakMode = UILineBreakModeWordWrap;
    tagLabel4.textAlignment = UITextAlignmentCenter;
    tagLabel4.numberOfLines = 3;
    [self.view addSubview:tagLabel4];
    
    tagLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 480, 150)];
    [tagLabel3 setFrame:CGRectMake(35, 170, 250, 100)];
    [tagLabel3 setText:@"OK! It is the lowest price!"];
    [tagLabel3 setOpaque:TRUE];
    [tagLabel3 setAlpha:0.0];
    tagLabel3.backgroundColor = [UIColor clearColor];
    tagLabel3.font = [UIFont fontWithName:@"Courier" size: 20.0];
    [tagLabel3 setTextColor:[UIColor blueColor]];
    tagLabel3.lineBreakMode = UILineBreakModeWordWrap;
    tagLabel3.textAlignment = UITextAlignmentCenter;
    tagLabel3.numberOfLines = 3;
    [self.view addSubview:tagLabel3];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = self.view.center;
    activityView.hidesWhenStopped = YES;
    [self.view addSubview:activityView];
}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{ 
    if (bShowScreen == false)
        return;
    
	/*We create an autorelease pool because as we are not in the main_queue our code is
	 not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0); 
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer);  
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    if (nViewTag == 1 || nViewTag == 3)
    {
        CGContextSetStrokeColorWithColor(newContext, [UIColor redColor].CGColor);
        CGContextMoveToPoint(newContext, 0, 0); 
        CGContextAddLineToPoint(newContext, width, height); 
        CGContextMoveToPoint(newContext, width, 0); 
        CGContextAddLineToPoint(newContext, 0, height); 
        CGContextStrokePath(newContext);
    }
    
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);

	
    /*We release some components*/
    CGContextRelease(newContext); 
    CGColorSpaceRelease(colorSpace);
    
    /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (id) newImage waitUntilDone:YES];
	
	/*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	 Same thing as for the CALayer we are not in the main thread so ...*/
	UIImage *imageSrc = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
   
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	//[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    [myLock lock];
    if (bCapture == false && bThreadRun == false)
    {
        bCapture = true;
        
        int threshold = 64;
        int imagesize = 250;
        if (bCaptureReceipt == true)
        {
            threshold = 140;
            imagesize = 1200;
        }
        
        UIImage *croppedImage = imageSrc;
        
        // crop, but maintain original size:
        //croppedImage = [croppedImage croppedImage:rect];
        //NSLog(@"cropped image size: %@", [[NSValue valueWithCGSize:croppedImage.size] description]);
        
        // for testing.
        //[self.view addSubview:[[UIImageView alloc] initWithImage:image]];
        
        // resize, so as to not choke tesseract:
        // scaling up a low resolution image (eg. screenshots) seems to help the recognition.
        // 1200 pixels is an arbitrary value, but seems to work well.
        CGFloat newWidth = imagesize; //(1000 < croppedImage.size.width) ? 1000 : croppedImage.size.width;
        CGSize newSize = CGSizeMake(newWidth,newWidth);
        
        croppedImage = [croppedImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
        //NSLog(@"resized image size: %@", [[NSValue valueWithCGSize:croppedImage.size] description]);
        
        
        cvSetErrMode(CV_ErrModeParent);
        
        UIImage * uiImage = croppedImage;
        
		// Create grayscale IplImage from UIImage
		IplImage *img_color = [self CreateIplImageFromUIImage: uiImage];
		IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 1);
		cvCvtColor(img_color, img, CV_BGR2GRAY);
		cvReleaseImage(&img_color);
        
		// Apply Threshold
		IplImage *img2 = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);
        cvThreshold(img, img2, threshold, 255, CV_THRESH_BINARY);
        
        //cvCanny(img, img2, 64, 128, 3);
		cvReleaseImage(&img);
		
		// Convert black and whilte to 24bit image then convert to UIImage to show
		IplImage *image = cvCreateImage(cvGetSize(img2), IPL_DEPTH_8U, 3);
		for(int y=0; y<img2->height; y++) {
			for(int x=0; x<img2->width; x++) {
				char *p = image->imageData + y * image->widthStep + x * 3;
				*p = *(p+1) = *(p+2) = img2->imageData[y * img2->widthStep + x];
			}
		}
		cvReleaseImage(&img2);
		uiImage = [self UIImageFromIplImage:image];
		cvReleaseImage(&image);        
        
        //[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:uiImage waitUntilDone:YES];
        
        //[self performSelectorOnMainThread:@selector(threadedReadAndProcessImage:) withObject:croppedImage waitUntilDone:NO];
        //[self performSelector:@selector(threadedReadAndProcessImage:) withObject:croppedImage afterDelay:0.01];
        [NSThread detachNewThreadSelector:@selector(threadedReadAndProcessImage:) toTarget:self withObject:uiImage];
	}
    [myLock unlock];
	
	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
	[pool drain];
}

- (void) handleTimer: (NSTimer *) timer
{
    /*
    [myLock lock];
    bCapture = false;
    [myLock unlock];
    */
    
    if (bCaptureReceipt == true)
    {
        [scanButton setAlpha:0];
    }
    else
    {
        if (nViewTag == 1)
        {
            [scanButton setAlpha:0];
            [tagLabel setAlpha:0.8];
            [tagLabel2 setAlpha:0.8];
            [tagLabel3 setAlpha:0];
            [tagLabel4 setAlpha:0];
        }
        else if (nViewTag == 2)
        {
            [scanButton setAlpha:0.0];
            [tagLabel setAlpha:0.0];
            [tagLabel2 setAlpha:0.0];
            [tagLabel3 setAlpha:0.8];
            [tagLabel4 setAlpha:0];
        }
        else if (nViewTag == 3)
        {
            [scanButton setAlpha:0.0];
            [tagLabel setAlpha:0.8];
            [tagLabel2 setAlpha:0.0];
            [tagLabel3 setAlpha:0.0];
            [tagLabel4 setAlpha:0.8];
        }
        else if (nViewTag == 0)
        {
            [scanButton setAlpha:0.4];
            [tagLabel setAlpha:0.0];
            [tagLabel2 setAlpha:0.0];
            [tagLabel3 setAlpha:0];
            [tagLabel4 setAlpha:0];
        }
    }
    
    if (outCaptureReceipt == 1 || outCaptureReceipt == 2)
    {
        NSLog(@"asdf");
        (((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate])).nReceiptType = outCaptureReceipt;
        [NSThread detachNewThreadSelector:@selector(CheckCompleted) toTarget:self withObject:nil];
        //self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }
}

- (void) setTabBarIndex:(NSNumber *)index
{
    self.tabBarController.selectedIndex = index.intValue;
}

-(void)CheckCompleted
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self performSelectorOnMainThread:@selector(setTabBarIndex:) withObject:[NSNumber numberWithInt:2] waitUntilDone:YES];
    
    [pool release];
}

@end
