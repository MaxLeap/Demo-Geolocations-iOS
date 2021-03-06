//
//  GeoPointAnnotation.h
//  Geolocations
//
//  Created by Héctor Ramos on 8/2/12.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GeoPointAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(MLObject *)aObject;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
