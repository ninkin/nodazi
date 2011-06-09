//
//  ScanButton.m
//  Nodazi
//
//  Created by 예성 김 on 11. 5. 29..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "ScanButton.h"


@implementation ScanButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Set button image:
        UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        buttonImage.image = [UIImage imageNamed:@"Wrench-48.png"];
        
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside]; // for future use
        
        [self addSubview:buttonImage];
    }
    return self;
}

- (void)buttonPressed {
    // TODO: Could toggle a button state and/or image
    
}

@end
