//
//  NSObject-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/13/09.
//  KVO block support by Andy Matuschak
//

#import "NSObject-BKAdditions.h"
#import <dispatch/dispatch.h>
#import <objc/runtime.h>


static NSMutableDictionary *associationDictionary = nil;
static NSString *const BKObserverTrampolineContext = @"BKObserverTrampolineContext";
static NSString *const BKObserverMapKey = @"org.andymatuschak.observerMap";
static dispatch_queue_t BKObserverMutationQueue = NULL;


// Private Classes
@interface BKObserverTrampoline : NSObject {
    __weak id observee;
    NSString *keyPath;
    BKTaskBlock task;
    NSOperationQueue *queue;
    dispatch_once_t cancellationPredicate;
}

- (BKObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(BKTaskBlock)task;
- (void)cancelObservation;

@end


// Private Functions
static dispatch_queue_t BKObserverMutationQueueCreatingIfNecessary();


@implementation NSObject (BKAdditions)

#pragma mark Public Methods

- (void)performAfterDelay:(NSTimeInterval)delay usingBlock:(BKVoidBlock)block;
{
    [self performSelector:@selector(_executeBlock:) withObject:[block copy] afterDelay:delay];
}

- (void)performOnMainThreadUsingBlock:(BKVoidBlock)block;
{
    [self performSelectorOnMainThread:@selector(_executeBlock:) withObject:[block copy] waitUntilDone:YES];
}

- (id)addObserverForKeyPath:(NSString *)keyPath task:(BKTaskBlock)task;
{
    return [self addObserverForKeyPath:keyPath onQueue:nil task:task];
}

- (id)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(BKTaskBlock)task
{
    id identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    
    dispatch_sync(BKObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *dict = objc_getAssociatedObject(self, BKObserverMapKey);
        
        if (!dict) {
            dict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, BKObserverMapKey, dict, OBJC_ASSOCIATION_RETAIN);
            [dict release];
        }
        
        BKObserverTrampoline *trampoline = [[BKObserverTrampoline alloc] initObservingObject:self keyPath:keyPath onQueue:queue task:task];
        [dict setObject:trampoline forKey:identifier];
        [trampoline release];
    });
    
    return identifier;
}

- (void)removeObserverWithIdentifier:(id)identifier;
{
    dispatch_sync(BKObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, BKObserverMapKey);
        BKObserverTrampoline *trampoline = [observationDictionary objectForKey:identifier];
        
        if (!trampoline) {
            NSLog(@"[NSObject(BKBlockObservation) removeObserverWithIdentifier]: Ignoring attempt to remove non-existent observer on %@ for identifier %@.", self, identifier);
            return;
        }
        
        [trampoline cancelObservation];
        [observationDictionary removeObjectForKey:identifier];
        
        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC.
        if ([observationDictionary count] == 0) {
            objc_setAssociatedObject(self, BKObserverMapKey, nil, OBJC_ASSOCIATION_RETAIN);
        }
    });
}

- (void *)associationKeyForPropertyName:(NSString *)propertyName;
{
    if (!associationDictionary) {
        associationDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *associationKey = [associationDictionary objectForKey:propertyName];
    if (associationKey == nil) {
        associationKey = [[propertyName copy] autorelease];
        [associationDictionary setObject:associationKey forKey:propertyName];
    }
    
    return associationKey;
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;
{
    Method origMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if (class_addMethod([self class], originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod([self class], newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

#pragma mark Private Methods

- (void)_executeBlock:(BKVoidBlock)block;
{
    if (block) {
        block();
        [block release];
    }
}

@end


@implementation BKObserverTrampoline

#pragma mark Initialization

- (BKObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)newKeyPath onQueue:(NSOperationQueue *)newQueue task:(BKTaskBlock)newTask;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    task = [newTask copy];
    keyPath = [newKeyPath copy];
    queue = [newQueue retain];
    observee = obj;
    cancellationPredicate = 0;
    [observee addObserver:self forKeyPath:keyPath options:0 context:BKObserverTrampolineContext];
    
    return self;
}

- (void)dealloc;
{
    [self cancelObservation];
    [task release];
    [keyPath release];
    [queue release];
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)cancelObservation;
{
    dispatch_once(&cancellationPredicate, ^{
        [observee removeObserver:self forKeyPath:keyPath];
        observee = nil;
    });
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (context == BKObserverTrampolineContext) {
        if (queue) {
            [queue addOperationWithBlock:^{
                task(object, change);
            }];
        } else {
            task(object, change);
        }
    }
}

@end


static dispatch_queue_t BKObserverMutationQueueCreatingIfNecessary()
{
    static dispatch_once_t queueCreationPredicate = 0;
    dispatch_once(&queueCreationPredicate, ^{
        BKObserverMutationQueue = dispatch_queue_create("org.andymatuschak.observerMutationQueue", 0);
    });
    return BKObserverMutationQueue;
}
