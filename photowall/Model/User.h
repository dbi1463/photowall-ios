#import "_User.h"

@interface User : _User {}

- (instancetype)initWithJson:(id)json;

@end

@interface User (JSON)

- (void)updateWithJson:(id)json;

@end
