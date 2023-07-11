
    
#import <Foundation/Foundation.h>

@interface AppConfigBridge: NSObject

@property(nonnull, copy, readonly) NSString *baseURL;
@property(assign, readonly) BOOL loggingEnabled;

@end
