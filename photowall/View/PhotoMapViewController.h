//
//  PhotoMapViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class UserManager;
@class PhotoManager;

@interface PhotoMapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) UIViewController* rootViewController;

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@property (weak, nonatomic) UserManager* userManager;
@property (weak, nonatomic) PhotoManager* photoManager;

@end
