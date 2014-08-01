//
//  UIViewController+MapViewController.m
//  Chase Z
//
//  Created by James Coughlan on 30/07/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize locationManager;
- (void)viewDidLoad
{
    m_receivedInitialLocation = NO;
    
    if(self.locationManager==nil){
        
        self.locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        self.locationManager.delegate=self;
        //  self.locationManager.purpose = @"We will try to tell you where you are if you get lost";
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=1;
    }
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
        NSLog(@"Location updates started");
    }
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.zombieHandler = [[ZombieHandler alloc] initWithView:nil];
    
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   // [self.mapView.userLocation setCoordinate:newLocation.coordinate];
    NSLog(@"Updated User Location");
    if (!m_receivedInitialLocation)
    {
        m_receivedInitialLocation = YES;
        MKUserLocation* userLocation = self.mapView.userLocation;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20, 20);
        [self.mapView setRegion:region animated:YES];
    }
    
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
//    NSDate* eventDate = newLocation.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    NSLog(@"latitude %+.6f, longitude %+.6f\n",
//          newLocation.coordinate.latitude,
//          newLocation.coordinate.longitude);
//    NSLog(@"Horizontal Accuracy:%f", newLocation.horizontalAccuracy);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
