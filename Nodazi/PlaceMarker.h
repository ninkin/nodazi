//
//  PlaceMarker.h
//  Nodazi
//
//  Created by STCube1 on 11. 6. 14..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface PlaceMarker : NSObject <MKAnnotation>{

    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    
}
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *subtitle;

@end
