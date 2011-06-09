//
//  OverlayView.h
//  Nodazi
//
//  Created by 예성 김 on 11. 5. 29..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverlayView : UIView {
    UIImagePickerController * take;
}

- (void)scanButtonTouchUpInside;
- (void)clearLabel:(UILabel *)label;

@property (nonatomic, retain) UIImagePickerController * take;

@end
