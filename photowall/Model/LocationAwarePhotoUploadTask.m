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
	PhotoHandler _handler;
	CLLocationManager* _manager;
}

#pragma mark - Initializers
- (instancetype)initWithData:(NSData*)data {
	if (self = [super init]) {
		_data = data;
		_manager = [CLLocationManager new];
		_manager.delegate = self;
	}
	return self;
}

#pragma mark - Public Methods
- (void)uploadWithClient:(RestClient*)client andHandler:(PhotoHandler)handler {
	_client = client;
	_handler = handler;
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status != kCLAuthorizationStatusAuthorizedWhenInUse) {
		[_manager requestWhenInUseAuthorization];
	}
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	[self uploadPhotoWithLocation:nil];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[manager requestLocation];
	}
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray<CLLocation*> *)locations {
	CLLocation* location = locations.firstObject;
	[self uploadPhotoWithLocation:location];
}

#pragma mark - Private Methods
- (void)uploadPhotoWithLocation:(CLLocation*)location {
	RestRequest* request = [_client path:@"/photos"];
	if (location != nil) {
		NSString* geolocation = [NSString stringWithFormat:@"geo:%@,%@", @(location.coordinate.latitude), @(location.coordinate.longitude)];
		[request setValue:geolocation forHeader:@"Geolocation"];
	}
	[request upload:_data withMethod:@"POST" andHandler:^(RestResponse* response) {
		if (_handler != nil) {
			Photo* photo = nil;
			if (response.succeeded) {
				photo = [Photo photoFromJson:response.result];
			}
			_handler(response.succeeded ? nil : response.error, @[ photo ]);
		}
	}];
}

@end
