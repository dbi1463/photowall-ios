//
//  LocationAwarePhotoUploadTask.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "LocationAwarePhotoUploadTask.h"

#import "RestClient.h"

@implementation LocationAwarePhotoUploadTask {
	NSData* _data;
	RestClient* _client;
	CLLocationManager* _manager;
}

- (instancetype)initWithData:(NSData*)data {
	if (self = [super init]) {
		_data = data;
		_manager = [CLLocationManager new];
		_manager.delegate = self;
	}
	return self;
}

- (void)uploadWithClient:(RestClient*)client andHandler:(PhotoHandler)handler {
	_client = client;
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status != kCLAuthorizationStatusAuthorizedWhenInUse) {
		[_manager requestWhenInUseAuthorization];
	}
}


- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[manager requestLocation];
	}
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray<CLLocation*> *)locations {
	RestRequest* request = [_client path:@"/photos"];
	CLLocation* location = locations.firstObject;
	if (location != nil) {
		NSString* geolocation = [NSString stringWithFormat:@"geo:%@,%@", @(location.coordinate.latitude), @(location.coordinate.longitude)];
		[request setValue:geolocation forHeader:@"Geolocation"];
	}
	
}

@end
