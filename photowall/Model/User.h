#import "_User.h"

@interface User : _User {}

- (instancetype)initWithJson:(id)json;

@property (nonatomic) NSDate* lastUpdated;

@property (nonatomic, readonly) NSString* portraitPath;

@end

@interface User (JSON)

- (void)updateWithJson:(id)json;

@end
