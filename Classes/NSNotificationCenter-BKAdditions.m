//
//  NSNotificationCenter-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 12/14/10.
//

#import "NSNotificationCenter-BKAdditions.h"


// Private Methods
@interface NSNotificationCenter ()

+ (NSMutableDictionary *)observerOwners;

@end


@implementation NSNotificationCenter (BKAdditions)

#pragma mark Static Methods

+ (NSMutableDictionary *)observerOwners;
{
    static NSMutableDictionary *observerOwners = nil;
    
    if (!observerOwners) {
        observerOwners = [[NSMutableDictionary alloc] init];
    }
    
    return observerOwners;
}

#pragma mark Public Methods

- (void)addObserverForName:(NSString *)name object:(id)object queue:(NSOperationQueue *)queue owner:(id)owner usingBlock:(void (^)(NSNotification *))block;
{
    if (!name.length) {
        return;
    }
    
    NSMutableArray *observers = [[NSNotificationCenter observerOwners] objectForKey:owner];
    if (observers) {
        __block BOOL found = NO;
        
        // make sure we don't already have an observer with this name and object pair
        [observers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BOOL nameMatch = NO;
            if ([name isEqualToString:[obj safeObjectForKey:@"name"]]) {
                nameMatch = YES;
            }
            
            BOOL objectMatch = NO;
            if (object) {
                objectMatch = [object isEqual:[obj safeObjectForKey:@"object"]];
            } else {
                objectMatch = YES;
            }
            
            if (objectMatch && nameMatch) {
                *stop = found = YES;
            }
        }];
        
        if (found) {
            return;
        }
    } else {
        // keep track of all the observers this owner's responsible for
        observers = [NSMutableArray array];
        
        // use an uncopied key so we don't try to copy the owner (likely a UIView, UIViewController, etc)
        [[NSNotificationCenter observerOwners] setObject:observers forRetainedKey:owner];
    }
    
    id observer = [self addObserverForName:name object:object queue:queue usingBlock:block];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setSafeObject:name forKey:@"name"];
    [userInfo setSafeObject:object forKey:@"object"];
    [userInfo setSafeObject:observer forKey:@"observer"];
    [observers addObject:userInfo];
}

- (void)removeObserversWithOwner:(id)owner;
{
    NSMutableArray *observers = [[NSNotificationCenter observerOwners] objectForKey:owner];
    if (!observers) {
        return;
    }
    
    for (NSDictionary *userInfo in observers) {
        [self removeObserver:[userInfo objectForKey:@"observer"]];
    }
    
    [[NSNotificationCenter observerOwners] removeObjectForKey:owner];
}

- (void)removeObserversWithOwner:(id)owner name:(NSString *)name object:(id)object;
{
    NSMutableArray *observers = [[NSNotificationCenter observerOwners] objectForKey:owner];
    if (!observers) {
        return;
    }
    
    [observers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSDictionary *userInfo = (NSDictionary *)obj;
        BOOL match = name ? [name isEqualToString:[userInfo safeObjectForKey:@"name"]] : YES;
        match = match && (object ? [object isEqual:[userInfo safeObjectForKey:@"object"]] : YES);
        
        if (match) {
            [self removeObserver:[userInfo safeObjectForKey:@"observer"] name:[userInfo safeObjectForKey:@"name"] object:[userInfo safeObjectForKey:@"object"]];
            [observers removeObjectAtIndex:index];
        }
    }];
    
    // release the array so we don't keep this around indefinitely
    if (!observers.count) {
        [[NSNotificationCenter observerOwners] removeObjectForKey:owner];
    }
}

@end
