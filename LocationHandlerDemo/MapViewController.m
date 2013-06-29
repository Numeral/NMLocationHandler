//
//  MapViewController.m
//
//  Created by Numeral on 4/23/13.
//

#import "MapViewController.h"
#import "NMLocationHandler.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NMLocationHandler *locationHandler;
- (IBAction)showLocation:(id)sender;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NMLocationHandler *)locationHandler {
    
    if (!_locationHandler) {
        
        _locationHandler = [[NMLocationHandler alloc] init];
    }
    return _locationHandler;
}


#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}


- (void)viewDidUnload {
    
    [self setMapView:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pinAnnotationVeiw = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!pinAnnotationVeiw)
    {
        pinAnnotationVeiw = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinAnnotationVeiw.draggable = YES;
        pinAnnotationVeiw.canShowCallout = NO;
        pinAnnotationVeiw.animatesDrop = YES;
        [pinAnnotationVeiw setSelected:YES animated:NO];
    }
    
    pinAnnotationVeiw.annotation = annotation;
    
    return pinAnnotationVeiw;
}


- (IBAction)showLocation:(id)sender {
    
    [self.locationHandler currentLocationWithCompletion:^(CLLocation *location, NSError *error) {
        
        if (error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        } else {
        
        //center
        MKCoordinateRegion mapRegion;
        mapRegion.center = location.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        [self.mapView setRegion:mapRegion animated:NO];
        
        //drop pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        [self.mapView addAnnotation:annotation];
        }
    }];
}
@end
