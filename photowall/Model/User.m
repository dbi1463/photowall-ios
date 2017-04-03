#import "User.h"

#import <MagicalRecord/MagicalRecord.h>

@interface User ()

// Private interface goes here.

@end


@implementation User

- (instancetype)initWithJson:(id)json {
	if (self = [super initWithContext:[NSManagedObjectContext MR_defaultContext]]) {
		self.identifier = [json objectForKey:@"id"];
		[self updateWithJson:json];
	}
	return self;
}

@end

@implementation User (JSON)

- (void)updateWithJson:(id)json {
	self.nickname = [json objectForKey:@"nickname"];
}

@end
