//
//  AppConfigBridge.m
//  UIKit+SwiftUI_template
//
//  Created by o.sander on 08.06.2023.
//  
//
    
#import "AppConfigBridge.h"

@interface AppConfigBridge()

@property(nonnull, copy) NSString *baseURL;
@property(assign) BOOL loggingEnabled;

@end

@implementation AppConfigBridge

- (instancetype)init
{
    self = [super init];
    if (self) {

    #ifdef NETWORK_BASE_URL
        [self setBaseURL: NETWORK_BASE_URL];
    #else
        #error Cant find NETWORK_BASE_URL. Please setup xcconfig file
    #endif

    #ifdef LOGGING_ENABLED
        [self setLoggingEnabled: LOGGING_ENABLED];
    #else
        #error Cant find LOGGING_ENABLED. Please setup xcconfig file
    #endif

    }
    return self;
}

@end
