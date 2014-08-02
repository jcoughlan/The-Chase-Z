//
//  UIViewController+MapViewController.h
//  Chase Z
//
//  Created by James Coughlan on 30/07/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZombieHandler.h"
#import "ZombieAnnotation.h"
@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    BOOL m_receivedInitialLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) ZombieHandler* zombieHandler;

@end
