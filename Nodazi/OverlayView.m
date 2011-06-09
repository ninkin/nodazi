//
//  OverlayView.m
//  Nodazi
//
//  Created by 예성 김 on 11. 5. 29..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "OverlayView.h"
#import "ScanButton.h"

@implementation OverlayView

@synthesize take;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Clear the background of the overlay:
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        // Load the image to show in the overlay:
        /*
        UIImage *overlayGraphic = [UIImage imageNamed:@"Book-48.png"];
        UIImageView *overlayGraphicView = [[UIImageView alloc] initWithImage:overlayGraphic];
        overlayGraphicView.frame = CGRectMake(30, 100, 260, 200);
        [self addSubview:overlayGraphicView];
        [overlayGraphicView release];
        */
        
        //ScanButton *scanButton = [[ScanButton alloc] initWithFrame:CGRectMake(130, 320, 60, 30)];
        
        //UIButton * scanButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 320, 130, 30)];
        UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [scanButton setFrame:CGRectMake(85, 200, 150, 80)];
        [scanButton setTitle:@"Press to\ntake a picture" forState:UIControlStateNormal];
        [scanButton setOpaque:TRUE];
        [scanButton setAlpha:0.5];
        [scanButton setBackgroundColor:[UIColor whiteColor]];
        [scanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        scanButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        scanButton.titleLabel.textAlignment = UITextAlignmentCenter;
        scanButton.titleLabel.numberOfLines = 2;
        
        // Add a target action for the button:
        [scanButton addTarget:self action:@selector(scanButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:scanButton];
    }
    return self;
}

- (void) scanButtonTouchUpInside {
    /*
    UILabel *scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    scanningLabel.backgroundColor = [UIColor clearColor];
    scanningLabel.font = [UIFont fontWithName:@"Courier" size: 18.0];
    scanningLabel.textColor = [UIColor redColor];
    scanningLabel.text = @"Scanning...";
    
    [self addSubview:scanningLabel];
    
    [self performSelector:@selector(clearLabel:) withObject:scanningLabel afterDelay:2];
    
    [scanningLabel release];
     */
    [take takePicture];
}

- (void)clearLabel:(UILabel *)label {
    label.text = @"";
}

@end
