//
//  BKReachability.m
//  BlockKit
//

#import "BKReachability.h"


// Private Methods
@interface BKReachability ()

- (NSArray *)_handlers;

@end

// Private Functions
void BKNetworkReachabilityCallBack(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);
const void *BKReachabilityRetain(const void *info);
void BKReachabilityRelease(const void *info);
CFStringRef BKReachabilityCopyDescription(const void *info);

void BKNetworkReachabilityCallBack(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
	BKReachability *reach = (BKReachability *)info;
	NSArray *allHandlers = [reach _handlers];
	
	for (void (^currHandler)(SCNetworkReachabilityFlags flags) in allHandlers) {
		currHandler(flags);
	}
}

const void *BKReachabilityRetain(const void *info) {
	BKReachability *reach = (BKReachability *)info;
	return (void *)[reach retain];
}

void BKReachabilityRelease(const void *info) {
	BKReachability *reach = (BKReachability *)info;
	[reach release];
}

CFStringRef BKReachabilityCopyDescription(const void *info) {
	BKReachability *reach = (BKReachability *)info;
	return (CFStringRef)[reach description];
}


@implementation BKReachability

#pragma mark Static Methods

+ (BKReachability *)sharedInstance;
{
    static BKReachability *sharedInstance = nil;    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BKReachability alloc] init];
    });
        
    return sharedInstance;
}

+ (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;
{	
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
		// if target host is not reachable
		return NO;
	}
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		return YES;
	}
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
		// ... and the connection is on-demand (or on-traffic) if the
		//     calling application is using the CFSocketStream or higher APIs
		
		if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
			// ... and no [user] intervention is needed
			return YES;
		}
	}
	
	return NO;
}

#pragma mark Initialization

- (id)init;
{
	if (!(self = [super init])) {
        return nil;
	}
	
	_handlerByOpaqueObject = [[NSMutableDictionary alloc] init];
	
	struct sockaddr zeroAddr;
	bzero(&zeroAddr, sizeof(zeroAddr));
	zeroAddr.sa_len = sizeof(zeroAddr);
	zeroAddr.sa_family = AF_INET;
	
	_reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
	SCNetworkReachabilityContext context;
	context.version = 0;
	context.info = (void *)self;
	context.retain = BKReachabilityRetain;
	context.release = BKReachabilityRelease;
	context.copyDescription = BKReachabilityCopyDescription;
	
	if (SCNetworkReachabilitySetCallback(_reachabilityRef, BKNetworkReachabilityCallBack, &context)) {
		SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	}
	
	return self;
}

- (void)dealloc;
{
    if (_reachabilityRef != NULL) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
    }
	
	[_handlerByOpaqueObject release];
	_handlerByOpaqueObject = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (id)addHandler:(void (^)(SCNetworkReachabilityFlags flags))handler;
{
	NSString *obj = [[NSProcessInfo processInfo] globallyUniqueString];
	[_handlerByOpaqueObject setObject:[[handler copy] autorelease] forKey:obj];
	return obj;
}

- (void)removeHandler:(id)opaqueObject;
{
	[_handlerByOpaqueObject removeObjectForKey:opaqueObject];
}

- (BOOL)isCurrentlyReachable;
{
	return [[self class] isReachableWithFlags:[self currentReachabilityFlags]];
}

- (SCNetworkReachabilityFlags)currentReachabilityFlags;
{
    SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(_reachabilityRef, &flags);
    return flags;
}

#pragma mark Private Methods

- (NSArray *)_handlers;
{
	return [_handlerByOpaqueObject allValues];
}

@end
