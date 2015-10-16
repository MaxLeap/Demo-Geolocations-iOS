//
//  MasterViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SearchViewController.h"

@implementation MasterViewController
@synthesize locationManager = _locationManager;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"geoPointAnnotiationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotiationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    // Start updating locations when the app returns to the foreground.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)appWillResignActive:(NSNotification *)notification {
    // Stop updating locations while in the background.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // Row selection
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MLObject *object = [self.objects objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetailItem:object];
    } else if ([segue.identifier isEqualToString:@"showSearch"]) {
        // Search button
        [segue.destinationViewController setInitialLocation:self.locationManager.location];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	}
    
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 3;
	}

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    
    // Configure the cell
    MLObject *object = self.objects[indexPath.row];
    MLGeoPoint *gp = object[@"location"];
    
    [MLGeoPoint geoPointForCurrentLocationInBackground:^(MLGeoPoint *geoPoint, NSError *error) {
        if (geoPoint) {
            double dis = [geoPoint distanceInKilometersTo:gp];
            NSString *string = [NSString stringWithFormat:@"%@, %@ (%.3f)",
                                [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
                                [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]], dis];
            cell.detailTextLabel.text = string;
        }
    }];
    
	cell.textLabel.text = [dateFormatter stringFromDate:object.updatedAt];
    
    NSString *string = [NSString stringWithFormat:@"%@, %@",
						[numberFormatter stringFromNumber:[NSNumber numberWithDouble:gp.latitude]],
						[numberFormatter stringFromNumber:[NSNumber numberWithDouble:gp.longitude]]];
    
    cell.detailTextLabel.text = string;
    
    return cell;
}

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from MaxLeap and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to MaxLeap
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

/**
 Conditionally enable the Search/Add buttons:
 If the location manager is generating updates, then enable the buttons;
 If the location manager is failing, then disable the buttons.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


#pragma mark - MasterViewController

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
	
	return _locationManager;
}

- (IBAction)insertCurrentLocation:(id)sender {
    
	// If it's not possible to get a location, then return.
	CLLocation *location = self.locationManager.location;
	if (!location) {
		return;
	}

	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
    MLGeoPoint *geoPoint = [MLGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    MLObject *object = [MLObject objectWithClassName:@"Location"];
    [object setObject:geoPoint forKey:@"location"];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self loadObjects];
        }
    }];
}

- (void)loadObjects {
    // If it's not possible to get a location, then return.
    CLLocation *location = self.locationManager.location;
    if (!location) {
        return;
    }
    
    // Configure the new event with information from the location.
    CLLocationCoordinate2D coordinate = [location coordinate];
    MLGeoPoint *geoPoint = [MLGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    MLQuery *query = [MLQuery queryWithClassName:@"Location"];
    if (geoPoint) {
        [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:1];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (nil == error) {
                self.objects = objects;
                [self.tableView reloadData];
            }
        }];
    }
}

@end