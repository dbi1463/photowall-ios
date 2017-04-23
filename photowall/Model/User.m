#import "User.h"

#import <MagicalRecord/MagicalRecord.h>

@interface User ()

// Private interface goes here.

@end

@implementation User

@synthesize lastUpdated;

- (instancetype)initWithJson:(id)json {
	if (self = [super initWithContext:[NSManagedObjectContext MR_defaultContext]]) {
		self.identifier = [json objectForKey:@"id"];
		[self updateWithJson:json];
	}
	return self;
}

- (NSString*)portraitPath {
	if (self.lastUpdated == nil) {
		self.lastUpdated = [NSDate new];
	}
	return [NSString stringWithFormat:@"/portraits/%@?lastUpdated=%@", self.identifier, @(self.lastUpdated.timeIntervalSince1970)];
}

@end

@implementation User (JSON)

- (void)updateWithJson:(id)json {
	self.nickname = [json objectForKey:@"nickname"];
	self.lastUpdated = [NSDate new];
}

@end
