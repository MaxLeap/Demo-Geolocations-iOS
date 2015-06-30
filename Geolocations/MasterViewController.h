//
//  MasterViewController.h
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//

#import <CoreLocation/CoreLocation.h>

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, strong) NSArray *objects;

- (IBAction)insertCurrentLocation:(id)sender;

@end
