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
    [self.mapView setZoomEnabled:YES];
    self.mapView.delegate = self;
}


-(void) initialiseZombieAnnotations
{
    for (int i = 0; i < self.zombieHandler.zombies.count; i++)
    {
        //draw annotation for each at position
        ZombieAnnotation* annotation = [[ZombieAnnotation alloc] init];
        Zombie* zombie = [self.zombieHandler.zombies objectAtIndex:i];
        annotation.coordinate = zombie.currentPosition;
        zombie.annotation = annotation;
        [self.mapView addAnnotation:annotation];
    }
}

-(void) initialiseSafeRoomAnnotation
{
    //draw annotation for safeRoom
    SafeRoomAnnotation* annotation = [[SafeRoomAnnotation alloc] init];
    SafeRoom* safeRoom = self.zombieHandler.safeRoom;
    annotation.coordinate = safeRoom.safeRoomLocation;
    safeRoom.annotation = annotation;
    [self.mapView addAnnotation:annotation];
}


-(void) update
{
    // NSLog(@"updating");
    if (self.zombieHandler)
        [self.zombieHandler update:self.mapView.userLocation.coordinate];
    
    [self performSelector:@selector(update) withObject:self afterDelay:1/30.0f ];
}

//map view
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( [annotation isKindOfClass: [ZombieAnnotation class]] )
    {
        //attempt to re-use old pin views.
        MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"mapViewUserAnnotation"];
        
        if( !pinView )
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"zombieAnnotation"];
        }
        // NSLog(@"back doing bad things");
        
        pinView.canShowCallout = NO;
        pinView.annotation = annotation;
        
        pinView.image = [UIImage imageNamed:@"zombie.png"];
        
        pinView.hidden = NO;
        pinView.draggable = YES;
        //pinView.pinColor = MKPinAnnotationColorRed;
        //  NSLog(@"Created zombie annotation view lat:%f, lng: %f", pinView.);
        
        return pinView;
    }
    else if ([annotation isKindOfClass:[SafeRoomAnnotation class]])
    {
        //attempt to re-use old pin views.
        MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"safeRoomAnnotation"];
        
        if( !pinView )
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"safeRoomAnnotation"];
        }
        // NSLog(@"back doing bad things");
        
        pinView.canShowCallout = NO;
        pinView.annotation = annotation;
        
        pinView.image = [UIImage imageNamed:@"saferoom.png"];
        
        pinView.hidden = NO;
        pinView.draggable = YES;
        //pinView.pinColor = MKPinAnnotationColorRed;
        //  NSLog(@"Created zombie annotation view lat:%f, lng: %f", pinView.);
        
        return pinView;

    }
    else{
        
        if (annotation == self.mapView.userLocation)
            return nil;
    }
    return nil;
}


- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Updated User Location");
    if (!m_receivedInitialLocation)
    {
        m_receivedInitialLocation = YES;
        MKUserLocation* userLocation = self.mapView.userLocation;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 4000, 4000);
        [self.mapView setRegion:region animated:YES];
        
        //now we know where are (roughly) we can generate the zomboids
        CLLocationCoordinate2D  location = userLocation.coordinate;
        self.zombieHandler = [[ZombieHandler alloc] initWithUserLocation:location];
        [self initialiseZombieAnnotations];
        
        //....and the safe room
        [self initialiseSafeRoomAnnotation];
        
        //finally get cracking!
        [self update];
        
    }
    //  else
    //    self.mapView.centerCoordinate = userLocation.location.coordinate;
}


///location manager

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
