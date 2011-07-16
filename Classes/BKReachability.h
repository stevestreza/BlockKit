//
//  BKReachability.h
//  BlockKit
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


@interface BKReachability : NSObject {
	NSMutableDictionary *_handlerByOpaqueObject;
	SCNetworkReachabilityRef _reachabilityRef;
}

+ (BKReachability *)sharedInstance;

// Returns an opaque object used for removal later
- (id)addHandler:(void (^)(SCNetworkReachabilityFlags flags))handler;
- (void)removeHandler:(id)opaqueObject;

- (BOOL)isCurrentlyReachable;
- (SCNetworkReachabilityFlags)currentReachabilityFlags;
+ (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end
