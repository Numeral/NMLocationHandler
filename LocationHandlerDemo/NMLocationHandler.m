//
//  NMLocationHandler.m
//
//  Created by Numeral on 4/24/13.
//

#import "NMLocationHandler.h"

@interface NMLocationHandler () <CLLocationManagerDelegate>

@property (nonatomic, copy) NMLocationCompletionBlock locationCompletionBlock;
@property (nonatomic, copy) NMHeadingCompletionBlock headingCompletionBlock;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL updatingLocation;
@property (nonatomic) BOOL updatingHeading;
@end


@implementation NMLocationHandler


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


#pragma mark - Methods


- (void)currentLocationWithCompletion:(NMLocationCompletionBlock)completion {
    
    self.locationCompletionBlock = completion;
    
    if (!self.updatingLocation) {
        
        if ([CLLocationManager locationServicesEnabled]) {
            self.updatingLocation = YES;
            [self.locationManager startUpdatingLocation];
        } else {
            
            NSError *error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Location services disabled"}];
            [self locationCompletionBlock](nil, error);
            self.updatingLocation = NO;
        }
    } else {
        
        NSError *error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:2 userInfo:@{NSLocalizedDescriptionKey:@"Updating location"}];
        [self locationCompletionBlock](nil, error);
        self.updatingLocation = NO;
    }
}



- (void)currentHeadingWithCompletion:(NMHeadingCompletionBlock)completion {
    
    self.headingCompletionBlock = completion;
    
    if (!self.updatingHeading) {
        
        if ([CLLocationManager headingAvailable]) {
            self.updatingHeading = YES;
            [self.locationManager startUpdatingHeading];
        } else {
            
            NSError *error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:3 userInfo:@{NSLocalizedDescriptionKey:@"Heading information not avaliable"}];
            [self headingCompletionBlock](nil, error);
            self.updatingHeading = NO;
        }
    } else {
        
        NSError *error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:4 userInfo:@{NSLocalizedDescriptionKey:@"Updating heading"}];
        [self headingCompletionBlock](nil, error);
        self.updatingHeading = NO;
    }
}


#pragma mark - CLLocationManager Delegate

#pragma mark - Heading

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    [manager stopUpdatingHeading];
    
    NSError *error = nil;
    if (!newHeading) {
        error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:5 userInfo:@{NSLocalizedDescriptionKey:@"Could not get heading information"}];
    }
    [self headingCompletionBlock](newHeading, error);
    self.updatingHeading = NO;
}


#pragma mark - Location


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    
    NSError *error = nil;
    if (!newLocation) {
        error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Could not get location"}];
    }
    [self locationCompletionBlock](newLocation, error);
    self.updatingLocation = NO;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    
    NSError *error = nil;
    if (!locations) {
        error = [NSError errorWithDomain:@"NMLocationHandlerDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Could not get location"}];
    }
    [self locationCompletionBlock]([locations lastObject], error);
    self.updatingLocation = NO;
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.updatingLocation) {
        
        [self locationCompletionBlock](nil, error);
        self.updatingLocation = NO;
    } else if (self.updatingHeading) {
        [self headingCompletionBlock](nil, error);
        self.updatingHeading = NO;
    }
}


@end