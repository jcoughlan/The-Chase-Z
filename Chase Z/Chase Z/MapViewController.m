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
    
    self.overlays = [[NSMutableArray alloc]init];
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
        NSLog(@"Location updates started");
    }
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    self.mapView.delegate = self;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    
    [self.mapView addGestureRecognizer:pinchRecognizer];
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
    dispatch_queue_t update_loop = dispatch_queue_create("chase_z_update_loop", NULL);
    //clear the old overlays
//    [self.mapView removeOverlays:self.overlays];
//
//   
//    //loop through all of the annotations and add the overlays
//    
//    
//    for (int i = 0; i < self.zombieHandler.zombies.count; i++) {
//        Zombie* zombie = [self.zombieHandler.zombies objectAtIndex:i];
//        if (zombie.zombieState.currentState == ZombieStateChasing)
//        {
//            MKCircle *circle = [MKCircle circleWithCenterCoordinate:zombie.currentPosition radius:100];
//            [circle  setTitle:@"ZombieChase"];
//            ////[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//                
//                [self.mapView addOverlay:circle];
//                
//            //}];
//        }
//        else if (zombie.zombieState.currentState == ZombieStateAllerted)
//        {
//            MKCircle *circle = [MKCircle circleWithCenterCoordinate:zombie.currentPosition radius:100];
//            [circle  setTitle:@"ZombieAlert"];
//            //[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//                
//                [self.mapView addOverlay:circle];
//                
//           // }];
//        }
//    }
   // [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
   // }];


    
    //dispatch_async(update_loop, ^{
        if (self.zombieHandler)
            [self.zombieHandler update:self.mapView.userLocation.coordinate];
        
   // });
    // NSLog(@"updating");
    
    
    
    [self performSelector:@selector(update) withObject:self afterDelay:1/30.0f ];
}

#pragma mark -
#pragma mark UIPinchGestureRecognizer

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
    if (pinchRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    MKMapView *aMapView = (MKMapView *)pinchRecognizer.view;
    
    for (id <MKAnnotation>annotation in aMapView.annotations) {
        MKAnnotationView *pinView = [aMapView viewForAnnotation:annotation];
        [self formatAnnotationView:pinView forMapView:aMapView];
    }
}

- (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView {
    if (pinView)
    {
        MKCoordinateRegion region =  [self.mapView region];
        double latDelta =  region.span.latitudeDelta;
        double lngDelta = region.span.longitudeDelta;
        //  NSLog(@"Resize: latDelta %f : lng Delta %f", latDelta, lngDelta);
        
        double zoomLevel = (latDelta+lngDelta)/2;
        double scale = 1.0-zoomLevel;
        scale *= 0.55;
        
        pinView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark -
#pragma mark MapView



- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    //base the overlay on accuracy
    
    if ([overlay.title isEqualToString:@"ZombieAlert"])
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.2];
    else if ([overlay.title isEqualToString:@"ZombieChase"])
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
    else
            circleView.fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2];
    
    [self.overlays addObject:overlay];
    //self.m_CircleOverlay = overlay;
    return circleView;
}

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
        double scale = 0.4;
        
        pinView.transform = CGAffineTransformMakeScale(scale, scale);
        
        pinView.hidden = NO;
        pinView.draggable = NO;
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
        double scale = 0.4;
        
        pinView.transform = CGAffineTransformMakeScale(scale, scale);
        
        pinView.hidden = NO;
        pinView.draggable = NO;
        //pinView.pinColor = MKPinAnnotationColorRed;
        //  NSLog(@"Created zombie annotation view lat:%f, lng: %f", pinView.);
        
        return pinView;
        
    }
    else if (annotation == self.mapView.userLocation)
    {
        //attempt to re-use old pin views.
        MKAnnotationView* pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"userAnnotation"];
        
        if( !pinView )
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotation"];
        }
        
        pinView.canShowCallout = NO;
        pinView.annotation = annotation;
        
        pinView.image = [UIImage imageNamed:@"player.png"];
        double scale = 0.4;
        
        pinView.transform = CGAffineTransformMakeScale(scale, scale);
        
        pinView.hidden = NO;
        pinView.draggable = NO;
        //pinView.pinColor = MKPinAnnotationColorRed;
        //  NSLog(@"Created zombie annotation view lat:%f, lng: %f", pinView.);
        
        return pinView;
        
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
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
        [self.mapView setRegion:region animated:YES];
        
        
        //now we know where are (roughly) we can generate the zomboids
        CLLocationCoordinate2D  location = userLocation.coordinate;
        self.zombieHandler = [[ZombieHandler alloc] initWithUserLocation:location];
        [self initialiseZombieAnnotations];
        
        //....and the safe room
        [self initialiseSafeRoomAnnotation];
        
        //no need to initalise player annotation as we are using the user view
        
        
        
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
