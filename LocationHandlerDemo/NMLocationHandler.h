//
//  NMLocationHandler.h
//
//  Created by Numeral on 4/24/13.
//


/*
// Simple CLLLocationManager wrapper allows you determine current location and heading by calling appropriate method with a block.
*/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^NMLocationCompletionBlock)(CLLocation *location, NSError *error);
typedef void(^NMHeadingCompletionBlock)(CLHeading *heading, NSError *error);

@interface NMLocationHandler : NSObject

- (void)currentLocationWithCompletion:(NMLocationCompletionBlock)completion;
- (void)currentHeadingWithCompletion:(NMHeadingCompletionBlock)completion;

@end
